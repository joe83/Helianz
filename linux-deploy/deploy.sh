#!/usr/bin/env bash
# =============================================================================
# deploy.sh  –  One-command deployment of HelianzServer on Linux
# =============================================================================
# Usage:
#   bash deploy.sh [OPTIONS]
#
# Options:
#   --src  <path>   Path to the HelianzNew repo (source code).
#                   Defaults to the parent of this script's directory.
#   --db   <file>   Path to a gzipped SQL dump (helianz.sql.gz).
#                   If omitted, the existing database volume is kept as-is.
#   --rebuild       Force a full Docker image rebuild (no cache).
#   --port <n>      Host port for HelianzServer. Default: 9390.
#   --help          Show this help.
#
# Examples:
#   # First-time deploy — run from inside linux-deploy/ within the repo:
#   cd /opt/helianz-src/linux-deploy
#   bash deploy.sh --db data/helianz.sql.gz
#
#   # Explicit --src if running from a different location:
#   bash deploy.sh --src /opt/helianz-src --db data/helianz.sql.gz
#
#   # Rebuild image after source code change, keep existing DB:
#   bash deploy.sh --rebuild
#
#   # Re-import database only (no rebuild):
#   bash deploy.sh --db data/helianz-new.sql.gz
# =============================================================================
set -euo pipefail

# ── Colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
die()     { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Defaults ─────────────────────────────────────────────────────────────────
SRC_DIR="$(dirname "$SCRIPT_DIR")"   # parent of linux-deploy/ = repo root
DB_FILE=""
REBUILD=false
SERVER_PORT=9390

# MySQL credentials (must match docker-compose.yml)
MYSQL_ROOT_PASSWORD="rootrootroot"
MYSQL_DATABASE="helianz"
MYSQL_USER="oduser"
MYSQL_PASSWORD="odpass"

COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yml"
CONTAINER_MYSQL="helianz-mysql-1"

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --src)     SRC_DIR="$2";     shift 2 ;;
        --db)      DB_FILE="$2";     shift 2 ;;
        --rebuild) REBUILD=true;     shift   ;;
        --port)    SERVER_PORT="$2"; shift 2 ;;
        --help|-h)
            sed -n '/^# Usage:/,/^# ====/p' "$0" | sed 's/^# \?//'
            exit 0 ;;
        *) die "Unknown option: $1. Use --help for usage." ;;
    esac
done

# ── Validate prerequisites ────────────────────────────────────────────────────
info "Checking prerequisites..."
command -v docker >/dev/null 2>&1 || die "docker is not installed."
docker compose version >/dev/null 2>&1 || die "'docker compose' plugin not found. Install Docker Compose v2."

info "Source directory: $SRC_DIR"
[[ -f "$SRC_DIR/Helianz.sln" ]] || die "Helianz.sln not found in $SRC_DIR. Set --src to the repo root."

if [[ -n "$DB_FILE" ]]; then
    [[ -f "$DB_FILE" ]] || die "Database dump not found: $DB_FILE"
fi

# ── Ensure the config file exists ─────────────────────────────────────────────
CONFIG_SRC="$SCRIPT_DIR/config/HelianzServerConfig.xml"
[[ -f "$CONFIG_SRC" ]] || die "Config file missing: $CONFIG_SRC"

# ── Generate a temporary docker-compose overlay pointing at SRC_DIR ──────────
info "Preparing compose context (src=$SRC_DIR)..."

# The Dockerfile needs COPY paths relative to the build context.
# We symlink (or use --build-context) to make linux-deploy/ act as the context
# while the source tree is at SRC_DIR.
# Strategy: create a temporary build-context directory with symlinks.
BUILD_CTX="$(mktemp -d /tmp/od-build-ctx.XXXXXX)"
trap 'rm -rf "$BUILD_CTX"' EXIT

# Link everything from the source repo into the build context
for item in "$SRC_DIR"/*/; do
    name="$(basename "$item")"
    ln -s "$item" "$BUILD_CTX/$name"
done
# Also link top-level files the Dockerfile might need
for f in "$SRC_DIR"/*.sln "$SRC_DIR"/*.config; do
    [[ -f "$f" ]] && ln -s "$f" "$BUILD_CTX/$(basename "$f")" 2>/dev/null || true
done

# Copy (not link) the docker/ source files so they're available in context
mkdir -p "$BUILD_CTX/docker"
cp "$SCRIPT_DIR/src/"*  "$BUILD_CTX/docker/"
cp "$CONFIG_SRC"        "$BUILD_CTX/docker/HelianzServerConfig.Docker.xml"

# ── Build the Docker image ─────────────────────────────────────────────────────
info "Building Docker image..."
BUILD_ARGS=(
    --file "$SCRIPT_DIR/Dockerfile"
    --tag  helianz-server-mono:latest
    --build-arg SERVER_PORT="$SERVER_PORT"
)
$REBUILD && BUILD_ARGS+=(--no-cache)

docker build "${BUILD_ARGS[@]}" "$BUILD_CTX"
success "Image built: helianz-server-mono:latest"

# ── Start MySQL (first, so it initialises before we import) ───────────────────
info "Starting MySQL container..."
MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
MYSQL_DATABASE="$MYSQL_DATABASE" \
MYSQL_USER="$MYSQL_USER" \
MYSQL_PASSWORD="$MYSQL_PASSWORD" \
SERVER_PORT="$SERVER_PORT" \
docker compose -f "$COMPOSE_FILE" up -d mysql

info "Waiting for MySQL to be healthy..."
for i in $(seq 1 30); do
    if docker exec "$CONTAINER_MYSQL" mysqladmin ping -h localhost -uroot -p"$MYSQL_ROOT_PASSWORD" --silent 2>/dev/null; then
        success "MySQL is ready."
        break
    fi
    [[ $i -eq 30 ]] && die "MySQL did not become healthy after 60 seconds."
    echo -n "."
    sleep 2
done

# ── Apply grants (idempotent) ─────────────────────────────────────────────────
info "Applying database privileges..."
docker exec -i "$CONTAINER_MYSQL" \
    mysql -uroot -p"$MYSQL_ROOT_PASSWORD" \
    < "$SCRIPT_DIR/src/grant_oduser.sql" 2>&1 | grep -v "Warning" || true
success "Privileges applied."

# ── Import database dump (if provided) ────────────────────────────────────────
if [[ -n "$DB_FILE" ]]; then
    info "Importing database from $DB_FILE ..."
    # Determine if file is gzipped
    if file "$DB_FILE" | grep -q 'gzip'; then
        gunzip -c "$DB_FILE" | docker exec -i "$CONTAINER_MYSQL" \
            mysql -uroot -p"$MYSQL_ROOT_PASSWORD" 2>&1 | grep -v "Warning" || true
    else
        docker exec -i "$CONTAINER_MYSQL" \
            mysql -uroot -p"$MYSQL_ROOT_PASSWORD" \
            < "$DB_FILE" 2>&1 | grep -v "Warning" || true
    fi
    success "Database imported."

    # Verify table count
    TABLE_COUNT=$(docker exec "$CONTAINER_MYSQL" \
        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -N -e \
        "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$MYSQL_DATABASE';" \
        2>/dev/null | tail -1)
    info "Tables in $MYSQL_DATABASE: $TABLE_COUNT"
fi

# ── Start HelianzServer ─────────────────────────────────────────────────────
info "Starting HelianzServer..."
SERVER_PORT="$SERVER_PORT" \
docker compose -f "$COMPOSE_FILE" up -d helianz-server
success "HelianzServer container started."

# ── Verify ────────────────────────────────────────────────────────────────────
info "Verifying endpoint (waiting up to 30s)..."
for i in $(seq 1 15); do
    HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' "http://localhost:$SERVER_PORT/ServiceMain.asmx" 2>/dev/null || echo "000")
    if [[ "$HTTP_CODE" == "200" ]]; then
        echo ""
        success "HelianzServer is up! HTTP $HTTP_CODE"
        break
    fi
    [[ $i -eq 15 ]] && { echo ""; warn "Endpoint not responding yet (got HTTP $HTTP_CODE). Check logs:"; \
        echo "  docker compose -f $COMPOSE_FILE logs helianz-server"; }
    echo -n "."
    sleep 2
done

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  HelianzServer deployed successfully!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  Service URL  :  ${CYAN}http://$(hostname -I | awk '{print $1}'):$SERVER_PORT/ServiceMain.asmx${NC}"
echo ""
echo "  Useful commands:"
echo "    View server logs : docker compose -f $COMPOSE_FILE logs -f helianz-server"
echo "    View MySQL logs  : docker compose -f $COMPOSE_FILE logs -f mysql"
echo "    Restart server   : docker compose -f $COMPOSE_FILE restart helianz-server"
echo "    Stop all         : docker compose -f $COMPOSE_FILE down"
echo "    Wipe DB + restart: docker compose -f $COMPOSE_FILE down -v && bash $0 --src $SRC_DIR --db <dump>"
echo ""
