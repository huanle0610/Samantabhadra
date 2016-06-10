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

## 限制窗口移到无法移动处

```
Ext.override(Ext.Window, {
    constrainHeader: true
});
```

## 扩展filter传递条件

```html
// ext store remote filter missing operator fix
Ext.override(Ext.data.proxy.Server, { encodeFilters: function(filters) {
    var min = [],
        length = filters.length,
        i = 0;

    for (; i < length; i+=1) {
        if(filters[i].property && filters[i].value){
            min[i] = {
                operator: filters[i].operator,
                property: filters[i].property,
                value   : filters[i].value
            };
        }
    }
    return this.applyEncoding(min);
}});
```


## 执行远端返回的脚本

```html
var globalEval = function( data ) {
    if ( data && Ext.String.trim( data ) ) {
        // We use execScript on Internet Explorer
        // We use an anonymous function so that context is window
        ( window.execScript || function( data ) {
            window[ "eval" ].call( window, data );
        } )( data );
    }
};
```

## 动态添加toolbar

```html
panel.addDocked({ ... });
```


## 插件的启用与禁用

```html
    // Drag & Drop
    if (features.copy || features.move_rename) {
        this.getDirtree().getView().getPlugin('dragdrop').enable();
        this.getFilelist().getView().getPlugin('dragdrop').enable();
    } else {
        this.getDirtree().getView().getPlugin('dragdrop').disable();
        this.getFilelist().getView().getPlugin('dragdrop').disable();
    }
```


## grid刷新后保持所选条目

1. grid store use model

2. model set idProperty

3. then Extjs4 will keep the selections after refresh


## 扩展颜色选择域

[Example](http://runjs.cn/code/sglofcih)


## state

```html
    if(Ext.supports.LocalStorage){
        Ext.state.Manager.setProvider(new Ext.state.LocalStorageProvider());
    }else{
        Ext.state.Manager.setProvider(new Ext.state.CookieProvider({
            expires: (new Date(new Date().getTime() + (86400*100)))
        }));
    }
```

## combo分等级

[combo rank](http://runjs.cn/code/rcmc4qms)
