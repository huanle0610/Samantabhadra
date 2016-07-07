## 超时时间

extjs的超时，发生在向后台获取数据过程中。

![many types timeout](http://ww3.sinaimg.cn/mw690/62dabf66gw1f4w6jeyomvj20620ckdha.jpg)

### Ajax超时设置

Default options for all requests can be set by changing a property on the Ext.Ajax class:

只所以可以直接改个属性就能影响后面所有的请求，是因为 Ext.Ajax是使用的单例模式(singleton).

Ext.Ajax.timeout = 60000; // 60 seconds
Any options specified in the request method for the Ajax request will override any defaults set on the Ext.Ajax class. In the code sample below, the timeout for the request will be 60 seconds.

```html
Ext.Ajax.timeout = 120000; // 120 seconds
Ext.Ajax.request({
    url: 'page.aspx',
    timeout: 60000
});
```


而对真正常用的store/form等，却不是用的单例，而是继承。需要单独覆盖或者对具体实例加timeout属性值(比如form是有timeout属性的, store的话就是给proxy加)。

One way to override all the ajax related timeouts, including store loads and form submits.
  
```html
Ext.Ajax.timeout= 60000; // 60 seconds
Ext.override(Ext.form.Basic, { timeout: Ext.Ajax.timeout / 1000 });
Ext.override(Ext.data.proxy.Server, { timeout: Ext.Ajax.timeout });
Ext.override(Ext.data.Connection, { timeout: Ext.Ajax.timeout });
```

上面第三句Ext.data.proxy.Server 因为"ServerProxy is a superclass of JsonPProxy and AjaxProxy.

### direct超时设置

```html
Ext.app.REMOTING_API.timeout = 100000;

Ext.direct.Manager.addProvider(Ext.app.REMOTING_API);
```