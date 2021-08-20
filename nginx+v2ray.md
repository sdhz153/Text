## 操作系統debian10 ubuntu18.04

###
    apt-get -y update && apt-get -y install unzip wget curl  nano
###

## 校准时间

###
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && date -R
###

## 安装v2ray
###
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh && bash install-release.sh
###

## 安装指定版本（下载v2ray-linux-xx.zip.dgst和v2ray-linux-xx.zip）上传位置 /root

###
    bash install-release.sh --local ./v2ray-linux-xx.zip
###

安装nginx

###
    apt install nginx
###

停止nginx

###
    service nginx stop
###

## 配置nginx
 
###
    mkdir /etc/nginx/ssl
###
    nano /etc/nginx/conf.d/default.conf
###

###
    server {
        listen       443 ssl;
        server_name  www.mu.tk;
        root  /usr/share/nginx/html;
	index index.html index.htm index.php default.html default.htm default.php;
	ssl on;
        ssl_certificate ssl/www.mu.tk_chain.crt;
        ssl_certificate_key ssl/www.mu.tk_key.key;
        ssl_session_timeout 5m;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

        location /d12f17ad-a344-f61b-1fef-13a2a2d98663/ {
            proxy_redirect off;
            proxy_pass http://127.0.0.1:43627;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $http_host;
        }
    }
    server {
        listen 80;
	server_name www.mu.tk;
	return 301 https://www.bilibili.com$request_uri;
    }
###



## 修改配置
## 编辑 /etc/v2ray/config.json 文件来配置你需要的代理方式。

###
    nano /usr/local/etc/v2ray/config.json

## VLESS
###
    {
     "log": {
           "access": "/var/log/v2ray/access.log",
           "error": "/var/log/v2ray/error.log",
           "loglevel": "warning"
      },
     "inbounds": [
       {
       "port":43627,
         "listen": "127.0.0.1", 
         "tag": "VLESS-in", 
         "protocol": "VLESS", 
         "settings": {
           "clients": [
             {
	     "id":"3f094ce3-ab40-ad8e-f9fc-941bd8667e8c",
               "alterId": 0
             }
           ],
	    "decryption": "none"
      }, 
      "streamSettings": {
        "network": "ws", 
        "wsSettings": {
	  "path":"/d12f17ad-a344-f61b-1fef-13a2a2d98663/"
        }
      }
    }
     ], 
     "outbounds": [
    {
      "protocol": "freedom", 
      "settings": { }, 
      "tag": "direct"
    }, 
    {
      "protocol": "blackhole", 
      "settings": { }, 
      "tag": "blocked"
    }
     ],
     "routing": {
       "domainStrategy": "AsIs",
       "rules": [
      {
        "type": "field",
        "inboundTag": [
          "VLESS-in"
        ],
        "outboundTag": "direct"
      }
    ]
     }
    }
###
## vmess
###
    {
        "log": {
            "access": "/var/log/v2ray/access.log",
            "error": "/var/log/v2ray/error.log",
            "loglevel": "warning"
        },
        "inbound": {
            "port": 43627,
	    "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                    "id": "3f094ce3-ab40-ad8e-f9fc-941bd8667e8c",
                    "level": 1,
                    "alterId": 64
                }
            ]
        },
        "streamSettings": {
        "network": "ws",
			"wsSettings": {
            "path": "/d12f17ad-a344-f61b-1fef-13a2a2d98663/"
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
