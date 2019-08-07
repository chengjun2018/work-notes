#!/bin/sh
#Time-20190419
#Watson@irainbow7.com

KILL_PHP="`ps -ef|grep /home/projects/qfapi_admin/master.php|grep -v grep |cut -c 9-15|xargs kill -s 9 >/dev/null 2>&1`" 
KILL_PHP="`ps -ef|grep /home/projects/qfapi_agent/master.php|grep -v grep |cut -c 9-15|xargs kill -s 9 >/dev/null 2>&1`" 
KILL_PHP="`/usr/bin/ps -ef|grep /home/projects/qfapi_frontend/master.php|grep -v grep |cut -c 9-15|xargs kill -s 9 >/dev/null 2>&1`"
 
###No.1#-关闭进程 
#如果api_admin进程数量大于0 
ADMIN_PHP(){
if [ "`ps -ef|grep iswoole_admin|grep -v grep|wc -l`" -gt  "0" ] 
then 
#则使用kill的方式关闭进程 
sudo  echo "关闭api_admin进程" 
sudo   /bin/php /home/projects/qfapi_admin/master.php stop 20001
sudo   /bin/php /home/projects/qfapi_admin/master.php stop 20009
  #$KILL_PHP  
fi 
echo "echo "$?""
}
AGENT_PHP(){
if [ "`ps -ef|grep iswoole_agent|grep -v grep|wc -l`" -gt  "0" ] 
then 
#则使用kill的方式关闭进程 
sudo  echo "关闭api_agent进程" 
sudo   /bin/php /home/projects/qfapi_agent/master.php stop 20002
  #$KILL_PHP  
fi 
echo "echo "$?""
}
FRONTEND_PHP(){
###No.1#-关闭进程
#如果frontend进程数量大于0
if [ "`ps -ef|grep iswoole_frontend |grep -v grep|wc -l`" -gt  "0" ]
then
#则使用kill的方式关闭进程
sudo  echo "关闭api_frontend进程"
sudo  /bin/php /home/projects/qfapi_frontend/master.php stop 20000
  #$KILL_PHP
fi
}
ADMIN_PHP
AGENT_PHP
FRONTEND_PHP
