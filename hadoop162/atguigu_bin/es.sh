#!/bin/bash
es_home=/opt/module/elasticsearch-6.6.0
kibana_home=/opt/module/kibana-6.6.0
case $1 in
    start)
        for host in hadoop162 hadoop163 hadoop164 ; do
            echo "========== $host 启动es ========="
        ssh $host "source /etc/profile; nohup $es_home/bin/elasticsearch 1>/dev/null 2>&1 & "
        done
        
        echo "========== hadoop162 启动kiban ========="
        nohup $kibana_home/bin/kibana 1>/dev/null 2>&1 &

       ;;
    stop)
            echo "========== 停止 kibana ========="
            ps -ef | awk '/kibana/ && !/awk/ {print $2}'| xargs kill -9
            for host in hadoop162 hadoop163 hadoop164 ; do
                echo "========== $host停止 es ========="
                ssh $host "ps -ef | awk '/elasticsearch/ && !/awk/ {print \$2}'| xargs kill -9"
            done

           ;;

    *)
        echo "你启动的姿势不对"
        echo "  start   启动kafka集群"
        echo "  stop    停止kafka集群"

    ;;
esac
