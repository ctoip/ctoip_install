# CLAUDE.md

## 项目定位
- 子项目：`ctoip_docker`
- 类型：Docker Compose 一键部署（前后端分离 + DB + Redis）

## 核心启动文件
- 编排文件：`docker-compose.yaml`
- 镜像构建：
  - `Dockerfile.db`
  - `Dockerfile.spring`
  - `Dockerfile.web`

## 启动拓扑
- `db`：MySQL 8，启动时导入 SQL
- `redis`：Redis（requirepass=root）
- `spring`：后端服务，依赖 db/redis
- `web`：Nginx 托管前端，依赖 db/redis/spring

## compose 启动命令
```bash
docker compose up --build
```

## compose 停止命令
```bash
docker compose down
```

## 镜像构建逻辑（重点）
- `Dockerfile.db`：通过 `SQLFILE` 下载 `ctoip_db.sql` 到 `/docker-entrypoint-initdb.d/`
- `Dockerfile.spring`：下载后端 jar 与模板 `application.yml`，使用 `envsubst` 注入 `MYSQLIP`/`REDISIP`
- `Dockerfile.web`：下载前端 `dist.tar.gz` 与 nginx.conf，注入 `SERVERIP` 后启动 nginx

## 与其它子项目关系
- 运行时会消费 `ctoip` 发布的 jar
- 运行时会消费 `ctoip_vue` 发布的 dist 包
- 此仓库本身是部署编排层，不是业务源码主仓

## 当前已确认端口
- 80 -> web
- 8081 -> spring
- 3306 -> db
- 6379 -> redis
