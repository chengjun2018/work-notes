#!/bin/bash
#
#
#
#
backup_dir=/home/data/backup
S_dir1=/home/application/nginx/conf/pools/
S_dir2=/home/application/nginx/conf/vhost/
Nginx_file=/home/application/nginx/conf/nginx.conf
Time=$(date +%F)
tar zcfP $backup_dir/proxy-3.pools.vhost-$Time.tar.gz $S_dir1 $S_dir2 $Nginx_file 
