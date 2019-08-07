#!/bin.sh
#
#
#
BASEDIR=/home/data/backup/oss
SIR=/home/projects/oss
TIM=$(date +%Y-%m-%d\_%H:%M:%S)
tar zcf $BASEDIR/Base_oss_$TIM.tar.gz $SIR


