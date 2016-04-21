# 限制下载连接

In http {}

```html
    limit_conn_zone $binary_remote_addr zone=by_addr:10m; 
    limit_conn_zone $server_name zone=by_server:10m;  
```


```html
server {
        listen       8080;
        server_name  sing.com;

        root  /var/www/site.com/;
        
        location /dl/ {
            internal;
            alias /var/www/mydl/files/;
            limit_conn by_addr 1;
            limit_conn by_server 3;
            limit_rate 10k;
        }      
    }
```