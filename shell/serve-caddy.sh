#!/bin/bash
#
# auto generate caddyserver vhosts config
# author: cyub
# usage:
#	./serve-caddy.sh start // 启动caddy服务
#   ./serve-caddy.sh park test // 将test.local指向当前目录里面的项目
#   ./serve-caddy.sh forget test // 删除test.local的指向配置
#   ./serve-caddy.sh stop // 停止caddy服务
#   ./serve-caddy.sh restart // 重启caddy服务
#

CURRPWD=`pwd` # 当前目录
DIRNAME=`basename $CURRPWD` # 当前目录basename
CADDY_CONF=/usr/local/etc/caddy/caddyfile # caddy配置（使用import指令载入vhosts目录下所有虚拟主机配置)
CADDY_VHOST_PATH=/usr/local/etc/caddy/vhosts # caddy vhost配置存放目录
CADDY_LOG_PATH=/var/log/caddy # caddy日志存放目录

start() {
	echo  -n "Starting caddy:"
  	sudo nohup caddy -conf="$CADDY_CONF" > /dev/null 2>&1 & 
  	[ $? -ne 0 ] && {
		echo  'caddy restart failure'
		return 1
	}
	echo  "done"
}

stop() {
	echo -n "Stoping caddy:"
	CADDY_PID=$(pgrep caddy)
  	[ $CADDY_PID -ne 0 ] && {
		sudo kill -9 $CADDY_PID > /dev/null 2>&1
  	}
  	echo "done"
}

restart() {
	echo "Restarting caddy"
	$0 stop
	sleep 1
	$0 start
	echo "done"
}

park() {
	SUBDOMAIN=`echo ${1:-$DIRNAME} | tr '[:upper:]' '[:lower:]'`
	INDEX_FILE=${2:-index.php} # php项目入口文件
	PHPCGI_PORT=${3:-9000} # phpcgi 端口
	DOMAIN_SUFFIX=${4:-.local} # 域名后缀

	if [ -f "${CURRPWD}/public/${INDEX_FILE}" ]; then
		ROOT=$CURRPWD/public
	elif [ -f "${CURRPWD}/${INDEX_FILE}" ]; then
		ROOT=$CURRPWD
	else
		echo  "index file not exists!"
		return 1
	fi

	echo -e "application will run at \033[31m${SUBDOMAIN}${DOMAIN_SUFFIX}\033[0m"
	block="#auto generate vhosts
http://${SUBDOMAIN}${DOMAIN_SUFFIX} {
    root $ROOT
    fastcgi / 127.0.0.1:$PHPCGI_PORT php
    log ${CADDY_LOG_PATH}/${SUBDOMAIN}${DOMAIN_SUFFIX}.access.log
    rewrite {
        to {path} {path}/ /index.php{uri}
    }
}"
	echo "$block" > "${CADDY_VHOST_PATH}/${SUBDOMAIN}.caddyfile"

	$0 restart
	echo "enjoy it!"
}

forget() {
	SUBDOMAIN=`echo ${1:-$DIRNAME} | tr '[:upper:]' '[:lower:]'`
	echo "Delete vhost config"
	VHOST_CONF="${CADDY_VHOST_PATH}/${SUBDOMAIN}.caddyfile"
	[ -f "$VHOST_CONF" ] && rm -rf "$VHOST_CONF"
	[ $? -eq 0 ] && $0 restart
}

list() {
	for i in $CADDY_VHOST_PATH/*.caddyfile; do
		[ ! -f "$i" ] && {
			echo 'vhost conf empty!'
			exit
		}	
		DOCUMENT_ROOT=`cat $i | grep root | awk '{print $2}'`
		[ ! -n "$DOCUMENT_ROOT" ] && continue
		echo -ne "\033[31m`basename $i`\033[0m\t=>"
		echo -ne "\t"
		echo "${DOCUMENT_ROOT}"
	done
}

case "$1" in
		start)
			start
			;;
		stop)
			stop
			;;
		restart)
			restart
			;;
		park)
			park $2 $3 $4 $5
			;;
		forget)
			forget $2
			;;
		list)
			list
			;;
		*)
			echo "Usage:`basename $0` {start|stop|restart|park|forget|list}"
			exit 1
esac

exit $?
