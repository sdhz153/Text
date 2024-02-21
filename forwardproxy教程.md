
## 基础工具下载安装
###
    apt update && apt -y install libnss3 wget git
###
## 校准时间
###
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && date -R
###
## 下载安装GO编程语言
###
    wget https://golang.org/dl/go1.15.3.linux-amd64.tar.gz
###
## 解压至/usr/local/
###
    tar -C /usr/local -xzf go1.15.3.linux-amd64.tar.gz
###
##在/etc/profile中添加 Go 环境变量:
###
    echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
###

## 使修改的配置文件立即生效
###
    source /etc/profile
###
## 检查是否配置成功
###
    go version
###
## 编译安装 Caddy 和 forwardproxy 插件
## 克隆forwardproxy源码
## 拉取编译安装caddy定制化编译工具xcaddy
## 使用xcaddy拉取caddy并和forwardproxy插件一起编译
###
    go get -u github.com/caddyserver/xcaddy/cmd/xcaddy
###
    ~/go/bin/xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive
###
    setcap cap_net_bind_service=+ep ./caddy
###
    mkdir -p /usr/share/caddy
###
    mkdir -p /etc/ssl/caddy
###
    nano /root/Caddyfile
###

## 编译成功后，可以看到当前目录中存在一个名为caddy的文件。

## 在当前目录新建一个Caddyfile配置文件，配置文件示例如下，注意修改示例值和caddy.json配置文件二选一。
###
       :443, www.sdhz.tk
       tls /etc/ssl/caddy/www.sdhz.tk_chain.crt /etc/ssl/caddy/www.sdhz.tk_key.key {
           protocols tls1.2 tls1.3
           ciphers TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
           curves x25519
       }
       route {
         forward_proxy {
           basic_auth sdhz ace9aef5-d495-3fe9-432a-22ced7d61bce
           hide_ip
           hide_via
           probe_resistance github.com
         }
         file_server { root /usr/share/caddy }
      }
###


## 在当前目录新建一个caddy.json配置文件，配置文件示例如下，注意修改示例值和Caddyfile配置文件二选一。
###
    {
    "apps": {
    "http": {
      "servers": {
        "srv0": {
          "listen": [":443"],
          "routes": [{
            "handle": [{
              "handler": "forward_proxy",
              "hide_ip": true,
              "hide_via": true,
              "auth_user": "sdhz", 
              "auth_pass": "54f94054-8f6e-2aa5-1a4d-a70a5324982a",
              "probe_resistance": {"domain": "bilibili.com:443"}
            }]
          }, {
            "match": [{"host": ["www.sdhz.tk"]}],
            "handle": [{
              "handler": "file_server",
              "root": "/usr/share/caddy"
            }],
            "terminal": true
          }],
          "tls_connection_policies": [{
            "match": {"sni": ["www.sdhz.tk"]}
          }]
        }
      }
    },
    "tls": {
      "certificates": {
        "load_files": [{
          "certificate": "/etc/ssl/caddy/www.sdhz.tk.pem",
          "key": "/etc/ssl/caddy/www.sdhz.tk.key"
        }]
      }
    }
    }
    }
###
## 新建一个web伪装站点目录/var/www/html，随便找个网站源码放进去。建议放个云服务网站的登录界面，这样比较符合长时间连接访问这个网站的特点。

## 开启BBR加速（可跳过）
###
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf && sysctl -p && lsmod | grep bbr
###

### 注册systemd服务,注意修改示例值是caddy.json把下面改为caddy.json
### ExecStart=/root/caddy run --environ --config /root/Caddyfile
### ExecReload=/root/caddy reload --config /root/Caddyfile
### 新建caddy.service文件，命令：
###
    nano /etc/systemd/system/caddy.service
###
### 添加如下内容
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
### 重载systemctl服务
    systemctl daemon-reload

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
