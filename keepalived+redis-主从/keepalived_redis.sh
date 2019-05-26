#!/bin/bash
#
#
REDIS_CONF="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/keepalived%2Bredis-%E4%B8%BB%E4%BB%8E/redis/redis_master.conf"
KEEPALIVED_CONF="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/keepalived%2Bredis-%E4%B8%BB%E4%BB%8E/keepalived/keepalived.conf"
KEEPALIVED_SCRIPTS="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/keepalived%2Bredis-%E4%B8%BB%E4%BB%8E/keepalived/keepalived.scripts.tar.gz"
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i  's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
yum repolist
yum -y install openssl-devel libnl3-devel ipset-devel iptables-devel libnfnetlink-devel net-snmp-devel  gcc g++ gcc-c++ make
cd /home/tools/
wget http://download.redis.io/releases/redis-5.0.1.tar.gz
wget https://www.keepalived.org/software/keepalived-2.0.9.tar.gz
#########################################################################
echo "install redis-5.0.1"
redis (){
tar xf redis-5.0.1.tar.gz -C /usr/local/ && mv /usr/local/redis-5.0.1 /usr/local/redis
cd /usr/local/redis/
make && make install
 sleep 5
mkdir -p /usr/local/redis/etc
mkdir -p /usr/local/redis/bin
mkdir -p /home/data/{logs,redis}
cp -r /usr/local/redis/src/redis-cli redis-server redis-benchmark redis-check-aof redis-trib.rb redis-sentinel redis-check-rdb /usr/local/redis/bin/
cd /usr/local/redis/etc/ && $REDIS_CONF
}
########################################################################################################
echo "#install keepalived"
keepalived (){
cd /home/tools/
tar xf keepalived-2.0.9.tar.gz
cd keepalived-2.0.9
./configure --prefix=/home/application/keepalived/
make  && make install  
   sleep 5
cp /home/tools/keepalived-2.0.9/keepalived/etc/init.d/keepalived /etc/init.d/keepalived
cp /home/application/keepalived/sbin/keepalived /usr/sbin/
cp /home/application/keepalived/etc/sysconfig/keepalived /etc/sysconfig/
mkdir -p /etc/keepalived/
mkdir -p /home/data/logs/
touch /home/data/logs/keepalived-redis-state.log
cd /etc/keepalived/ &&  $KEEPALIVED_CONF
cd /etc/keepalived/ && $KEEPALIVED_SCRIPTS
tar xf keepalived.scripts.tar.gz && rm -rf keepalived.scripts.tar.gz
}

