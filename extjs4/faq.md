# Ext JS4 FAQ

## HOW
### 使grid的文字可复制？
```html
viewConfig: {
    enableTextSelection: true
}
```

### window 标题不会移出窗口？
```html
Ext.override(Ext.Window, {
    constrainHeader: true
});
```

### grid前景色、背景色
```html
css:
.blue .x-grid-cell-inner {background-color: blue; color: #FFF;}

js:
viewConfig: {
				getRowClass: function(record, index) {
					var name = record.get('name'); // 可以根据数据变化类名
					return  'blue';
				}
},
```
[Example](http://runjs.cn/detail/yjarahah)

### 调整ajax请求timeout阀值
```html
	Ext.Ajax.timeout = 86400000;
	Ext.app.REMOTING_API.timeout = 100000;
```


### [combo分层级](http://runjs.cn/detail/rcmc4qms)
