#!/bin/bash
set -e

# Update packages and install Nginx
yum update -y
yum install -y nginx

# Get Instance Metadata (IMDSv2)
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

# Create Web Root Index HTML Page
cat <<HTML > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AWS Modular Terraform Application Tier</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0f172a; color: #f8fafc; margin: 0; padding: 40px; display: flex; justify-content: center; align-items: center; min-height: 80vh; }
        .card { background: #1e293b; border-radius: 12px; padding: 32px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); border: 1px solid #334155; max-width: 600px; width: 100%; }
        h1 { color: #38bdf8; font-size: 24px; margin-bottom: 8px; border-bottom: 2px solid #334155; padding-bottom: 12px; }
        p { font-size: 15px; color: #94a3b8; line-height: 1.6; }
        .badge { background: #0284c7; color: white; padding: 4px 8px; border-radius: 6px; font-weight: bold; font-size: 13px; }
        .info-table { width: 100%; margin-top: 20px; border-collapse: collapse; }
        .info-table td { padding: 10px 0; border-bottom: 1px solid #334155; }
        .info-table td:first-child { font-weight: bold; color: #cbd5e1; width: 40%; }
        .info-table td:last-child { font-family: monospace; color: #f43f5e; font-size: 14px; }
        .status { display: inline-block; width: 10px; height: 10px; background-color: #22c55e; border-radius: 50%; margin-right: 6px; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🚀 AWS Modular Infrastructure</h1>
        <p>Aplikasi web ini berjalan pada <strong>Private Subnet</strong> di bawah naungan <strong>Auto Scaling Group</strong> & <strong>Application Load Balancer</strong>.</p>
        <table class="info-table">
            <tr>
                <td>Status Node</td>
                <td><span class="status"></span>ONLINE (Healthy)</td>
            </tr>
            <tr>
                <td>Instance ID</td>
                <td>$INSTANCE_ID</td>
            </tr>
            <tr>
                <td>Availability Zone</td>
                <td><span class="badge">$AVAILABILITY_ZONE</span></td>
            </tr>
            <tr>
                <td>Private IP Address</td>
                <td>$PRIVATE_IP</td>
            </tr>
        </table>
    </div>
</body>
</html>
HTML

# Enable and start Nginx service
systemctl enable nginx
systemctl restart nginx
