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

前后台

```html
 Ext.data.JsonP.request({
    url : 'http://www.dragonfly.cc/lab/getJsonP?callback=yes&', 
    callback: function(suc, res){
        console.log(res.a, res.b);
    }
});
```

```html
<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Lab extends CI_Controller {

	public function getJsonP()
	{
		$callback = $this->input->get('callback');

		// Create the output object.
		$output = array('a' => 'Apple', 'b' => 'Banana');

		//start output
		if ($callback) {
			header('Content-Type: text/javascript');
			echo $callback . '(' . json_encode($output) . ');';
		} else {
			header('Content-Type: application/x-json');
			echo json_encode($output);
		}
	}
}
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

