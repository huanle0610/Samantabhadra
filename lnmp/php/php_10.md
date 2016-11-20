# php十日谈

## php 001 特性扫描

### 数据类型
![数据类型](php_data_type.puml)

### 变量
变量的正则表达式 [a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*

```php
<?php

$我是变量 = "是真的";

echo $我是变量; 

echo "\n";


//可变变量
$ab = "fruit";
$$ab = "apples";

echo 'I like eatting ', $fruit, ".";
echo "\n";
echo 'Do you like eatting ', "${$ab}?";

echo "\n";
```

OUTPUT:
```html
# php php01.php
是真的
I like eatting apples.
Do you like eatting apples?
```

是的 $$ab和$fruit等价。

### 引用赋值

```php
<?php
$a = 1;
$b = 2;

function changeVal($v1, &$v2)
{
    $v1 = 100;
    $v2 = 200;
}


echo sprintf("a = %d; b = %d;\n", $a, $b);
changeVal($a, $b);
echo sprintf("a = %d; b = %d;\n", $a, $b);
```
OUTOUT
```html
# php php02.php
a = 1; b = 2;
a = 1; b = 200;
```
对应C语言里，就是传值与传址的那段论述。

### 定界符 Heredoc-specified strings 
定界符内的引号不用转义，变量会被解析。
```php
<?php
$a = "linux";
$b = 'windows';

$c = "linux in a nutshell, \"Did you read it?\"";
$d = '\'A new book\', "Do you like it?"';

$e = <<<DJF
    Network File System (NFS) is a distributed file system protocol originally developed by Sun Microsystems in 1984;
$c
   "It's ok" '
"anywh'ere"'
$a $b
DJF;

echo $e, "\n";
```
OUTPUT:
```html
# php php03.php
    Network File System (NFS) is a distributed file system protocol originally developed by Sun Microsystems in 1984;
linux in a nutshell, "Did you read it?" 
   "It's ok" '
"anywh'ere"'
linux windows
```
[参考](http://php.net/manual/en/language.types.string.php#language.types.string.syntax.heredoc)


### 练习

#### 写一段代码解析出，linux常用命令。
<iframe style="width: 100%; height: 300px" src="http://runjs.cn/code/ayeebu6l" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

```php
...
function parseCmdFromTable($table_html)
{
    
}
//最后两句代码及结果
$cmd_list = parseCmdFromTable($table_html);
echo $cmd_list;
// cat, cd, chmod..._
```
#### 写一段代码解析出，常用php 字符串操作函数。
<iframe style="width: 100%; height: 300px" src="http://runjs.cn/code/ltlakbfb" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

```php
...
function parseCmdFromHtml($html)
{
    
}
//最后两句代码及结果
$function_list = parseCmdFromTable($my__html);
echo $function_list;
// substr, strlen,...
```
### 上题中的函数，按函数名字母顺序排序。
### 同上，按函数名长短排序
### 同上，函数名最长是多少位？最短是多少位？分别是哪些？
### 已知一个多级菜单的SQL，和前端工程师给出的静态模板，请用php代码（从数据库中获取数据）实现该多级菜单？
<iframe style="width: 100%; height: 300px" src="http://runjs.cn/code/wry9xqj1" allowfullscreen="allowfullscreen" frameborder="0"></iframe>




## php 002 调试
### 全能的var_dump 

```html
<?php
$a = "linux";

$b = 1;
$c = array('good', 'more' => array(1, 2), false, null, 'm' => new stdClass());


var_dump($a, $b, $c);


//追踪debug_backtrace
//如果在一个函数内想知道调用堆栈，可以用debug_backtrace
function b()
{
    var_dump(debug_backtrace());
}

fu
b();
```

### 打开错误显示
有时候是服务器配置是不显示错误只记录到日志，可以动态打开错误显示开关。

```php
// 显示所有错误
error_reporting(E_ALL);
ini_set('display_errors', 1);
```