#!/bin/bash
#这是测试环境api_admin项目停止与启动服务的脚本
#Time-20190408
#Watson@irainbow7.com
#No.2#-再次判断，并启服务
#使用函数再次判断
. /etc/init.d/functions 
ADMIN_PHP(){
if [ "`ps -ef|grep iswoole_admin|grep -v grep|wc -l`" -eq  "0" ]
then
  echo "api_admin后端没有启动，现在进行自动启动"
sudo  /bin/php  /home/projects/qfapi_admin/master.php start 20001 10 20 
#sudo  /bin/php  /home/projects/qfapi_admin/master.php start 20009 10 20 1 
  echo "启动完成"
else
  echo "api_admin后端已经启动"
  echo "服务端口为20001"
fi
}
#使用函数再次判断
FRONTEND_PHP(){
if [ "`ps -ef|grep /home/projects/qfapi_frontend/master.php|grep -v grep|wc -l`" -eq  "0" ]
then
  echo "api_frontend前端没有启动，现在进行自动启动"
sudo  /bin/php /home/projects/qfapi_frontend/master.php start 20000 10 20 
  echo "启动完成"
else
 echo "api_frontend前端启动........"
 echo "测试环境{前端}对应端口20000"
fi
}
AGENT_PHP(){
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
AGENT_PHP
FRONTEND_PHP

