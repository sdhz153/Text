##��ͣIPv6��ֹͣ�����ǵ�ϵͳ��⵽���ļ���������д����쳣����������

## 1.�ն����Ӳ鿴�Ƿ�����IPv6

###
	cat /proc/sys/net/ipv6/conf/all/disable_ipv6
###

## ���ؽ����ʾΪ0������������1���ѽ�ֹ��

## 2.ִ���������������ʱ����IPv6

###
	sysctl -w net.ipv6.conf.all.disable_ipv6=1 
###
	sysctl -w net.ipv6.conf.default.disable_ipv6=1
###
	sysctl -w net.ipv6.conf.lo.disable_ipv6=1
###

## 3.�ٴ�ִ������鿴��������ʱIPv6�Ѿ�����ֹ����Ҫ������������������������

###
	cat /proc/sys/net/ipv6/conf/all/disable_ipv6
###