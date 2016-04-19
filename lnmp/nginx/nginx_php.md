# 支持php

通常nginx用转发请求给FastCGI的形式，支持php.

下面的配置都应该包含在一个server block中; 

## 简单配置
加上下面的配置，就可以处理php的请求了。
```html
    location ~* \.php$ { 
        fastcgi_pass 127.0.0.1:9001; 
        include fastcgi.conf; 
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
```

> 注意：fastcgi_pass　后面究竟是什么IP,什么端口；唯你知晓。

## Codeigniter
足以支持Codeigniter的重写规则（或者通常需求的省略index.php）

```html
    # Check if a file or directory index file exists, else route it to index.php
    location / {
        try_files $uri $uri/ /index.php; 
    } 
    
    location ~* \.php$ { 
        fastcgi_pass 127.0.0.1:9001; 
        include fastcgi.conf; 
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
```

然而，你会遇到网站上缺了张图片，都会劳烦index.php去处理，显示CI的404。



加上下面配置，静态文件的请求就不会再发给php处理了。
```html
    # set expiration of assets to MAX for caching
    location ~* \.(ico|css|js|gif|jpe?g|png)(\?[0-9]+)?$ {
            log_not_found off;
    }
```


## 子目录中支持另一个application
```html
    location /curd/ {
        root E:/git/;
        try_files $uri $uri/ /curd/index.php; 

        location ~* \.(ico|css|js|gif|jpe?g|png)(\?[0-9]+)?$ {
                log_not_found off;
        }

        location ~* \.php$ { 
            fastcgi_pass 127.0.0.1:9001; 
            include fastcgi.conf; 
            fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
    }
```

## 文件上传

文件上传是一个复杂的问题

![上传文件流程](nginx_php_file_upload.puml)

只有上面五个动作都完美执行，才会上传成功。
最常见的错误有

- 413 Request Entity Too Large 
上传文件大小超过了nginx的配置, 第一步就出错了。

> client_max_body_size 可以解决。

```html
client_max_body_size 200M;
```
> [官方注解](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size)


- 504 Gateway Time-out
第二步出错， php未能在nginx规定的时间内返回内容。解决就是让nginx多等。

下面的配置应该在 location ~* \.php$ block, 五分钟超时。

```html
fastcgi_read_timeout 180;
```

> [官方注解](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_read_timeout)


- php处理文件失败
第三步出错，一般通过打印$_FILES可以看到失败代码。

```html
 var_dump($_FILES);
```

[文件错误码官方注解](http://php.net/manual/en/features.file-upload.errors.php)

[官方总结常见陷阱](http://php.net/manual/en/features.file-upload.common-pitfalls.php)

最常见的失败原因是，文件大小超过配置。

php.ini中有两处配置直接影响允许上传文件大小：

1. upload_max_filesize 限制了单个文件的大小

2. post_max_size 限制了一次请求(文件上传是post请求)允许的大小

```html
; Maximum allowed size for uploaded files.
; http://php.net/upload-max-filesize
upload_max_filesize = 200M

; Maximum size of POST data that PHP will accept.
; http://php.net/post-max-size
post_max_size = 800M
```

还有间接影响上传的参数：

memory_limit php脚本运行最大允许使用内存量

max_execution_time php脚本运行最长允许时间
