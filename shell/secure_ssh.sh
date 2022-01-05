#! /bin/bash
# ssh访问控制，多次失败登录即封掉IP，防止暴力破解
#
# 读取/var/log/secure，查找关键字 Failed。从这些行中提取IP地址，
# 如果次数达到10次(脚本中判断次数字符长度是否大于1)则将该IP写到/etc/hosts.deny中。
# 将secure_ssh.sh脚本放入cron计划任务，每1分钟执行一次。
cat /var/log/secure|awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2"="$1;}' > /tmp/ssh_black.list
for i in `cat  /tmp/ssh_black.list`
do
  IP=`echo $i |awk -F= '{print $1}'`
  NUM=`echo $i|awk -F= '{print $2}'`
  if [ $NUM -gt 1 ]; then
    grep $IP /etc/hosts.deny > /dev/null
    if [ $? -gt 0 ];then
      echo "sshd:$IP:deny" >> /etc/hosts.deny
    fi
  fi
done

#######################
# 对于大部分爆破日志如下，使用下面的脚本内容
# Nov  8 18:16:09 VM-24-12-centos sshd[11746]: Invalid user admin from 47.25.107.181 port 58147
grep Invalid /var/log/secure | awk '{print $(NF-2)}' | sort | uniq -c | awk '{print $2"="$1;}' > /tmp/ssh_black.list
for i in `cat  /tmp/ssh_black.list`
do
  IP=`echo $i |awk -F= '{print $1}'`
  NUM=`echo $i|awk -F= '{print $2}'`
  if [[ $NUM -gt 5 ]]; then
    grep $IP /etc/hosts.deny > /dev/null
    if [[ $? -gt 0 ]];then
      echo "sshd:$IP:deny" >> /etc/hosts.deny
    fi
  fi
done
