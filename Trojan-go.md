## 基础工具下载安装
###
    apt-get -y update && apt-get -y install unzip wget curl nano
###
## 校准时间
###
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && date -R
###

## 新建一个目录，作为trojan-go的安装目录
###
	mkdir /etc/trojan /etc/trojan/bin /etc/trojan/conf /usr/share/trojan-go
###

## 安装trojan-go
###
	wget --no-check-certificate -O /etc/trojan/bin/trojan-go-linux-amd64.zip "https://github.com/p4gefau1t/trojan-go/releases/download/v0.8.2/trojan-go-linux-amd64.zip"
###
## 解压trojan-go
###
	unzip -o -d /etc/trojan/bin /etc/trojan/bin/trojan-go-linux-amd64.zip
###
## 复制server.json文件
###
	cp /etc/trojan/bin/example/server.json /etc/trojan/conf/server.json
###
## 复制trojan-go.service文件
###
	cp /etc/trojan/bin/example/trojan-go.service /etc/systemd/system/trojan.service
###
## 复制geoip.dat和geosite.dat文件
###
	cp /etc/trojan/bin/geoip.dat /usr/share/trojan-go/geoip.dat
	cp /etc/trojan/bin/geosite.dat /usr/share/trojan-go/geosite.dat
###

## 修改/etc/systemd/system/trojan.service文件

###
    ExecStart=..................
	修改为
	ExecStart=/etc/trojan/bin/trojan-go -config /etc/trojan/conf/server.json
###

## 修改/etc/trojan/conf/server.json文件
###
    {
        "run_type": "server",
        "local_addr": "0.0.0.0",
        "local_port": 1443,
        "remote_addr": "127.0.0.1",
        "remote_port": 80,
        "password": [
        "1c02c27e-f255-bf18-15ab-979a852715aa"
        ],
        "ssl": {
            "cert": "/etc/ssl/caddy/www.u360.ml_chain.crt",
            "key": "/etc/ssl/caddy/www.u360.ml_key.key",
            "sni": "www.u360.ml"
        },
        "websocket": {
            "enabled": true,
            "path": "/a43c9856-5b38-81d8-835c-97ea4dd26361/",
            "host": "www.u360.ml"
        },
        "mux": {
            "enabled": true,
            "concurrency": 8,
            "idle_timeout": 60
        },
        "router": {
            "enabled": true,
            "block": [
            "geoip:private"
            ],
            "geoip": "/usr/share/trojan-go/geoip.dat",
            "geosite": "/usr/share/trojan-go/geosite.dat"
        }
    }
###

## 安装caddy2
###
echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
| tee -a /etc/apt/sources.list.d/caddy-fury.list

apt-get -y update && apt-get -y install caddy
###
## 确认caddy版本
###
	caddy version
###
## 配置caddy2证书

###
	mkdir -p /etc/ssl/caddy
###
## 配置/etc/caddy/Caddyfile
###
    www.u360.ml:443 u360.ml:443 {
    root * /usr/share/caddy
    file_server
    tls /etc/ssl/caddy/www.u360.ml_chain.crt /etc/ssl/caddy/www.u360.ml_key.key {
       protocols tls1.2 tls1.3
       ciphers TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
       curves x25519
    }
    @v2ray_websocket {
        path /a43c9856-5b38-81d8-835c-97ea4dd26361/
        header Connection *Upgrade*
        header Upgrade websocket
    }
    }
    www.u360.ml:80 u360.ml:80 {
       redir https://u360.ml{uri}
    }	
###

## 开启BBR加速（可跳过）
###
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf && sysctl -p && lsmod | grep bbr
###

## 加载trojan-go
###
	systemctl daemon-reload
###
## 开启trojan-go
###
	systemctl start trojan.service

	systemctl status trojan.service
###
## 设置为开机自动启动
###
	systemctl enable trojan.service
###
## 每次修改后都要执行一次重启
###
	systemctl restart trojan.service
###
## 停止caddy
###
	service trojan.service stop
###

## 开启caddy2
###
systemctl start caddy

systemctl status caddy
###
## 设置为开机自动启动
###
systemctl enable caddy
###
## 每次修改后都要执行一次重启
###
systemctl restart caddy
###
## 停止caddy
###
service caddy stop
###

## 服务器防火墙开启
###
	80  443  1443
###
