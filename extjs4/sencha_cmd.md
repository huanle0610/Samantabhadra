## Work with Sencha Cmd(Extjs6)

### Get Extjs6 and Sencha Cmd

[Get Extjs latest download link](https://www.sencha.com/legal/gpl/)

[Sencha Cmd](https://www.sencha.com/products/extjs/cmd-download/)


### Quick Start

```html
E:\eapp>sencha -sd E:\phpwork\ext6.0.0  generate  workspace jl
Sencha Cmd v6.0.2.14
[INF] Copying framework to E:\eapp\jl\ext

E:\eapp>cd jl

E:\eapp\jl>sencha -sd ext generate app Myapp amtf
Sencha Cmd v6.0.2.14
[INF] Processing Build Descriptor : classic
[INF] Using GPL Version of Ext JS version 6.0.0.640 from E:\eapp\jl\ext.
[INF] The implications of using GPL version can be found here (http://www.sencha
.com/products/extjs/licensing).
[INF] Starting server on port : 1841
..
..
[INF] Building ..\..\..\build\temp\development\Myapp\sass\Myapp-all.scss
[INF] Application available at http://localhost:1841
[INF] Appending content to E:\eapp\jl\amtf\bootstrap.js
[INF] Writing content to E:\eapp\jl\amtf\modern.json
[INF] Adding application to workspace.json

E:\eapp\jl>ls
amtf  build  ext  packages  workspace.json

E:\eapp\jl>sencha web start
Sencha Cmd v6.0.2.14
[INF] Starting server on port : 1841
[INF] Mapping http://localhost:1841/ to ....

```

Visit this link:   http://localhost:1841/amtf/


### How To Use Fashion

```html
E:\eapp\jl\amtf>sencha app watch
Sencha Cmd v6.0.2.14


```


Visit this link: http://localhost:1841/amtf/?platformTags=fashion:true

Now If you change any scss file, the web page will refresh automatically.


### Run multiple projects simultaneously

Just use different port to start web server

```html
E:\eapp\jl> sencha web -port 1818 start
```


### Work with Nginx

```html
server {
    listen 80;
    server_name www.extjs6-app.cc;
    root   E:/eapp/jl;
    index  index.php index.html index.htm;
    location ~* \.(css|js)(\?[0-9]+)?$ {
        proxy_pass http://localhost:1841; 
    }
    
    location ~* /~(sass|cmd)/ {
        proxy_pass http://localhost:1841; 
    }
}
```


---
Links:

* [Fashion](http://docs.sencha.com/cmd/guides/fashion.html)
* [Sencha Cmd](http://docs.sencha.com/cmd/guides/intro_to_cmd.html)