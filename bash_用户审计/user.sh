#!/bin/bash
#
#
#
yum install gcc -y
cd /home/tools/
wget https://raw.githubusercontent.com/chengjun2018/work-notes/master/bash_%E7%94%A8%E6%88%B7%E5%AE%A1%E8%AE%A1/bash-4.1.1.tar.gz
tar xf bash-4.1.1.tar.gz
cd bash-4.1
./configure --prefix=/usr/local/bash_new
make && make install
echo "/usr/local/bash_new/bin/bash" >> /etc/shells
echo "sed -i '#root:x:0:0:root:/root:/bin/bash#root:x:0:0:root:/root:/usr/local/bash_new/bin/bash#g'  /etc/passwd"



