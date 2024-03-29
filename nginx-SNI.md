## 查看debian版本

###
    cat /etc/issue
###

## 更新系统

###
    apt-get update  && apt-get upgrade
###

## 安装依赖

###
    apt update && apt -y install build-essential libpcre3 libpcre3-dev zlib1g-dev git dbus manpages-dev aptitude g++ wget curl unzip
###

## 1.下载/安装 openssl-1.1.1（使 nginx 支持TLS 1.3）

###
    wget -nc --no-check-certificate https://www.openssl.org/source/openssl-1.1.1n.tar.gz
###
    tar -zxvf openssl-1.1.1n.tar.gz
###
    wget -nc --no-check-certificate https://nginx.org/download/nginx-1.20.2.tar.gz
###
    tar -zxvf nginx-1.20.2.tar.gz
###
    rm -rf nginx-1.20.2.tar.gz && cd nginx-1.20.2
###

###
    ./configure --prefix=/etc/nginx \
	--with-http_ssl_module \
	--with-http_gzip_static_module \
	--with-http_stub_status_module \
	--with-pcre \
	--with-http_realip_module \
	--with-http_flv_module \
	--with-http_mp4_module \
	--with-http_secure_link_module \
	--with-http_v2_module \
	--with-http_auth_request_module \
	--with-http_dav_module \
	--with-http_slice_module \
	--with-http_addition_module \
	--with-http_gunzip_module \
	--with-http_sub_module \
	--with-cc-opt='-O3' \
	--with-cpu-opt=CPU \
	--with-openssl-opt=enable-tls1_3 \
	--with-openssl=../openssl-1.1.1n \
	--with-stream \
	--with-stream_ssl_preread_module \
	--with-stream_ssl_module \
	--with-stream_realip_module \
	--with-threads
###
    make && make install
###
    cat >/etc/systemd/system/nginx.service <<EOF
    [Unit]
    Description=A high performance web server and a reverse proxy server
    Documentation=man:nginx(8)
    After=network.target nss-lookup.target

    [Service]
    Type=forking
    PIDFile=/etc/nginx/logs/nginx.pid
    ExecStartPre=/etc/nginx/sbin/nginx -t -q -g 'daemon on; master_process on;'
    ExecStart=/etc/nginx/sbin/nginx -g 'daemon on; master_process on;'
    ExecReload=/etc/nginx/sbin/nginx -g 'daemon on; master_process on;' -s reload
    ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /etc/nginx/logs/nginx.pid
    TimeoutStopSec=5
    KillMode=mixed

    [Install]
    WantedBy=multi-user.target
    EOF
###

###
    mkdir -p /etc/nginx/ssl /etc/systemd/system/nginx.service.d
###

###
    printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
###

## /etc/nginx/conf/nginx.conf

###
    https://github.com/sdhz153/Text/blob/main/SNI/nginx.conf
###

## 校准时间

###
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && date -R
###

## 安装xray

###
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
###


## 安装v2ray

###
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh && bash install-release.sh
###


## 编辑 /etc/v2ray/config.json 文件来配置你需要的代理方式。

## 编辑 /etc/xray/config.json 文件来配置你需要的代理方式,把log修改为

##    "log": {

##        "access": "/var/log/xray/access.log",
##		"error": "/var/log/xray/error.log",

##       "loglevel": "warning"

##   },

## VMess

## VLESS

###
    https://github.com/sdhz153/Text/blob/main/SNI/config.json
###

## 安装Trojan-go

###
    wget -nc --no-check-certificate https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip
###
    unzip -o trojan-go-linux-amd64.zip -d /etc/trojan-go
###
    rm -rf trojan-go-linux-amd64.zip
###
    mkdir -p /etc/ssl/trojan /usr/share/trojan-go
###
    sed -i 's/User=nobody/User=root/' /etc/trojan-go/example/trojan-go.service
###
    sed -i 's#ExecStart=/usr/bin/trojan-go -config /etc/trojan-go/config.json#ExecStart=/etc/trojan-go/trojan-go -config /etc/trojan-go/example/server.json#' /etc/trojan-go/example/trojan-go.service
###
    sed -i 's/User=nobody/User=root/' /etc/trojan-go/example/trojan-go@.service
###
    sed -i 's#ExecStart=/usr/bin/trojan-go -config /etc/trojan-go/%i.json#ExecStart=/etc/trojan-go/trojan-go -config /etc/trojan-go/example/%i.json#' /etc/trojan-go/example/trojan-go@.service
###
    cp /etc/trojan-go/example/trojan-go.service /etc/systemd/system/trojan-go.service
###
    cp /etc/trojan-go/example/trojan-go@.service /etc/systemd/system/trojan-go@.service
###
    cp /etc/trojan-go/geosite.dat /usr/share/trojan-go/geosite.dat
###
    cp /etc/trojan-go/geoip.dat /usr/share/trojan-go/geoip.dat
###
	
## 修改 server.json
	
###
    https://github.com/sdhz153/Text/blob/main/SNI/server.json
###
	
##证书自己申请，放在/etc/ssl/trojan/

	
## 开启BBR


###
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf && sysctl -p && lsmod | grep bbr
###

## 重新加载单元

###
    systemctl daemon-reload
###

## 开启nginx

###
    systemctl start nginx
###
    systemctl status nginx
###

## 设置为开机自动启动

###
    systemctl enable nginx
###

## 重新启动

###
    systemctl restart nginx
###

## 停止nginx

###
    service nginx stop
###

## 启动 XTLS

###
    systemctl start xray
###

###
    systemctl status xray
###

## 设置为开机自动启动

###
    systemctl enable xray
###

## 每次修改后都要执行一次重启

 ###
    systemctl restart xray
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

## 启动 Trojan

###
    systemctl start trojan-go.service
###

###
    systemctl status trojan-go.service
###

## 设置为开机自动启动

###
    systemctl enable trojan-go.service
###

## 每次修改后都要执行一次重启

###
    systemctl restart trojan-go.service
###

## 关闭 trojan-go

###
    service trojan-go stop
###

## 查看错误日志

###
    journalctl -fu trojan-go
###
