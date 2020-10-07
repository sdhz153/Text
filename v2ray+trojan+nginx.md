操作系統debian9.9 ubuntu18.04

更新系统
###
    apt update && apt upgrade
###

下载
###
    apt-get -y update && apt-get -y install unzip wget curl  nano
###

校准时间
###
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && date -R
###

安装nginx
###
    apt install nginx
###

停止nginx

###
    service nginx stop
###

创建ssl文件夹放证书
###
    mkdir /etc/nginx/ssl
###

创建dhparam
###
    openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
###

创建default.conf文件

###
    touch /etc/nginx/conf.d/default.conf
###
###
    nano /etc/nginx/conf.d/default.conf
###

###
    server {
        listen 80;
        #listen [::]:80;
        server_name www.sd.tk sd.tk;
        #将http重定向到https
        return 301 https://www.sd.tk$request_uri;
    }
    server {
        listen 443 ssl http2;
        #listen [::]:443 ssl http2;
        server_name www.sd.tk sd.tk;
        ssl on;
        ssl_certificate ssl/4582418_www.sd.tk.pem;
        ssl_certificate_key ssl/4582418_www.sd.tk.key;
        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;
        ssl_ciphers "EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5";
        ssl_session_cache builtin:1000 shared:SSL:10m;
        ssl_dhparam /etc/nginx/ssl/dhparam.pem;
	access_log off;
	location / {
        #向后端传递访客IP
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #设定需要反代的域名，可以加端口号
	proxy_pass https://movie.youku.com/?spm=a2ha1.14919748_WEBHOME_GRAY.drawer4.d_zj1_3;
        #替换网站内容
        sub_filter 'movie.youku.com/?spm=a2ha1.14919748_WEBHOME_GRAY.drawer4.d_zj1_3' 'www.sd.tk';
	location /ba1d98f3-d9af-a4d3-bff3-43f5b3c8ad19/ {
          proxy_redirect off;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_set_header Host $http_host;
          proxy_intercept_errors on;
          if ($http_upgrade = "websocket" ){
             proxy_pass http://127.0.0.1:10892;
          }
       }
    }
    }
###

安装v2ray
###
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh && bash install-release.sh
###

安装v2ray指定版本（下载v2ray-linux-64.zip.dgst和v2ray-linux-64.zip）
###
    bash install-release.sh --local ./v2ray-linux-64.zip
###

修改config.json配置
###
    nano /usr/local/etc/v2ray/config.json
###

###
    {
    "log": {
        "access": "/var/log/v2ray/access.log",
        "error": "/var/log/v2ray/error.log",
        "loglevel": "warning"
    },
    "inbound": {
    "port": 10892,
		"listen": "127.0.0.1",
        "protocol": "vmess",
        "settings": {
            "clients": [
                {
                    "id": "31783c1b-f6af-999b-08c4-d69cf2cbd74a",
                    "level": 1,
                    "alterId": 64
                }
            ]
        },
        "streamSettings": {
        "network": "ws",
			"wsSettings": {
            "path": "/ba1d98f3-d9af-a4d3-bff3-43f5b3c8ad19/"
            }

        }
    },
    "outbound": {
        "protocol": "freedom",
        "settings": {}
    },
    "inboundDetour": [],
    "outboundDetour": [
        {
            "protocol": "blackhole",
            "settings": {},
            "tag": "blocked"
        }
    ],
    "routing": {
        "strategy": "rules",
        "settings": {
            "rules": [
                {
                    "type": "field",
                    "ip": [
                        "0.0.0.0/8",
                        "10.0.0.0/8",
                        "100.64.0.0/10",
                        "127.0.0.0/8",
                        "169.254.0.0/16",
                        "172.16.0.0/12",
                        "192.0.0.0/24",
                        "192.0.2.0/24",
                        "192.168.0.0/16",
                        "198.18.0.0/15",
                        "198.51.100.0/24",
                        "203.0.113.0/24",
                        "::1/128",
                        "fc00::/7",
                        "fe80::/10"
                    ],
                    "outboundTag": "blocked"
                }
            ]
        }
    }
    }

###

安装trojan
###
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
###

修改config.json配置
###
    nano /usr/local/etc/trojan/config.json
###
修改三处
###
    {
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 1443,        # 修改为1443
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "55a03aa7-8909-2198-395c-5a8c23fcfa8b"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/etc/nginx/ssl/4582418_www.sd.tk.pem",   # 证书路径
        "key": "/etc/nginx/ssl/4582418_www.sd.tk.key",    # 证书路径
        "key_password": "",
        "cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true,
        "alpn": [
            "http/1.1"
        ],
        "alpn_port_override": {
            "h2": 81
        },
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": ""
    },
    "tcp": {
        "prefer_ipv4": false,
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": false,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": "",
        "key": "",
        "cert": "",
        "ca": ""
    }
    }

###

开启BBR加速
###
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf && sysctl -p && lsmod | grep bbr
###

启动nginx
###   
     加载
     systemctl start nginx
     
     运行
     systemctl status nginx
     
     开机自动启动
     systemctl enable nginx
     
     重新启动
     systemctl restart nginx
     
     停止nginx
     service nginx stop
###

启动 trojan
###
         加载
     systemctl start trojan
     
     运行
     systemctl status trojan
     
     开机自动启动
     systemctl enable trojan
     
     重新启动
     systemctl restart trojan
     
     停止nginx
     service trojan stop
###

启动 V2Ray
###
         加载
     systemctl start v2ray
     
     运行
     systemctl status v2ray
     
     开机自动启动
     systemctl enable v2ray
     
     重新启动
     systemctl restart v2ray
     
     停止nginx
     service v2ray stop
###

服务器防火墙开启
###
    trojan local_port": 1443
    
    1443 tcp
    
    v2ray "port": 10892,
    
    10892 tcp
    10892 udp
###
