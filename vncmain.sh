#!/bin/bash
# Set them to empty is NOT SECURE but avoid them display in random logs.
export VNC_PASSWD=''
export USER_PASSWD=''

export TERM=linux

while true; do
    # 检查进程是否存在
    process=`ps aux | grep 'CQ.\.exe'`
    if [ "$process" == '' ]; then
        # 如果设置了COOLQ_ACCOUNT，将HTTP API的地址中的QQ号替换成COOLQ_ACCOUNT
        if [ $COOLQ_ACCOUNT != '' ]; then
            sed -i "s/REPLACE_QQ_ACCOUNT/$COOLQ_ACCOUNT/g" ~/coolq/app/io.github.richardchien.coolqhttpapi/config.cfg
        fi
        # 不存在则重启
        wine ~/coolq/CQ?.exe /account $COOLQ_ACCOUNT
        # 进程退出后等待 30 秒后再检查，避免 CQ 自重启导致误判
        sleep 30
    else
        # 存在则说明是别的途径启动的，多等一会儿吧
        sleep 100
    fi
done
