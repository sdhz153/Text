##暂停IPv6以停止“我们的系统检测到您的计算机网络中存在异常流量”警告

## 1.终端连接查看是否启动IPv6

###
	cat /proc/sys/net/ipv6/conf/all/disable_ipv6
###

## 返回结果显示为0则是已启动，1是已禁止。

## 2.执行以下三条命令，临时禁用IPv6

###
	sysctl -w net.ipv6.conf.all.disable_ipv6=1 
###
	sysctl -w net.ipv6.conf.default.disable_ipv6=1
###
	sysctl -w net.ipv6.conf.lo.disable_ipv6=1
###

## 3.再次执行命令查看，正常这时IPv6已经给禁止，需要重新启用则重启服务器即可

###
	cat /proc/sys/net/ipv6/conf/all/disable_ipv6
###