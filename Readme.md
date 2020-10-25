# 注意

## 目录说明
- 不要更改`docker_bigdata`的目录结构
- 进入到`docker_bigdata`目录下再执行脚本
- `all_conf`集群框架的所有配置, 如果有新的框架, 则只需要把他们的配置 copy 到这个目录中. 可以根据需要更改配置
- `all_dockerfile` 所有的 dockerfile
- `all_tars` 框架安装包
- `atguigu_bin` 是常用的一些脚本, 有些要根据自己的电脑配置进行更改
- `my.sh` 是配置环境变量. `ENV`配置的环境变量, 使用 ssh 登录无法使用, 所以需要单独配置

## 镜像构建说明
- build_all.sh 可以构建需要用到的所有镜像, 运行的时候, 根据自己的需要选择需要构建的镜像
- build_all.sh 最后会创建 3 个容器 hadoop162, hadoop163, hadoop164

## 容器启动说明
- contains.sh 启动集群容器
- 启动的时候会自动根据当前宿主机的 ip 进行配置
- 3 个容器的 ip 分别是 xxx.162, xxx.163, xxx.164
- xxx 是根据当前宿主的 ip 自动获取的

## 特别说明

- 容器启动后, 需要配置 3 个容器之间的免密登录. 直接运行脚本即可:`ssh_auto_copy.sh` 不需要输入任何参数
- 在运行脚本:`ssh_auto_copy.sh`的时候, 顺便也格式化了 namenode
- 容器一旦创建成功之后, 以后使用的时候启动即可
- 启动 hadoop:  hadoop.sh start
- 启动 kafka:  kafka.sh start
- 启动 zookeeper:  zk start
- 启动 hbase:  start-hbase.sh

