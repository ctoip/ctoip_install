# CLAUDE.md

## 项目定位
- 子项目：`ctoip_docker`
- 类型：Docker Compose 一键部署（前后端分离 + DB + Redis）

## 核心启动文件
- 编排文件：`docker-compose.yaml`
- 部署脚本：`deploy.sh`
- 环境模板：`.env.example`

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

## 镜像来源（重点）
- 后端镜像：由 `ctoip` 仓库 `Dockerfile + backend-image.yml` 构建并推送 GHCR
- 前端镜像：由 `ctoip_vue` 仓库 `Dockerfile + frontend-image.yml` 构建并推送 GHCR
- 本仓库通过 `IMAGE_TAG` 拉取镜像并部署，不承担应用镜像构建

## 与其它子项目关系
- 运行时会消费 `ctoip` 发布的 jar
- 运行时会消费 `ctoip_vue` 发布的 dist 包
- 此仓库本身是部署编排层，不是业务源码主仓

## 当前已确认端口
- 80 -> web
- 8081 -> spring
- 3306 -> db
- 6379 -> redis
