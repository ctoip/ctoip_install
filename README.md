# ctoip_docker

部署编排仓，包含两种使用方式：
- **生产部署**：`db + redis + spring + web`
- **开发依赖**：`db + redis`（dev compose）

## 1) 生产环境部署

```bash
cp .env.example .env
# 至少修改: MYSQL_ROOT_PASSWORD / REDIS_PASSWORD / JWT_SECRET
bash deploy.sh
```

说明：
- `deploy.sh` 会按顺序拉起 `db -> redis -> spring -> web`
- 前后端镜像默认来自 GHCR，版本由 `IMAGE_TAG` 控制

常用命令：
```bash
docker compose ps
docker compose logs -f spring
docker compose logs -f web
```

## 2) 开发环境部署（仅 db + redis）

使用 [docker-compose.dev.yaml](docker-compose.dev.yaml)。

```bash
cp .env.example .env
# 至少修改: MYSQL_ROOT_PASSWORD / REDIS_PASSWORD

docker compose -f docker-compose.dev.yaml up -d
docker compose -f docker-compose.dev.yaml ps
docker compose -f docker-compose.dev.yaml logs -f db redis
```

停止：
```bash
docker compose -f docker-compose.dev.yaml down
```

说明：
- 容器名：`ctoip_db_dev`、`ctoip_redis_dev`
- 数据卷：`db_data_dev`、`redis_data_dev`
- 端口对外：`3306`（MySQL）、`6379`（Redis），可通过 `VM_IP:端口` 从外部访问

## 3) SQL 初始化

- 初始化 SQL：`sql/ctoip_db.sql`
- 仅在 MySQL 数据目录为空时执行一次

验证：
```bash
docker exec -it ctoip_db mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "USE ctoip_db; SHOW TABLES;"
```

若需重置并重新导入：
```bash
docker compose down
docker volume rm ctoip_docker_db_data
docker compose up -d
```
