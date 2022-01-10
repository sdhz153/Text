## 安装依赖
###
    apt update && apt -y install build-essential libpcre3 libpcre3-dev zlib1g-dev git dbus manpages-dev aptitude g++ wget curl unzip
###

## 1.下载/安装 openssl-1.1.1（使 nginx 支持TLS 1.3）
###
    wget -nc --no-check-certificate https://www.openssl.org/source/openssl-1.1.1k.tar.gz
###
###
    tar -zxvf openssl-1.1.1k.tar.gz
###
###
    wget -nc --no-check-certificate http://nginx.org/download/nginx-1.19.9.tar.gz
###
###
    tar -zxvf nginx-1.19.9.tar.gz
###
###
    cd nginx-1.19.9
###
###
    mkdir -p /etc/nginx/ssl
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
          --with-cc-opt='-O3' \
          --with-openssl=../openssl-1.1.1k
###
###
    make && make install
###
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

## /etc/nginx/nginx.conf
###
     https://github.com/sdhz153/Text/blob/main/nginx.conf
###

## 校准时间

###
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && date -R
###

## 安装v2ray
###
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh && bash install-release.sh
###


## BBR
## 修改系统变量

###
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf && sysctl -p && lsmod | grep bbr
###

## 开启nginx

###
    systemctl start nginx && systemctl status nginx && systemctl enable nginx
###

## 重新启动
###
    systemctl restart nginx
###

## 停止nginx
###
    service nginx stop
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
