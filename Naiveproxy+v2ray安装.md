##  Naiveproxy+v2ray

##  基础工具下载安装
###
    apt-get update && apt-get upgrade
###
###
    apt-get install libnss3 wget git curl unzip
###
##  校准时间

 ```bash
 ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && date -R
 ```
##  下载安装GO编程语言
###
    wget https://golang.org/dl/go1.17.linux-amd64.tar.gz
###
##  解压至/usr/local/
###
    tar -C /usr/local -xzf go1.17.linux-amd64.tar.gz
###
##  在/etc/profile中添加 Go 环境变量:
###
    echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
###
##  使修改的配置文件立即生效
###
    source /etc/profile
###
##  编译安装 Caddy 和 forwardproxy 插件
###
    go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
###
##  克隆forwardproxy源码
###
    ~/go/bin/xcaddy build \
       --with github.com/caddyserver/forwardproxy@caddy2 \
       --with github.com/abiosoft/caddy-exec \
        --with github.com/mholt/caddy-webdav \
        --with github.com/caddy-dns/cloudflare
###
##  使用xcaddy拉取caddy并和forwardproxy插件一起

##  绑定443 80端口
###
    setcap cap_net_bind_service=+ep ./caddy
###
##  创建文件夹
###
    mkdir -p /usr/share/caddy/ /etc/ssl/caddy/ /var/log/caddy/
###


<details>
<summary>打开Caddyfile文件 保存退出</summary>
###
    nano /root/Caddyfile
###
###
    {
    	order forward_proxy before map
    	admin off
    	log {
    		output file /var/log/caddy/access.log
    		level ERROR
    	}
    	servers :443 {
    		protocol {
    			experimental_http3
    		}
    	}
    }
    :443, www.yyxx.cf {
        root * /usr/share/caddy
        file_server
    	tls /etc/ssl/caddy/www.yyxx.cf_chain.crt /etc/ssl/caddy/www.yyxx.cf_key.key {
    		ciphers TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
    		alpn h2 http/1.1
    	}
    	forward_proxy {
    		basic_auth sdhz150 3e06-4b7f-b8c6-33333
    		hide_ip
    		hide_via
    		probe_resistance github.com
    	}
    	reverse_proxy /125a62438124/ localhost:11152 {
    		transport http {
    			versions h2c
    		}
    	}
    	header {
    		Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
    	}
    }
###
</details>

##  下载安装伪网站
###
    git clone https://github.com/sdhz153/StaticPicture.git
###
##  解压至/usr/share/caddy
###
    cd StaticPicture && tar -C /usr/share/caddy -xzf caddy.tar.gz && cd
###

##  开启BBR加速（可跳过）
###
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf && sysctl -p && lsmod | grep bbr
###

##  新建caddy.service文件，命令：
###
    nano /etc/systemd/system/caddy.service
###
##  添加如下内容
###
    [Unit]
    Description=Caddy
    Documentation=https://caddyserver.com/docs/
    After=network.target network-online.target
    Requires=network-online.target

    [Service]
    User=root
    ExecStart=/root/caddy run --environ --config /root/Caddyfile
    ExecReload=/root/caddy reload --config /root/Caddyfile
    TimeoutStopSec=5s
    LimitNOFILE=1048576
    LimitNPROC=512
    PrivateTmp=true
    ProtectSystem=full
    AmbientCapabilities=CAP_NET_BIND_SERVICE

    [Install]
    WantedBy=multi-user.target
###
##  安装v2ray
###
    curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh && bash install-release.sh
###
##  编辑 /etc/v2ray/config.json
###
    {
      "log": {
        "access": "/var/log/v2ray/access.log",
        "error": "/var/log/v2ray/error.log",
        "loglevel": "warning"
     },
     "dns": {},
      "stats": {},
     "inbounds": [
       {
          "port": 11152,
         "protocol": "vmess",
          "settings": {
          "clients": [
            {
              "id": "e5be93d54c30",
              "alterId": 64
             },
              {
                "id": "faa94da0cde8",
                "alterId": 64
             },
             {
               "id": "378f852d0c1f",
               "alterId": 64
             }
           ]
          },
          "tag": "in-0",
          "streamSettings": {
            "network": "http",
            "security": "none",
            "httpSettings": {
              "path": "/125a62438124/",
              "host": [
                "www.yyxx.cf"
             ]
            }
          },
         "listen": "127.0.0.1"
        }
      ],
      "outbounds": [
        {
          "tag": "direct",
          "protocol": "freedom",
          "settings": {}
        },
        {
          "tag": "blocked",
          "protocol": "blackhole",
          "settings": {}
        }
      ],
      "routing": {
        "domainStrategy": "AsIs",
        "rules": [
          {
            "type": "field",
           "ip": [
              "geoip:private"
           ],
           "outboundTag": "blocked"
         }
        ]
      },
      "policy": {},
      "reverse": {},
      "transport": {}
    }
###

##  重载systemctl服务
###
    systemctl daemon-reload
###
##  开启caddy2
###
    systemctl start caddy && systemctl status caddy
###
##  设置为开机自动启动
###
    systemctl enable caddy
###
##  每次修改后都要执行一次重启
###
    systemctl restart caddy
###
##  停止caddy
###
    service caddy stop
###

##  启动 V2Ray
###
    systemctl start v2ray && systemctl status v2ray
###
##  设置为开机自动启动
###
    systemctl enable v2ray
###
##  每次修改后都要执行一次重启
###
    systemctl restart v2ray
###
##  停止v2ray
###
    service v2ray stop
###
