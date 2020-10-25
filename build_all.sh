#!/bin/bash
############################################
# 该脚本会构建所有镜像
############################################

hosts=(162 163 164)
version="0.0.1"
# 删除旧的容器
delAllContainer() {
    # shellcheck disable=SC2162
    read -p "是否删除旧的所有容器[y/n](n): " is_del
    if [ "${is_del}" == 'y' ] || [ "${is_del}" == 'Y' ] ; then
        echo ""
        echo "开始删除所有容器...."
        if [ -n "$(docker ps -aq)" ]; then
          docker rm -f $(docker ps -aq)
        fi
    fi
}

# 构建 images 共构建 6 个镜像: java8 ssh base 162 163 164
buildImages() {
    # shellcheck disable=SC2162
    read -p "是否构建 java8[y/n](n): " java8
    if [ "$java8" == 'y' ] || [ "$java8" == 'Y' ] ; then
        echo "开始构建镜像: java8"
        docker build -t atguigu_bigdata_java8:"$version" -f java8/Dockerfile_java8 ./java8
    fi

    # shellcheck disable=SC2162
    read -p "是否构建 ssh[y/n](n): " ssh
    if [ "${ssh}" == 'y' ] || [ "${ssh}" == 'Y' ] ; then
        echo ""
        echo "开始构建镜像: ssh"
        docker build -t atguigu_bigdata_ssh:"$version" -f ssh/Dockerfile_ssh ./ssh
    fi

    # shellcheck disable=SC2162
    read -p "是否构建 base[y/n](n): " base
    if [ "${base}" == 'y' ] || [ "${base}" == 'Y' ] ; then
        echo ""
        echo "开始构建镜像: base"
        docker build -t atguigu_bigdata_base:"$version" -f base/Dockerfile_base ./base
    fi

    # shellcheck disable=SC2162
    read -p "是否构建 162 163 164[y/n](n): " cluster
    if [ "${cluster}" == 'y' ] || [ "${cluster}" == 'Y' ] ; then
        # 开始构建集群镜像
        for host in ${hosts[*]}; do
          echo ""
          echo "开始构建镜像 atguigu_bigdata_$host"
          docker build -t atguigu_bigdata_"$host":"$version" -f hadoop${host}/Dockerfile_"$host" ./hadoop${host}
        done
    fi


}

# 创建容器
createContainers() {
  # 找到当前主机ip 地址前 3 段
  if [ -n "$(ifconfig | grep ^br0)" ]; then
      pre_ip=$(ifconfig br0 | awk '/inet / { print $2 }'|awk -F '.' '{print $1"."$2"."$3}')
  elif [ -n "$(ifconfig | grep ens33)" ]; then
      pre_ip=$(ifconfig ens33 | awk '/inet / { print $2 }'|awk -F '.' '{print $1"."$2"."$3}')
  else
    pre_ip=$(ifconfig eth0 | awk '/inet / { print $2 }'|awk -F '.' '{print $1"."$2"."$3}')
  fi

  for host in ${hosts[*]}; do
    # shellcheck disable=SC2059
    echo ""
    echo "创建集群容器: hadoop$host"
    docker create -it \
      --privileged \
      --name hadoop"$host" \
      --hostname hadoop"$host" \
      --add-host=hadoop"${hosts[0]}":${pre_ip}."${hosts[0]}" \
      --add-host=hadoop"${hosts[1]}":${pre_ip}."${hosts[1]}" \
      --add-host=hadoop"${hosts[2]}":${pre_ip}."${hosts[2]}" \
      atguigu_bigdata_"$host":0.0.1 \
      /usr/sbin/init
  done
}


# 删那些有问题的镜像:  tag 为 none
delErrorImages(){
    if [ -n  "$(docker images|grep none|awk '{print $3}')" ]; then
      docker images|grep none|awk '{print $3}'|xargs docker rmi -f
    fi

}

# 删除旧的容器
delAllContainer
# 构建镜像
buildImages
# 删除错误的镜像
delErrorImages
# 创建容器
createContainers


