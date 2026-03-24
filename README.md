# ctoip_install
安装ctoip整个项目的Docker脚本

## 请使用DockerCompose进行部署
```sh
git clone https://github.com/ctoip/ctoip_install.git
cd ctoip_install
docker compose up
```
## 更新应用
```sh
git pull
docker compose down -v --rmi all --remove-orphans
docker compose build --no-cache
docker compose up
```