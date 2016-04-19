# 配置文件

\#号开头为注释行

配置相当简洁


## 主配置文件 nginx.conf

在一个http中可以启动多个server

而在一个server中，可以有多个location配置

```html
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;
    server {
        listen 8081 default_server;
        
        root E:\app;
        index index.html index.htm;
    }
    
    server {
            listen       80;
            server_name  www.android-doc.org;
            root C:/Android/android-sdk/docs ;
    
            charset utf-8;
            location / {
                autoindex on;
                index  index.html index.htm index.php;
            }
    }

    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
       #listen       443 ssl;
       #server_name  localhost;

       #ssl_certificate      cert.crt;
       #ssl_certificate_key  cert_nopass.key;

       #ssl_session_cache    shared:SSL:1m;
       #ssl_session_timeout  5m;

       #ssl_ciphers  HIGH:!aNULL:!MD5;
       #ssl_prefer_server_ciphers  on;

       #location / {
           #root   html;
           #index  index.html index.htm;
       #}
    #}
}
```

# [支持php](nginx_php.md)