#!/bin/bash
maxwell_home=/opt/module/maxwell-1.27.1
case $1 in
    start)
        echo "========== $host 启动canal ========="
        source /etc/profile
        $maxwell_home/bin/maxwell --config $maxwell_home/config.properties --daemon 
       ;;

    stop)
        echo "========== $host停止 canal ========="
        source /etc/profile
        jps | awk '/Maxwell/ {print $1}' | xargs kill
        ;;

    *)
        echo "你启动的姿势不对"
        echo "  start   启动canal集群"
        echo "  stop    停止canal集群"

    ;;
esac
