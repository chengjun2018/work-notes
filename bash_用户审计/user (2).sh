#!/bin/bash
#
#
#
WGET_YUM="wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/yum/yum.tar.gz"
New_yum () {
echo -e "${GREEN_COLOR}安装依赖环境包$RES"
mkdir -p /etc/yum.repos.d/old && mv /etc/yum.repos.d/*.repo old/
cd /etc/yum.repos.d/ && $WGET_YUM
tar xf yum.tar.gz
yum clean all && yum makecache
}
echo -e "${GREEN_COLOR}安装依赖环境包$RES"
#New_yum
yum install gcc -y
cd /home/tools/
wget  https://raw.githubusercontent.com/chengjun2018/work-notes/master/bash_%E7%94%A8%E6%88%B7%E5%AE%A1%E8%AE%A1/bash-4.1.tar.gz
tar xf bash-4.1.tar.gz
mv /home/tools/bash-4.1/config-top.h /home/tools/bash-4.1/config-top.h.bck
mv /home/tools/bash-4.1/bashhist.c /home/tools/bash-4.1/bashhist.c.bck
cd bash-4.1
wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/bash_%E7%94%A8%E6%88%B7%E5%AE%A1%E8%AE%A1/config-top.h
wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/bash_%E7%94%A8%E6%88%B7%E5%AE%A1%E8%AE%A1/bashhist.c
 sleep 3
./configure --prefix=/usr/local/bash_new
make && make install
echo "/usr/local/bash_new/bin/bash" >> /etc/shells
echo "sed -i '#root:x:0:0:root:/root:/bin/bash#root:x:0:0:root:/root:/usr/local/bash_new/bin/bash#g'  /etc/passwd"

#useradd -s /usr/local/bash_new/bin/bash watson
#ssh-keygen -t rsa -C "watson@irainbow7.com"
#cat /home/watson/.ssh/id_rsa.pub >>/home/watson/.ssh/authorized_keys
#chmod 700 /home/watson/.ssh
#chmod 600 /home/watson/.ssh/authorized_keys
