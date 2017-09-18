#!/bin/bash
 
# php-cgi命令路径
PHPFCGI=`which php-cgi`
 
# 绑定TCP地址
FCGI_BIND_ADDRESS="127.0.0.1:${1:-9000}"

# 派生出PHP子进程数
PHP_FCGI_CHILDREN=8
 
# PHP进程处理的最大请求数
PHP_FCGI_MAX_REQUESTS=4096

CMD="$PHPFCGI -b $FCGI_BIND_ADDRESS"

E="PHP_FCGI_CHILDREN=$PHP_FCGI_CHILDREN PHP_FCGI_MAX_REQUESTS=$PHP_FCGI_MAX_REQUESTS"

# 设置环境变量，并启动php-cgi

nohup env - $E sh -c "$CMD" &> /dev/null &

# 杀死所有php-cgi进程
# pgrep php-cgi | awk '{print $1}' | xargs kill -9
