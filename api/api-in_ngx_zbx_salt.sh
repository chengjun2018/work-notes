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
N='\033[32m'
RES='\033[0m'
WGET_NGINX="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/nginx"
WGET_P_NGINX="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/nginx.conf"
WGET_V_NGINX="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/pre_api.conf"
WGET_NGINX_OSS="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/oss.conf"
WGET_YUM="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/yum/yum.tar.gz"
WGET_FILE="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/pro_file.tar.gz"
WGET_SCRIPTS="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/pro_scripts.tar.gz"
WGET_ZBX_SCRIPT="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/zabbix/zbx_scripts.tar.gz"
WGET_SSH="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/sshd_config"
YUM="yum -y install gcc-c++ pcre pcre-devel zlib zlib-devel openssl  wget vim gcc gd-devel gd-devel GeoIP-devel zlib-devel pcre-devel openssl-devel gd-devel namp tree lsof unzip "
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
echo "QF-Pro-api" > /etc/hostname 
mkdir -p /home/{tools,scripes,projects,data} && cd /home/tools
/usr/sbin/useradd www
#wget http://nginx.org/download/nginx-1.14.2.tar.gz
wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/proxy/nginx-1.14.2.tar.gz
tar xf nginx-1.14.2.tar.gz && cd nginx-1.14.2
./configure --user=www --group=www --prefix=/home/application/nginx1.14.2  --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid --lock-path=/var/lock/subsys/nginx  --with-poll_module --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_image_filter_module  --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module
echo -e "${GREEN_COLOR}############开始编译make###############$RES"
 make -j4 && make install
############################
ln -s /home/application/nginx1.14.2/ /home/application/nginx
echo -e "${GREEN_COLOR}############配置启动配置文件##############$RES"
mkdir -p /home/application/nginx/conf/vhost
#####################
cd /etc/init.d/ && $WGET_NGINX
cd /home/application/nginx/conf/ && mv nginx.conf nginx.conf.bck 
$WGET_P_NGINX
cd /home/application/nginx/conf/vhost/ &&  $WGET_V_NGINX
cd /home/application/nginx/conf/vhost/ && $WGET_NGINX_OSS
cat >>/etc/profile<<EOF
PATH=$PATH:/home/application/nginx/sbin/
EOF
source /etc/profile
chkconfig --add /etc/init.d/nginx
chmod 755 /etc/init.d/nginx
chkconfig --add nginx
/sbin/chkconfig --level 345 nginx on
nginx
}

In_php (){
echo -e "${N}###########部署PHP-7.2.18#################$RES"
yum install -y libxml2 m4 autoconf libxml2-devel bzip2-devel.x86_64 curl-devel libxslt-devel postgresql-devel
cd /home/tools
wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/php/redis-4.3.0.tgz
wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/php/php-7.2.18.tar.gz
wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/api/php/swoole.zip
unzip swoole.zip >/dev/null 
tar xf php-7.2.18.tar.gz && tar xf redis-4.3.0.tgz 
cd php-7.2.18/
./configure --prefix=/home/application/php --with-pdo-pgsql --with-zlib-dir --with-freetype-dir --enable-mbstring --with-libxml-dir=/usr --enable-soap --enable-calendar --with-curl --with-mcrypt --with-gd --with-pgsql --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif --enable-bcmath --with-mhash --enable-zip --with-pcre-regex --with-pdo-mysql --with-mysqli --with-jpeg-dir=/usr --with-png-dir=/usr --enable-gd-native-ttf --with-openssl --with-fpm-user=www --with-fpm-group=www --with-libdir=/lib/x86_64-linux-gnu/ --enable-ftp --with-gettext --with-xmlrpc --with-xsl --enable-opcache --enable-fpm --with-iconv --with-xpm-dir=/usr
make clean && make && make install
cp php.ini-production /home/application/php/lib/php.ini
cat >>/etc/profile<<EOF
PATH=$PATH:/home/application/php/bin
export PATH
EOF
source /etc/profile
cp /home/application/php/etc/php-fpm.conf.default /home/application/php/etc/php-fpm.conf
cp /home/application/php/etc/php-fpm.d/www.conf.default /home/application/php/etc/php-fpm.d/www.conf
cp /home/tools/php-7.2.18/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
/etc/init.d/php-fpm start
 sleep 5
echo -e "${YELLOW_COLOR}###########安装拓展redis-4.3.0#################$RES"
cd /home/tools/redis-4.3.0
phpize
./configure --with-php-config=/home/application/php/bin/php-config
make -j4 && make install
echo "extension=redis.so" >> /home/application/php/lib/php.ini 
#安装拓展swoole
 Sleep 3
echo -e "${RED_COLOR}#########安装拓展swoole###############$RES"
cd /home/tools/swoole/
phpize
./configure --with-php-config=/home/application/php/bin/php-config
make -j4 && make install
echo "extension=swoole" >> /home/application/php/lib/php.ini
source /etc/profile
}

 sleep 2
In_file (){
echo -e "${YELLOW_COLOR}###########Copy后端文件#################$RES"
cd /home/data && $WGET_FILE
tar xf pro_file.tar.gz
cd /home/tools/ && $WGET_SCRIPTS
tar xf pro_scripts.tar.gz -C /opt/ 
mv /opt/scripts/* /home/scripes/
sed -i 's#pre#pro#g' /home/scripes/*.sh
rm -rf /opt/scripts
mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bck 
cd /etc/ssh/ && $WGET_SSH
systemctl restart sshd
}
sleep 2
In_zbx (){
echo -e "${GREEN_COLOR}#######安装zabbix-agentd#########$RES"
cd /home/tools/
rpm -ivh --replacefiles --force http://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
yum makecache
yum install -y zabbix-agent
sed -i 's#127.0.0.1#zabbix.irainbow7.com#g' /etc/zabbix/zabbix_agentd.conf
sed -i 's#Hostname=Zabbix server#Hostname=QF_Pro_api#g' /etc/zabbix/zabbix_agentd.conf
cd /etc/zabbix/ && $WGET_ZBX_SCRIPT
tar xf zbx_scripts.tar.gz
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
# PHP-FPM
UserParameter=php-fpm.status[*],/etc/zabbix/scripts/php-fpm_status.sh $1
# 因为监控的是另外主机的fpm，因此version不可用
UserParameter=php-fpm.version,/usr/bin/php-fpm -v | awk 'NR==1{print $0}'
#监控php进程数
UserParameter=adminphp,ps -ef|grep iswoole_front|grep -v grep|wc -l
UserParameter=frontendphp,ps -ef|grep iswoole_admin|grep -v grep|wc -l
EOF
systemctl start zabbix-agent
systemctl status zabbix-agent
systemctl enable zabbix-agent
}
sleep 2
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
sleep 2
In_ntp () {
echo -e  "${PINK_COLOR}############ntpdate###################$RES"
yum install ntpdate ntp -y
echo -e "#Synchronize every half hour.\n*/30 * * * * /usr/sbin/ntpdate asia.pool.ntp.org >/dev/null 2>&1" >>/var/spool/cron/root
systemctl restart crond
}
#########################################
#########锁账户文件####################
######################################
chattr +i /etc/passwd
chattr +i /etc/group
In_salt (){
echo  -e  "${YELLOW_COLOR}############安装salt-minion##############$RES"
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm
yum install salt-minion -y 
sed -i 's#\#master: salt#master: zabbix.irainbow7.com#' /etc/salt/minion 
sed -i 's#\#id:#id: QF-Pro-api#' /etc/salt/minion 
systemctl enable salt-minion
systemctl start salt-minion
}
sleep 2
In_nginx
 sleep 3
In_php
 sleep 3
In_file
 sleep 3
In_zbx
 sleep 3
system_os
 sleep 3
In_ntp
 sleep 3
In_salt


echo -e "${BLUE_COLOR}Install 1)nginx 2)zabbix 3)ntp 4)salt 5)In_file$RES"


#############################
####安装宝塔bt############
########################
##yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
