## 查看openssl版本

###
	openssl version
###

## 安装依赖

###
    apt update && apt -y install build-essential libpcre3 libpcre3-dev zlib1g-dev git dbus manpages-dev aptitude g++ wget curl unzip gcc
###

## 更新openssl

###
	wget -nc --no-check-certificate https://www.openssl.org/source/openssl-1.1.1m.tar.gz
###

## 解压
###
	tar -xzvf openssl-1.1.1m.tar.gz
###

## 进入

###
	cd openssl-1.1.1m
###
	./config
###
## 安装
###
	make && make install
###

## 查看openssl版本

###
	openssl version
###
## 要是版本没变从新开启新的终端

## 说明：升级后如果执行 openssl version 命令出现openssl: error while loading shared 
## libraries: libssl.so.1.1: cannot open shared object file: No such file or directory错误。执行以下命令即可。

###
	ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
	ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
###

## 说明：升级后如果执行 openssl version 命令出现openssl: symbol lookup error: openssl: undefined symbol: EVP_mdc2, version OPENSSL_1_1_0

###
    ldconfig
###

## 查看debian版本

###
    cat /etc/issue
###

## 更新系统

###
    apt-get update  && apt-get upgrade
###
