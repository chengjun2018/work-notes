#!/bin/bash
#这是一个测试环境挂维护站点的脚本
#time:20190805
#zz:watson.C
dir=/etc/nginx/vhost/
cd $dir
if [ -f irainbow7_test.conf.bck ]
then
 echo "取消网站维护，请稍等....." 
mv irainbow7_test.conf.bck irainbow7_test.conf && mv weihu.conf weihu.conf.bck && nginx -s reload
 echo $? 
sleep 3
 echo "请测试"
fi
web_test(){
if [ `curl -I -m 10 -o /dev/null -s -w %{http_code}  www-test.irainbow7.com` == 200 ]
then 
  echo "PC端站点正常"
else 
  echo "PC站点未恢复正常"
fi
if [ `curl -I -m 10 -o /dev/null -s -w %{http_code}  m-test.irainbow7.com` == 200 ]
then 
  echo "H5端站点正常"
else 
  echo "H5站点未恢复正常"
fi
if [ `curl -I -m 10 -o /dev/null -s -w %{http_code}  admin-test.irainbow7.com` == 200 ]
then 
  echo "Admin端站点正常"
else 
  echo "Admin站点未恢复正常"
fi
if [ `curl -I -m 10 -o /dev/null -s -w %{http_code}  agent-test.irainbow7.com` == 200 ]
then 
  echo "Agent端站点正常"
else 
  echo "Agent站点未恢复正常"
fi
}
web_test
