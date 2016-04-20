# 支持SSL

## 精简配置

```html
server {
       listen       443 ssl;
       listen       80;
       server_name  www.extjs6.com;
       
       ssl on;
       ssl_certificate      cert.crt;
       ssl_certificate_key  cert_nopass.key;

       set $root E:/phpwork/ext6.0.0;

       charset utf-8;
}
```


## 复杂配置

```html
 server {
        listen 80;
        listen [::]:80 ssl ipv6only=on;
        listen 443 ssl;
        listen [::]:443 ssl ipv6only=on;

        add_header Strict-Transport-Security max-age=63072000;
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;

        ssl_prefer_server_ciphers on;
        ssl_dhparam /var/www/ssl/dhparam.pem;
        ssl_protocols TLSv1.2;
        ssl_ciphers "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4";
        keepalive_timeout 70;
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;

        ssl on;
        ssl_certificate /var/www/ssl/youku.org.crt;
        ssl_certificate_key /var/www/ssl/youku.org.key;

        # Force HTTPS connection. This rules is domain agnostic
        if ($scheme != "https") {
           rewrite ^ https://$host$uri permanent;
        }

        server_name youku.org;
        set $cgipath /var/www/ca;
        set $root /var/www/ca;
        root $root;

        location / {
            root   $root;
            index  index.php index.html index.htm;

            allow   127.0.0.1;
            deny    all;
        }

#
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/local/www/nginx-dist;
        }

        location ~ .*\.php {
            allow   127.0.0.1;
            deny    all;

            root           $cgipath;
            fastcgi_pass php_processes;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME $cgipath$fastcgi_script_name;
            include        fastcgi_params;
        }
        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
        {
            expires      30d;
        }
        location ~ .*\.(js|css)?$
        {
            expires      12h;
        }
    }
```

## 参考

[Nginx 配置 SSL 证书 + 搭建 HTTPS 网站教程](https://s.how/nginx-ssl/)

[Nginx下SSL配置解释](https://www.hatoko.net/nginx/nginx-ssl.html)
