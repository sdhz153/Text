## 安装

###
	apt-get install ufw
###

## 查看端口开启状态

###
    ufw status
###

## 开启某个端口，比如我开启的是8381,允许所有的外部IP访问本机的8381/tcp

###
	ufw allow 8381/tcp
###

## 允许外部访问8381端口(tcp/udp)

###
	ufw allow 8381
###

## 开启防火墙

###
	ufw enable
###

## 关闭防火墙
	
###
	ufw disable
###
	
## 重启防火墙

###
	ufw reload
###

## =========================================

## 查看端口ip

###
	netstat -ltn
###

## 禁止外部某个端口比如80

###
	ufw delete allow 80
###

## 允许某特定 IP

###
	ufw allow from 192.168.254.254
###

## 删除上面的规则

###
     ufw delete allow from 192.168.254.254
###

## 修改22端口

###
     nano /etc/ssh/sshd_config
###

## 把 Port 22 改为一千以上的端口

## 重启sshd服务

###
    systemctl restart sshd
###
