#/bin/bash
EIP=13.124.95.140
INSTANCE_ID=i-0126ca99d720523c6
/usr/bin/aws ec2 assign-private-ip-addresses --allow-reassignment \
--network-interface-id  $INTERFACE_ID --private-ip-addresses $PIP
