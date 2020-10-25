#!/bin/bash

case $1 in
    start)
        echo ========== hadoop162 上启动hdfs ==========
        ssh hadoop162 "source /etc/profile ; start-dfs.sh"

        echo ========== hadoop163 上启动yarn ==========
        ssh hadoop163 "source /etc/profile ; start-yarn.sh"
        echo ========== hadoop162 上启动 历史服务器 ==========
        ssh hadoop162 "source /etc/profile ; mapred --daemon start historyserver"
       ;;

    stop)

        echo ========== hadoop163 上停止yarn ==========
        ssh hadoop163 "source /etc/profile ; stop-yarn.sh"

        echo ========== hadoop162 上停止hdfs ==========
        ssh hadoop162 "source /etc/profile ; stop-dfs.sh"
        echo ========== hadoop162 上停止历史服务器==========
        ssh hadoop162 "source /etc/profile ; mapred --daemon stop historyserver" 

     ;;
    *)
        echo "你启动的姿势不对"
        echo "  start 启动hadoop集群"
        echo "  stop  停止hadoop集群"
    ;;

esac
