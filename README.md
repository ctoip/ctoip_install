# ctoip_install
安装ctoip整个项目的Docker脚本

1. 请使用DockerCompose进行部署
2. 将发布内容下载到预先部署好docker的工作机上的ctoip文件夹内
3. 进入该文件夹执行下命令
```sh
sudo echo 185.199.108.133 raw.githubusercontent.com >> /etc/hosts ## 防止域名劫持
docker compose up
```
