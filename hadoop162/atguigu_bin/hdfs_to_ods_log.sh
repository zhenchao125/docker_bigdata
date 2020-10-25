#!/bin/bash

# 定义变量方便修改
APP=gmall
hive=/opt/module/hive-3.1.2/bin/hive
hadoop=/opt/module/hadoop-3.1.3/bin/hadoop

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$1" ] ;then
       do_date=$1
   else 
          do_date=`date -d "-1 day" +%F`
      fi 

      echo ================== 日志日期为 $do_date ==================

      sql="
      load data inpath '/origin_data/gmall/log/topic_log/$do_date' into table "$APP".ods_log partition(dt='$do_date');
      "

      $hive -e "$sql"

      $hadoop jar /opt/module/hadoop-3.1.3/share/hadoop/common/hadoop-lzo-0.4.20.jar com.hadoop.compression.lzo.DistributedLzoIndexer -Dmapreduce.job.queuename=hive /warehouse/gmall/ods/ods_log/dt=$do_date

