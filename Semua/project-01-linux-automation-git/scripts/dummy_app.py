#!/usr/bin/env python3
"""
Dummy Python Backend Web Application
Digunakan untuk simulasi service yang berjalan di bawah Systemd & Nginx Reverse Proxy.
"""

import http.server
import socketserver
import signal
import sys
import time
import os

PORT = int(os.environ.get("APP_PORT", 8000))
HOST = os.environ.get("APP_HOST", "127.0.0.1")
LOG_FILE = "/var/log/my-app/app.log"

class GracefulHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        response = {
            "status": "online",
            "service": "my-python-app",
            "timestamp": time.time(),
            "message": "Hello from Systemd Managed Backend App!"
        }
        import json
        self.wfile.write(json.dumps(response).encode("utf-8"))

    def log_message(self, format, *args):
        log_entry = f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {self.address_string()} - {format%args}\n"
        sys.stdout.write(log_entry)
        sys.stdout.flush()
        # Attempt to append log to log file if directory writable
        try:
            if os.path.exists(os.path.dirname(LOG_FILE)):
                with open(LOG_FILE, "a") as f:
                    f.write(log_entry)
        except Exception:
            pass

def handle_shutdown(signum, frame):
    print(f"\n[SIGNAL] Received signal {signum}. Initiating graceful shutdown...")
    sys.exit(0)

def main():
    signal.signal(signal.SIGTERM, handle_shutdown)
    signal.signal(signal.SIGINT, handle_shutdown)

    print(f"Starting Python Backend Server on http://{HOST}:{PORT} (PID: {os.getpid()})")
    
    with socketserver.TCPServer((HOST, PORT), GracefulHandler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            pass
        finally:
            httpd.server_close()
            print("Server stopped cleanly.")

if __name__ == "__main__":
    main()
