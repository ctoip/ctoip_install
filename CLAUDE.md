# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project summary

- Service: `ctoip_docker` deployment orchestration
- Role: run full stack with Docker Compose
- Services: `db` (MySQL), `redis`, `spring` (backend), `web` (frontend)

## Commands

### One-command deployment

```bash
cp .env.example .env
# edit required secrets first
bash deploy.sh
```

### Core compose operations

```bash
docker compose ps
docker compose logs -f spring
docker compose logs -f db
docker compose down
```

### Recreate only dependencies

```bash
docker compose up -d --build db redis
docker compose up -d spring web
```

### Reset DB initialization

```bash
docker compose down
docker volume rm ctoip_docker_db_data
docker compose up -d
```

## Runtime topology and image flow

- `db` is built locally from `Dockerfile.db` and initialized with `sql/ctoip_db.sql`.
- `redis` uses official `redis:7-alpine` image.
- `spring` pulls `ghcr.io/ctoip/ctoip-backend:${IMAGE_TAG}`.
- `web` pulls `ghcr.io/ctoip/ctoip-frontend:${IMAGE_TAG}`.

`deploy.sh` intentionally pulls only app images (`spring`, `web`) while creating `db`/`redis` locally.

## Environment and connectivity model

- Main config source: `.env` (copied from `.env.example`).
- Spring DB/Redis credentials are injected via compose environment variables.
- `spring` starts only after `db` and `redis` pass health checks.
- Internal service discovery uses compose service names (`db`, `redis`, `spring`).

## Common failure pattern

If frontend login fails with backend JDBC `Communications link failure`, check for MySQL restart loop/OOM on host first (`dmesg`, db logs) before changing app config.
