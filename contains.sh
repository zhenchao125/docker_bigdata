#!/bin/bash
hosts=(162 163 164)
case $1 in
  "start")
    br0=$(ifconfig | grep ^br0)
    if [ -z "$br0" ]; then
        # 获取 eth0 或者 eth33 的 ip
        if [ -n "$(ifconfig | grep eth0)" ]; then
            ip=$(ifconfig eth0 | awk '/inet / { print $2 }')
            device=eth0
        else
            ip=$(ifconfig eth33 | awk '/inet / { print $2 }')
            device=ens33
        fi
        gateway=$(ip route show | awk '/default/ {print $3}')
        echo ""
        echo "开始搭建网桥...."
        sudo brctl addbr br0; \
        sudo ip link set dev br0 up; \
        sudo ip addr del "$ip"/24 dev $device; \
        sudo ip addr add "$ip"/24 dev br0 ; \
        sudo brctl addif br0 eth0 ; \
        sudo ip route add default via "$gateway" dev br0
        echo "网桥 br0 搭建成功"
    else
        echo "网桥已经搭建, 不需要重新搭建...."
    fi
    echo ""
    echo "开始启动容器....."
    for contain in ${hosts[*]} ; do
        echo "===== 启动容器: hadoop$contain      ======"
        docker start hadoop"$contain"
        echo "===== 容器: hadoop$contain 启动成功  ======"
        echo "++++++++++++++++++++++++++++++++++++"
    done

    echo "5 秒之后给容器配置 ip ......"
    sleep 5
    echo "开始给容器配置 ip ......"
    # ip前 3 个字段
    pre_ip=$(ifconfig br0 | awk '/inet / { print $2 }'|awk -F '.' '{print $1"."$2"."$3}')
    gateway=$(ip route show | awk '/default/ {print $3}')
    sudo pipework  br0 hadoop"${hosts[0]}" "$pre_ip"."${hosts[0]}"/24@"$gateway"
    sudo pipework  br0 hadoop"${hosts[1]}" "$pre_ip"."${hosts[1]}"/24@"$gateway"
    sudo pipework  br0 hadoop"${hosts[2]}" "$pre_ip"."${hosts[2]}"/24@"$gateway"
    echo "完成容器 ip 配置 ......"
  ;;
  "stop")
    echo "开始关闭容器....."
    for contain in ${hosts[*]} ; do
        echo "===== 关闭容器: hadoop$contain     ======"
        docker stop hadoop"$contain"
    done
  ;;
  *)
    echo "你启动的姿势不对, 换个姿势再来"
    echo " contains.sh  start 启动所有容器"
    echo " contains.sh  stop 关闭所有容器"
  ;;
esac

