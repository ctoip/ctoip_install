#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] docker 未安装，请先安装 Docker" >&2
  exit 1
fi

if docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD=(docker-compose)
else
  echo "[ERROR] 未检测到 docker compose / docker-compose" >&2
  exit 1
fi

if [[ ! -f .env ]]; then
  if [[ -f .env.example ]]; then
    cp .env.example .env
    echo "[INFO] 已生成 .env，请先编辑其中敏感配置后再重试。"
    echo "[INFO] 文件位置: $SCRIPT_DIR/.env"
    exit 1
  else
    echo "[ERROR] 缺少 .env 文件" >&2
    exit 1
  fi
fi

set -a
source ./.env
set +a

if [[ -n "${GHCR_USER:-}" && -n "${GHCR_TOKEN:-}" ]]; then
  echo "[INFO] 登录 GHCR: ghcr.io"
  echo "$GHCR_TOKEN" | docker login ghcr.io -u "$GHCR_USER" --password-stdin
fi

echo "[INFO] 拉取镜像..."
"${COMPOSE_CMD[@]}" pull

echo "[INFO] 启动服务..."
"${COMPOSE_CMD[@]}" up -d

echo

echo "[OK] 部署完成"
echo "- 前端:  http://<你的服务器IP>/"
echo "- 后端:  http://<你的服务器IP>:8081/"
echo "- MySQL: <你的服务器IP>:3306"
echo "- Redis: <你的服务器IP>:6379"
echo
echo "常用排查:"
echo "- 查看容器: ${COMPOSE_CMD[*]} ps"
echo "- 查看日志: ${COMPOSE_CMD[*]} logs -f spring"
echo "- 首次导入 SQL: docker exec -it ctoip_db mysql -uroot -p\"$MYSQL_ROOT_PASSWORD\" -e 'SHOW DATABASES;'"
