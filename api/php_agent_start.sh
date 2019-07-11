#!/bin/bash
#这是测试环境api_agent项目停止与启动服务的脚本
#Time-20190408
#Watson@irainbow7.com
#No.2#-再次判断，并启服务

#使用函数再次判断
. /etc/init.d/functions 
ADMIN_PHP(){
if [ "`ps -ef|grep iswoole_agent|grep -v grep|wc -l`" -eq  "0" ]
then
  echo "api_agent后端没有启动，现在进行自动启动"
sudo  /bin/php  /home/projects/qfapi_agent/master.php start 20002 10 20
  echo "启动完成"
else
  echo "api_agent后端已经启动"
  echo "服务端口为20002"
fi
}
#调用函数
ADMIN_PHP
