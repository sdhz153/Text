## �鿴openssl�汾

###
	openssl version
###

## ����openssl

###
	wget https://www.openssl.org/source/openssl-1.1.1m.tar.gz
###

## ��ѹ
###
	tar -xzvf openssl-1.1.1m.tar.gz
###

## ����

###
	cd openssl-1.1.1m
###
	./config
###
## ��װ
###
	make && make install
###

## �鿴openssl�汾

###
	openssl version
###
## Ҫ�ǰ汾û����¿����µ��ն�

## ˵�������������ִ�� openssl version �������openssl: error while loading shared 
## libraries: libssl.so.1.1: cannot open shared object file: No such file or directory����ִ����������ɡ�

###
	ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
	ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
###