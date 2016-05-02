# Function

## 拦截函数

```html
var sendCmd = function(data) { 
    //发送指令到服务器端
    Lamp.sendCmp(data, function(r){
        console.log(r);
        }
    )};

var checkData = function(data){
    return data.length === 4;
};

var sendCmdFinal = Ext.Function.createInterceptor(sendCmd, checkData);

sendCmdFinal([1, 6, 5, 4]);
sendCmdFinal([1, 6, 5, 4, 9]);
```

## JSONP
```html
var store = Ext.create('Ext.data.Store', {
    fields: ["mts", "province", "catName", "telString", "areaVid", "ispVid", "carrier"],
    proxy: {
        type: 'jsonp',
        url : 'https://tcc.taobao.com/cc/json/mobile_tel_segment.htm?tel=15850781443'
    }
});

store.load(function(){console.log(store.first().get('carrier'));});
```


## 捕获事件

全部事件
```html
    Ext.util.Observable.prototype.fireEvent = Ext.Function.createInterceptor(Ext.util.Observable.prototype.fireEvent, function () {
        console.log(this.name);
        console.log(arguments);
        return true;
    });
```


某个Object(component/store/...)上的事件
```html
    Ext.util.Observable.capture(Ext.getCmp('svgbox-1065'), function(evname) {
        console.log(evname, arguments);
    });
```

释放
```html
Ext.util.Observable.releaseCapture(Ext.getCmp('svgbox-1065'));
```

