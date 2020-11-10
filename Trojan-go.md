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
    mkdir -p /etc/trojan-go/bin /usr/share/trojan-go
###

## 安装trojan-go
###
    wget --no-check-certificate -O /etc/trojan-go/bin/trojan-go-linux-amd64.zip "https://github.com/p4gefau1t/trojan-go/releases/download/v0.8.2/trojan-go-linux-amd64.zip"
###
## 解压trojan-go
###
    unzip -o -d /etc/trojan-go/bin /etc/trojan-go/bin/trojan-go-linux-amd64.zip
###
## 复制server.json文件
###
    cp /etc/trojan-go/bin/example/server.json /etc/trojan-go/config.json
###
    cp /etc/trojan-go/bin/trojan-go /usr/bin/trojan-go
###

## 复制trojan-go.service文件
###
    cp /etc/trojan-go/bin/example/trojan-go.service /etc/systemd/system/trojan.service
###
    cp /etc/trojan-go/bin/example/trojan-go@.service /etc/systemd/system/trojan@.service
###
## 复制geoip.dat和geosite.dat文件
###
    cp /etc/trojan-go/bin/geoip.dat /usr/share/trojan-go/geoip.dat
###
    cp /etc/trojan-go/bin/geosite.dat /usr/share/trojan-go/geosite.dat
###
## 修改/etc/trojan-go/config.json文件
###
    {
        "run_type": "server",
        "local_addr": "0.0.0.0",
        "local_port": 443,
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

    apt update && apt install caddy
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
    :80 {
	    file_server { root /usr/share/caddy }
	    @websocket {
		    path /a43c9856-5b38-81d8-835c-97ea4dd26361/
		    header Connection *Upgrade*
		    header Upgrade websocket
	    }
    }	
###

## 开启BBR加速（可跳过）
###
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf && sysctl -p && lsmod | grep bbr
###

## 开启caddy2
###
    systemctl start caddy
###
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

## 加载trojan-go
###
    systemctl daemon-reload
###
## 开启trojan-go
###
    systemctl start trojan.service
###
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
## 停止trojan-go
###
    service trojan.service stop
###
## 服务器防火墙开启
###
    80  443
###
