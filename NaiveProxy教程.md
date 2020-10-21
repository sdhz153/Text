
## 开启BBR加速（可跳过）
###
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf && echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf && sysctl -p && lsmod | grep bbr
###
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

    ~/go/bin/xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive

    setcap cap_net_bind_service=+ep ./caddy

    mkdir -p /var/www/html

    mkdir -p /etc/ssl/tls
###

## 编译成功后，可以看到当前目录中存在一个名为caddy的文件。

## 在当前目录新建一个caddy.json配置文件，配置文件示例如下，注意修改示例值。
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
              "root": "/var/www/html"
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
          "certificate": "/etc/ssl/tls/www.sdhz.tk.pem",
          "key": "/etc/ssl/tls/www.sdhz.tk.key"
        }]
      }
    }
    }
    }
###
## 新建一个web伪装站点目录/var/www/html，随便找个网站源码放进去。建议放个云服务网站的登录界面，这样比较符合长时间连接访问这个网站的特点。
## 运行服务端
## 下载和安装pm2
###
    wget -qO- https://getpm2.com/install.sh | bash
###
## 使用pm2启动caddy
###
    pm2 start ./caddy -n caddy -- run -config caddy.json
###
## pm2 常用命令

 ## 停止服务
 ###
    pm2 stop caddy
###
 ## 查看状态
 ###
    pm2 status caddy
###
## 重启服务
###
    pm2 restart caddy
###
 ## 查看服务的参数信息
 ###
    pm2 show caddy
###
 ## 查看服务日志
 ###
    pm2 log caddy
###
 ## 查看已部署的服务列表
 ###
    pm2 ls
###
 ## 监控服务状态
 ###
    pm2 monit
###
 ## 清理所有日志文件
 ###
    pm2 flush
###
 ## 更新 pm2 状态
 ###
    pm2 update
###
