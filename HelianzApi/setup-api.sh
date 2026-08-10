#!/bin/bash
# ═══════════════════════════════════════════════════════
# HelianzApi — Linux Installation Script (systemd)
# Usage: sudo bash setup-api.sh
# ═══════════════════════════════════════════════════════

set -e

INSTALL_PATH="/opt/helianz-api"
SERVICE_NAME="helianz-api"
PORT="${PORT:-5000}"
DB_SERVER="${DB_SERVER:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-helianz_klt}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"
JWT_KEY="${JWT_KEY:-$(openssl rand -base64 32)}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PUBLISH_DIR="$SCRIPT_DIR/bin/Release/net8.0/publish"
DOTNET_RUNTIME="dotnet-runtime-8.0"

echo "=== HelianzApi Setup ==="

# ── 1. Check root ──
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: This script requires root. Run with sudo." >&2
    exit 1
fi

# ── 2. Install .NET runtime if needed ──
if ! command -v dotnet &>/dev/null; then
    echo "Installing .NET 8 Runtime..."
    if command -v apt-get &>/dev/null; then
        # Ubuntu/Debian
        wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O /tmp/ms-prod.deb
        dpkg -i /tmp/ms-prod.deb
        apt-get update -qq
        apt-get install -y -qq $DOTNET_RUNTIME
        rm /tmp/ms-prod.deb
    elif command -v yum &>/dev/null; then
        # RHEL/CentOS
        rpm -Uvh https://packages.microsoft.com/config/centos/$(rpm -E %{rhel})/packages-microsoft-prod.rpm
        yum install -y $DOTNET_RUNTIME
    elif command -v dnf &>/dev/null; then
        dnf install -y $DOTNET_RUNTIME
    else
        echo "ERROR: Cannot install .NET. Install manually from https://dotnet.microsoft.com/en-us/download/dotnet/8.0" >&2
        exit 1
    fi
fi

# ── 3. Publish API ──
if [[ ! -f "$PUBLISH_DIR/HelianzApi.dll" ]]; then
    echo "Publishing HelianzApi..."
    if [[ ! -f "$SCRIPT_DIR/HelianzApi.csproj" ]]; then
        echo "ERROR: HelianzApi.csproj not found at $SCRIPT_DIR" >&2
        exit 1
    fi
    cd "$SCRIPT_DIR"
    dotnet publish -c Release -o "$PUBLISH_DIR" --no-self-contained
fi

# ── 4. Stop existing service ──
if systemctl is-active --quiet $SERVICE_NAME; then
    echo "Stopping existing service..."
    systemctl stop $SERVICE_NAME
fi
if systemctl is-enabled --quiet $SERVICE_NAME 2>/dev/null; then
    systemctl disable $SERVICE_NAME
fi

# ── 5. Copy files ──
echo "Installing to $INSTALL_PATH ..."
rm -rf "$INSTALL_PATH"
mkdir -p "$INSTALL_PATH/logs"
cp -r "$PUBLISH_DIR"/* "$INSTALL_PATH/"
chown -R www-data:www-data "$INSTALL_PATH" 2>/dev/null || chown -R 1000:1000 "$INSTALL_PATH"

# ── 6. Create appsettings.json ──
cat > "$INSTALL_PATH/appsettings.json" << EOF
{
  "Database": {
    "Server": "$DB_SERVER",
    "Port": $DB_PORT,
    "Database": "$DB_NAME",
    "User": "$DB_USER",
    "Password": "$DB_PASSWORD",
    "Pooling": true,
    "MinPoolSize": 2,
    "MaxPoolSize": 50
  },
  "Jwt": {
    "Key": "$JWT_KEY",
    "ExpiryHours": 24
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  }
}
EOF
echo "Configuration saved."

# ── 7. Create systemd service ──
cat > "/etc/systemd/system/$SERVICE_NAME.service" << EOF
[Unit]
Description=Helianz Dental Practice Management API
After=network.target

[Service]
Type=notify
WorkingDirectory=$INSTALL_PATH
ExecStart=/usr/bin/dotnet $INSTALL_PATH/HelianzApi.dll --urls "http://0.0.0.0:$PORT"
Restart=always
RestartSec=10
KillSignal=SIGINT
User=www-data
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false
StandardOutput=append:$INSTALL_PATH/logs/stdout.log
StandardError=append:$INSTALL_PATH/logs/stderr.log

[Install]
WantedBy=multi-user.target
EOF

# ── 8. Start service ──
systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME
sleep 3

if systemctl is-active --quiet $SERVICE_NAME; then
    echo ""
    echo "=== INSTALLATION COMPLETE ==="
    echo "Service:  $SERVICE_NAME"
    echo "URL:      http://localhost:$PORT"
    echo "Swagger:  http://localhost:$PORT/swagger"
    echo "Path:     $INSTALL_PATH"
    echo "Logs:     $INSTALL_PATH/logs"
    echo ""
    echo "Service commands:"
    echo "  Stop:    systemctl stop $SERVICE_NAME"
    echo "  Start:   systemctl start $SERVICE_NAME"
    echo "  Restart: systemctl restart $SERVICE_NAME"
    echo "  Status:  systemctl status $SERVICE_NAME"
    echo "  Logs:    journalctl -u $SERVICE_NAME -f"
else
    echo "WARNING: Service did not start. Check: journalctl -u $SERVICE_NAME"
fi
