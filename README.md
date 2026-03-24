# ctoip_install（ctoip_docker）

部署编排仓，负责拉起 4 个服务：
- `db`（MySQL 8）
- `redis`（Redis 7）
- `spring`（后端镜像）
- `web`（前端镜像）

---

## 1. 目标机一条命令部署（推荐）

### 1.1 准备
```bash
cp .env.example .env
# 编辑 .env：至少改掉 MYSQL_ROOT_PASSWORD / REDIS_PASSWORD / JWT_SECRET
```

如果你的 GHCR 包是私有：
- 在 `.env` 填 `GHCR_USER` / `GHCR_TOKEN`
- `GHCR_TOKEN` 需要有 `read:packages`

### 1.2 一键部署
```bash
bash deploy.sh
```

脚本会自动执行：
1. 检查 `docker` / `docker compose`
2. 读取 `.env`
3. （可选）登录 `ghcr.io`
4. `docker compose pull`
5. `docker compose up -d`

---

## 2. SQL 初始化说明（非常重要）

本仓库已内置 SQL：
- `sql/ctoip_db.sql`

`docker-compose.yaml` 将该文件挂载到：
- `/docker-entrypoint-initdb.d/ctoip_db.sql`

### 初始化生效时机
- **仅在 MySQL 数据目录为空时执行一次**（首次启动）
- 若数据库卷已存在，不会重复导入

### 验证 SQL 是否已导入
```bash
docker exec -it ctoip_db mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "SHOW DATABASES;"
docker exec -it ctoip_db mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "USE ctoip_db; SHOW TABLES;"
```

### 需要重新导入 SQL（重置）
```bash
docker compose down
docker volume rm ctoip_docker_db_data
docker compose up -d
```

---

## 3. 常用运维命令

```bash
docker compose ps
docker compose logs -f spring
docker compose logs -f web
docker compose logs -f db
docker compose logs -f redis
```

健康检查：
- 前端：`http://<server-ip>/`
- 后端：`http://<server-ip>:8081/`

---

## 4. 镜像版本发布模式（生产）

默认从 GHCR 拉取镜像：
- `ghcr.io/ctoip/ctoip-backend:${IMAGE_TAG}`
- `ghcr.io/ctoip/ctoip-frontend:${IMAGE_TAG}`

在 `.env` 修改：
```bash
IMAGE_TAG=latest
```
可切换到任意 tag（如 `v1.3.0` 或 commit sha）。

升级：
```bash
bash deploy.sh
```

回滚：
1. 改 `.env` 的 `IMAGE_TAG` 为旧版本
2. 再执行 `bash deploy.sh`

---

## 5. 本地源码构建联调（可选）

镜像由 `ctoip` 与 `ctoip_vue` 仓库的 GitHub Actions 构建并推送到 GHCR，部署仓只负责拉取并编排运行。

---

## 6. 端口映射

- `80` -> web
- `8081` -> spring
- `3306` -> db
- `6379` -> redis
