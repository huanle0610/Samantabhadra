# javascript的个性

## javascript 不允许在return关键字和表达式之间换行。
```html
return 12; // right

return 
12;    // wrong
```

## javascript 不允许在break关键字和表达式之间换行。

## 用||填充默认值
```html
b = false; a = b || 5;
// a现在等于5

function shortStr(str, len){
    len = len || 5;
    return str.substr(0, len);
}
shortStr('abcdefg');
shortStr('abcdefg', 2)
```


## 不等
```html
'' == '0' // false
false == undefined //false
false == null //false
null == undefined //true

if('0') {alert(23);} // 会弹
if(0) {alert(23);} // 不会弹
```


## 闭包
闭包实现
```html
var myObj = function(){
   // 私有化，外界无法直接改动。
    var value = 0;
    
    return {
        increment: function(inc){
            value += typeof inc === 'number' ? inc : 1;
        },
        getValue: function(){
            return value;
        }
    }
}();
// 注意上行的(), 上面的匿名函数定义之后马上就调用了。
// 返回一个对象，该对象有两个方法(increment、getValue)。

console.log(myObj.getValue()); // 0
myObj.increment(2);
console.log(myObj.getValue()); // 2
myObj.value = 56;
console.log(myObj.getValue()); // 2
```


## 简易模板
```html
function tpl(format){
    var arg = arguments;
    return format.replace(/\{(\d+)\}/g, function(m, i){
        return arg[parseInt(i) + 1];
    });
}

tpl("abc{0}, {1}ddd{0}", 3, 8);
// "abc3, 8ddd3"

function tplObj(format){
    var arg = arguments;
    return format.replace(/\{(\w+)\}/g, function(m, i){
        return arg[1][i];
    });
}

tplObj("abc {a}, {b} ddd {c}",  {a: 'OK', b: 'July', c: 'Ultra'});
//"abc OK, July ddd Ultra"
```