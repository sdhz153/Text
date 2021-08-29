## 安装依赖
###
    apt-get install build-essential libpcre3 libpcre3-dev zlib1g-dev git dbus manpages-dev aptitude g++ wget curl unzip
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
###
    server {
        listen       443 ssl http2;
        listen [::]:443 ssl ipv6only=on http2;
        server_name  www.u1314.tk u1314.tk;
        ssl_certificate      /etc/nginx/ssl/www.1314.tk_chain.crt;
        ssl_certificate_key  /etc/nginx/ssl/www.1314.tk_key.key;

        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;

        ssl_ciphers  TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
        ssl_prefer_server_ciphers  on;
        ssl_protocols                TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
        ssl_session_tickets          on;
        location / {
            root   html;
            index  index.html index.htm;
        }
        location /1cd84ae0-422d-b0d0-bd16-b25a62438124/ {
            proxy_redirect off;
            proxy_pass http://127.0.0.1:23256;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $http_host;
        }
    }
     server {
        listen       80;
        server_name  1314.tk;
        return 301 https://www.1314.tk$request_uri;
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
     }
###
