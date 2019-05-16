#!/bin/bash
###This is a script that automatically installs nginx and zabbix
#watson
#watson@irianbow7.com
#20190505
RED_COLOR='\033[41;37m'
GREEN_COLOR='\033[42;37'
YELLOW_COLOR='\033[43;37m'
BLUE_COLOR='\033[44;37m'
PINK_COLOR='\033[45;37m'
RES='\033[0m'
WGET_NGINX="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/cli/nginx"
WGET_P_NGINX="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/cli/nginx.conf"
WGET_V_NGINX="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/cli/pre_cli.conf"
WGET_NGX_STATUS="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/cli/default.conf"
WGET_ZBX_SCRIPT="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/cli/zabbix/zbx_script.tar.gz"
WGET_YUM="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/yum/yum.tar.gz"
WGET_SSH="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/sshd_config"
YUM="yum -y install gcc-c++ pcre pcre-devel zlib zlib-devel openssl  wget vim gcc gd-devel gd-devel GeoIP-devel nmap zlib-devel pcre-devel openssl-devel gd-devel tree net-tools"
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
New_yum () {
echo -e "${GREEN_COLOR}安装依赖环境包$RES"
mkdir -p /etc/yum.repos.d/old && mv /etc/yum.repos.d/*.repo old/
cd /etc/yum.repos.d/ && $WGET_YUM
tar xf yum.tar.gz
yum clean all && yum makecache
$YUM
}
echo -e "${GREEN_COLOR}安装依赖环境包$RES"
New_yum


In_nginx (){
echo -e "${RED_COLOR}#########开始安装nginx-1.14.2###############$RES"
sed 's#centos7#QF-Pro-cli#g' /etc/hostname
mkdir -p /home/{tools,scripes,projects} && cd /home/tools
useradd www
#wget http://nginx.org/download/nginx-1.14.2.tar.gz
wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/proxy/nginx-1.14.2.tar.gz
tar xf nginx-1.14.2.tar.gz && cd nginx-1.14.2
./configure --user=www --group=www --prefix=/home/application/nginx1.14.2  --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid --lock-path=/var/lock/subsys/nginx  --with-poll_module --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_image_filter_module  --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module
echo -e "${GREEN_COLOR}############开始编译make###############$RES"
make -j2 && make install
############################
ln -s /home/application/nginx1.14.2/ /home/application/nginx
echo -e "${GREEN_COLOR}############配置启动配置文件##############$RES"
mkdir -p /home/application/nginx/conf/vhost
#####################
cd /etc/init.d/ && $WGET_NGINX
cd /home/application/nginx/conf/ && mv nginx.conf nginx.conf.bck 
$WGET_P_NGINX
cd /home/application/nginx/conf/vhost/ &&  $WGET_V_NGINX
cd /home/application/nginx/conf/vhost/ &&  $WGET_NGX_STATUS
cat >>/etc/profile<<EOF
PATH=$PATH:/home/application/nginx/sbin/
EOF
source /etc/profile
chkconfig --add /etc/init.d/nginx
chmod 755 /etc/init.d/nginx
chkconfig --add nginx
/sbin/chkconfig --level 345 nginx on
}

In_file (){
mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bck 
cd /etc/ssh/ && $WGET_SSH
systemctl restart sshd
}

In_zbx (){
echo -e "${GREEN_COLOR}#######安装zabbix-agentd#########$RES"
cd /home/tools/
rpm -ivh --replacefiles --force http://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
yum makecache
yum install -y zabbix-agent
sed -i 's#127.0.0.1#zabbix.irainbow7.com#g' /etc/zabbix/zabbix_agentd.conf
sed -i 's#Hostname=Zabbix server#Hostname=QF_Pro_cli#g' /etc/zabbix/zabbix_agentd.conf
cd /etc/zabbix/ && $WGET_ZBX_SCRIPT
tar xf zbx_script.tar.gz
cat >>/etc/zabbix/zabbix_agentd.conf<<EOF
# NGINX - 参数固定
UserParameter=nginx.Accepted-Connections,/etc/zabbix/scripts/getNginxInfo.py -h 127.0.0.1 -a accepted
UserParameter=nginx.Active-Connections,/etc/zabbix/scripts/getNginxInfo.py -h  127.0.0.1 -a active
UserParameter=nginx.Handled-Connections,/etc/zabbix/scripts/getNginxInfo.py -h 127.0.0.1 -a handled
UserParameter=nginx.Reading-Connections,/etc/zabbix/scripts/getNginxInfo.py -h 127.0.0.1 -a reading
UserParameter=nginx.Total-Requests,/etc/zabbix/scripts/getNginxInfo.py -h 127.0.0.1 -a requests
UserParameter=nginx.Waiting-Connections,/etc/zabbix/scripts/getNginxInfo.py -h 127.0.0.1 -a waiting
UserParameter=nginx.Writting-Connections,/etc/zabbix/scripts/getNginxInfo.py -h 127.0.0.1 -a writing
# NGINX  - 变量形式
UserParameter=nginx.status[*],/etc/zabbix/scripts/ngx_status.sh $1
EOF
systemctl start zabbix-agent
systemctl status zabbix-agent
systemctl enable zabbix-agent
}

system_os (){
echo -e "${YELLOW_COLOR}###########系统内核优化#################$RES"
cat >>/etc/sysctl.conf<<EOF
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time =600
net.ipv4.ip_local_port_range = 32768   60999
net.ipv4.tcp_max_syn_backlog = 1024
net.core.somaxconn = 1024
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.netdev_max_backlog = 1000
net.ipv4.tcp_max_orphans = 2000
EOF
sysctl -p
}

In_ntp () {
echo -e  "${PINK_COLOR}############ntpdate###################$RES"
yum install ntpdate ntp -y
ntpdate asia.pool.ntp.org
}
#########################################
#########锁账户文件####################
######################################
#chattr +i /etc/passwd
#chattr +i /etc/group
In_salt (){
echo  -e  "${YELLOW_COLOR}############安装salt-minion##############$RES"
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm
yum install salt-minion -y 
sed -i 's#\#master: salt#master: zabbix.irainbow7.com#' /etc/salt/minion 
sed -i 's#\#id:#id: QF-Pro-cli#' /etc/salt/minion 
systemctl enable salt-minion
systemctl start salt-minion
}

In_nginx
 sleep 3
In_zbx
 sleep 3
system_os
 sleep 3
In_ntp
 sleep 3
In_salt
 sleep 3
In_file

echo -e "${BLUE_COLOR}Install 1)nginx 2)zabbix 3)ntp 4)salt 5)In_file$RES"


############################
###安装宝塔bt############
#######################
#yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
