操作系統debian10 ubuntu18.04

###
       apt-get -y update && apt-get -y install unzip wget curl  nano libnss3
###

校准时间

###
     ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && date -R
###

安装v2ray
###
     curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh && bash install-release.sh
###

安装指定版本（下载v2ray-linux-xx.zip.dgst和v2ray-linux-xx.zip）上传位置 /root

###
     bash install-release.sh --local ./v2ray-linux-xx.zip
###

安装caddy2

###
     echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
    | sudo tee -a /etc/apt/sources.list.d/caddy-fury.list

    apt update && apt install caddy
###

确认caddy版本
###
    caddy version
###

#配置caddy2证书
 
###
      mkdir -p /etc/ssl/caddy
###

配置/etc/caddy/Caddyfile
###
    www.mu.tk:443 mu.tk:443 {
    root * /usr/share/caddy
    file_server
    tls /etc/ssl/caddy/4582418_www.mu.tk.pem /etc/ssl/caddy/4582418_www.mu.tk.key {
        protocols tls1.2 tls1.3
        ciphers TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
        curves x25519
    }
    @v2ray_websocket {
        path /d12f17ad-a344-f61b-1fef-13a2a2d98663/
        header Connection *Upgrade*
        header Upgrade websocket
    }
    reverse_proxy @v2ray_websocket localhost:43627
    }
     www.mu.tk:80 mu.tk:80 {
       redir https://github.com/sdhz153{uri}
    }
###



修改配置
编辑 /etc/v2ray/config.json 文件来配置你需要的代理方式。

###
    nano /usr/local/etc/v2ray/config.json

VLESS
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
vmess
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
    "local_port": 1443,        # 端口443修改为1443，客户端内的端口要填1443
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "55a03aa7-8909-2198-395c-5a8c23fcfa8b"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/etc/nginx/ssl/4582418_www.mu.tk.pem",   # 证书路径
        "key": "/etc/nginx/ssl/4582418_www.mu.tk.key",    # 证书路径
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
BBR
修改系统变量

###
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf && sysctl -p && lsmod | grep bbr
###

开启caddy2

###
    systemctl start caddy

    systemctl status caddy

#设置为开机自动启动

    systemctl enable caddy

#每次修改后都要执行一次重启

    systemctl restart caddy

#停止caddy

    service caddy stop
###

启动 V2Ray

###
    systemctl start v2ray
###

###
    systemctl status v2ray
###

#设置为开机自动启动
###
    systemctl enable v2ray
###

每次修改后都要执行一次重启
 ###
    systemctl restart v2ray
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
###
服务器防火墙开启
###
    trojan local_port": 1443
    
    1443 tcp
    
    v2ray "port": 10892,
    
    10892 tcp
    10892 udp
###
