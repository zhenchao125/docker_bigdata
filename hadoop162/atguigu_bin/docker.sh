# 启动容器
docker start atguigu202
docker start atguigu203

# 搭建网桥
sudo brctl addbr br0; \
sudo ip link set dev br0 up; \
sudo ip addr del 192.168.14.112/24 dev eth0 ; \
sudo ip addr add 192.168.14.112/24 dev br0 ; \
sudo brctl addif br0 eth0 ; \
sudo ip route add default via 192.168.14.1 dev br0

sleep 5

# 给容器配置ip
sudo pipework  br0 atguigu202 192.168.14.202/24@192.168.14.1
sudo pipework  br0 atguigu203 192.168.14.203/24@192.168.14.1

