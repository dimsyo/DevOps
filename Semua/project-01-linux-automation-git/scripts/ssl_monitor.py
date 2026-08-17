#!/usr/bin/env python3
"""
SSL Certificate & HTTP Response Health Monitor (Parallel Check)
Project 01 Challenge: Async/Multithreaded SSL Expiry & HTTP Health Monitor

Membaca list domain/IP dari CSV, mengecek tanggal kedaluwarsa SSL certificate
dan HTTP status code secara paralel (ThreadPoolExecutor / asyncio), serta
mengirimkan alert jika cert expired dalam < 7 hari.
"""

import argparse
import concurrent.futures
import csv
import datetime
import json
import os
import socket
import ssl
import sys
import urllib.request
from typing import Dict, Any, List

# Default Alert Threshold (7 Days)
ALERT_DAYS_THRESHOLD = 7


def check_ssl_expiry(hostname: str, port: int = 443, timeout: int = 5) -> Dict[str, Any]:
    """
    Koneksi via TLS socket untuk membaca metadata sertifikat SSL dan menghitung sisa hari kedaluwarsa.
    """
    context = ssl.create_default_context()
    conn = context.wrap_socket(socket.socket(socket.AF_INET), server_hostname=hostname)
    conn.settimeout(timeout)

    try:
        conn.connect((hostname, port))
        ssl_info = conn.getpeercert()
        
        # Parse notAfter date format: 'MMM DD HH:MM:SS YYYY GMT'
        not_after_str = ssl_info['notAfter']
        expiry_date = datetime.datetime.strptime(not_after_str, "%b %d %H:%M:%S %Y %Z")
        now = datetime.datetime.utcnow()
        days_remaining = (expiry_date - now).days

        return {
            "ssl_valid": True,
            "expiry_date": expiry_date.strftime("%Y-%m-%d %H:%M:%S UTC"),
            "days_remaining": days_remaining,
            "ssl_error": None
        }
    except Exception as e:
        return {
            "ssl_valid": False,
            "expiry_date": "N/A",
            "days_remaining": -1,
            "ssl_error": str(e)
        }
    finally:
        conn.close()


def check_http_status(hostname: str, port: int = 443, timeout: int = 5) -> Dict[str, Any]:
    """
    Mengirimkan HTTP/HTTPS Request untuk memeriksa HTTP Response Status Code.
    """
    protocol = "https" if port == 443 else "http"
    url = f"{protocol}://{hostname}:{port}" if port not in (80, 443) else f"{protocol}://{hostname}"

    req = urllib.request.Request(
        url,
        headers={"User-Agent": "DevOps-SSL-Monitor/1.0"}
    )
    
    # Custom SSL context to allow inspecting HTTP status even if cert has issue
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    try:
        with urllib.request.urlopen(req, timeout=timeout, context=ctx) as response:
            return {
                "http_code": response.getcode(),
                "http_error": None
            }
    except urllib.error.HTTPError as e:
        return {
            "http_code": e.code,
            "http_error": str(e)
        }
    except Exception as e:
        return {
            "http_code": 0,
            "http_error": str(e)
        }


def process_target(target_info: Dict[str, str], threshold_days: int) -> Dict[str, Any]:
    """
    Memproses 1 item domain (SSL + HTTP check) secara independen.
    """
    domain = target_info["domain"].strip()
    port = int(target_info.get("port", 443))

    ssl_res = check_ssl_expiry(domain, port)
    http_res = check_http_status(domain, port)

    days_left = ssl_res["days_remaining"]
    is_warning = ssl_res["ssl_valid"] and (days_left < threshold_days)
    is_error = (not ssl_res["ssl_valid"]) or (http_res["http_code"] >= 400 or http_res["http_code"] == 0)

    status_flag = "OK"
    if is_warning:
        status_flag = "WARNING_EXPIRING_SOON"
    if is_error:
        status_flag = "ERROR"

    return {
        "domain": domain,
        "port": port,
        "days_remaining": days_left,
        "expiry_date": ssl_res["expiry_date"],
        "ssl_valid": ssl_res["ssl_valid"],
        "ssl_error": ssl_res["ssl_error"],
        "http_code": http_res["http_code"],
        "http_error": http_res["http_error"],
        "status_flag": status_flag,
        "is_alert": is_warning or is_error
    }


def send_webhook_alert(webhook_url: str, alert_items: List[Dict[str, Any]]):
    """
    Mengirimkan ringkasan alert ke Discord/Telegram/Generic Webhook jika ada cert expired < 7 hari / error.
    """
    if not webhook_url or not alert_items:
        return

    description = f"🚨 **Found {len(alert_items)} target(s) requiring immediate attention!**\n\n"
    for item in alert_items:
        description += f"• **{item['domain']}** | SSL Days Left: `{item['days_remaining']}` | HTTP Code: `{item['http_code']}` | Flag: `{item['status_flag']}`\n"

    payload = {
        "embeds": [{
            "title": "SSL Expiry & Health Monitor Alert",
            "description": description,
            "color": 16711680,
            "timestamp": datetime.datetime.utcnow().isoformat() + "Z"
        }]
    }

    req = urllib.request.Request(
        webhook_url,
        data=json.dumps(payload).encode('utf-8'),
        headers={'Content-Type': 'application/json'}
    )
    try:
        with urllib.request.urlopen(req, timeout=5):
            print("[LOG] Webhook alert notification sent successfully.")
    except Exception as e:
        print(f"[ERROR] Failed to send webhook alert: {e}")


def main():
    parser = argparse.ArgumentParser(description="Parallel SSL Expiration & HTTP Health Checker")
    parser.add_argument("--file", "-f", default="scripts/targets.csv", help="Path to input CSV file")
    parser.add_argument("--days", "-d", type=int, default=ALERT_DAYS_THRESHOLD, help="Alert threshold in days (default: 7)")
    parser.add_argument("--workers", "-w", type=int, default=10, help="Max parallel worker threads (default: 10)")
    parser.add_argument("--webhook", type=str, default="", help="Optional Webhook URL for alerting")
    args = parser.parse_args()

    if not os.path.exists(args.file):
        print(f"[ERROR] File target CSV '{args.file}' tidak ditemukan!")
        sys.exit(1)

    targets = []
    with open(args.file, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            if "domain" in row and row["domain"].strip():
                targets.append(row)

    if not targets:
        print("[ERROR] Tidak ada target domain valid di dalam CSV!")
        sys.exit(1)

    print(f"=== Starting Parallel SSL & HTTP Health Check ({len(targets)} targets) ===")
    print(f"Alert Threshold: Expiry < {args.days} days\n")

    results = []
    alert_items = []

    # Parallel Execution using ThreadPoolExecutor
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as executor:
        future_to_target = {
            executor.submit(process_target, target, args.days): target for target in targets
        }
        for future in concurrent.futures.as_completed(future_to_target):
            res = future.result()
            results.append(res)
            if res["is_alert"]:
                alert_items.append(res)

    # Print Formatted Table Output
    header_fmt = "{:<25} {:<6} {:<15} {:<12} {:<10} {:<22}"
    row_fmt = "{:<25} {:<6} {:<15} {:<12} {:<10} {:<22}"
    print("-" * 95)
    print(header_fmt.format("DOMAIN", "PORT", "DAYS REMAINING", "HTTP CODE", "SSL VALID", "STATUS FLAG"))
    print("-" * 95)

    for r in results:
        days_str = str(r["days_remaining"]) if r["days_remaining"] >= 0 else "ERR"
        print(row_fmt.format(
            r["domain"][:24],
            r["port"],
            days_str,
            r["http_code"],
            "YES" if r["ssl_valid"] else "NO",
            r["status_flag"]
        ))
    print("-" * 95)

    if alert_items:
        print(f"\n⚠️ ALERT: Terdeteksi {len(alert_items)} domain dengan SSL expired < {args.days} hari atau HTTP Error!")
        if args.webhook:
            send_webhook_alert(args.webhook, alert_items)
    else:
        print(f"\n✅ All domains are healthy and SSL certificates have > {args.days} days remaining.")


if __name__ == "__main__":
    main()
