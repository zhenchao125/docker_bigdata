#!/bin/bash
canal_home=/opt/module/canal
case $1 in
    start)
        for host in hadoop162 hadoop163 hadoop164 ; do
            echo "========== $host 启动canal ========="
        ssh $host "source /etc/profile; ${canal_home}/bin/startup.sh"
        done
        
       ;;
    stop)
            for host in hadoop162 hadoop163 hadoop164 ; do
                echo "========== $host停止 canal ========="
                ssh $host "source /etc/profile; ${canal_home}/bin/stop.sh"
            done

           ;;

    *)
        echo "你启动的姿势不对"
        echo "  start   启动canal集群"
        echo "  stop    停止canal集群"

    ;;
esac
