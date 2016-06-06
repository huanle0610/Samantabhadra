## Extjs4 Code snippet

欢迎回复补充

## 超时时间

### Ajax超时设置
Default options for all requests can be set by changing a property on the Ext.Ajax class:

Ext.Ajax.timeout = 60000; // 60 seconds
Any options specified in the request method for the Ajax request will override any defaults set on the Ext.Ajax class. In the code sample below, the timeout for the request will be 60 seconds.

```html
Ext.Ajax.timeout = 120000; // 120 seconds
Ext.Ajax.request({
    url: 'page.aspx',
    timeout: 60000
});
```


### direct超时设置

```html
Ext.app.REMOTING_API.timeout = 100000;

Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
```


## 允许GRID复制文字

```html
viewConfig: {
    enableTextSelection: true
},
```


## 动态加载css

```html
Ext.util.CSS.swapStyleSheet('role_css', 'resources/css/role.css');
```