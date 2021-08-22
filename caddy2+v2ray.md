
## 基础工具下载安装
###
    apt update && apt -y install wget git curl unzip
###

## 校准时间
###
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && date -R
###
## 安装 Caddy
###
    mkdir -p /usr/share/caddy
###
###
    mkdir -p /etc/ssl/caddy
###

###
    echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
        | tee -a /etc/apt/sources.list.d/caddy-fury.list
###
###
    apt update
###
###
    apt install caddy
###

## 确定caddy文件安装在何处
###
    whereis caddy
###
## 编辑配置
###
    /etc/caddy/Caddyfile
###
###
    www.u000.tk:443, u000.tk:443 {
	    root * /usr/share/caddy
        log {
            output file /etc/caddy/caddy.log
        }
	    file_server
	    tls /etc/ssl/caddy/www.u000.tk_chain.crt /etc/ssl/caddy/www.u000.tk_key.key {
		    protocols tls1.2 tls1.3
		    ciphers TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
		    curves x25519
	    }
	    reverse_proxy /5b14023b-da32-09b8-03fe-05f0ec70efba/ localhost:13627 {
            transport http {
              versions h2c
            }
	    }
    }
###

## 安装v2ray
###
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh && bash install-release.sh
###

## 修改配置
## 编辑 /etc/v2ray/config.json 文件来配置你需要的代理方式。
###
    nano /usr/local/etc/v2ray/config.json
###

##开起BBR需要内核4.9以上
###
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf && sysctl -p && lsmod | grep bbr
###

##重载systemctl服务
###
    systemctl daemon-reload
###


##启动caddy2服务
###
    systemctl start caddy
###
##查看运行状态
###
    systemctl status caddy
###

##每次修改后都要执行一次重启
###
    systemctl restart caddy
###

##停止caddy
###
    service caddy stop
###
## 启动 V2Ray

###
    systemctl start v2ray
###

###
    systemctl status v2ray
###

## 设置为开机自动启动
###
    systemctl enable v2ray
###

## 每次修改后都要执行一次重启
 ###
    systemctl restart v2ray
###
