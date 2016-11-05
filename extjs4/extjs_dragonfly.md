## Dragonfly
Dragonfly 是一个使用Codeigniter3 + Extjs4 组合进行RIA(Rich Internet Application)开发的范例项目。

Catch it from Github: [Dragonfly](https://github.com/huanle0610/dragonfly)

请提前阅读

* Codeigniter的手册（至少[CodeIgniter Overview部分](http://docs.php-admin.com/codeigniter3/overview/index.html){target=_blank}）
* Extjs4 Guide （至少[Concepts部分](http://docs.php-admin.com/extjs4/docs/index.html#!/guide/application_architecture){target=_blank}）

### 目录结构

```html
vagrant@precise64:/vagrant_data/dragonfly$ tree -L 1 -F
.
|-- app/              # 前台 js代码
|-- app.js            # 前台 Ext application 定义于此文件中
|-- application/      # 后台 Codeigniter 应用
|-- index.php         # 后台 the front controller of Codeigniter（一般不需要修改） 
|-- readme.md
|-- resources/        # 资源文件 css/image...
|-- extjs4/               # extjs4类库（一般不需要修改）
`-- ci/           # the core of Codeigniter（一般不需要修改）
```
app目录和application目录是我们前后台代码所安放之处。


### Extjs Direct
请首先熟悉[Mapping a Grid to a MySQL table using Direct and PHP](http://docs.php-admin.com/extjs4/docs/index.html#!/guide/direct_grid_pt1){target=_blank}

简言之，Ext Direct *大大简化* 了从浏览器调用后台方法的操作流程，使前后台代码调用更符合直觉。

后台目录结构：

```html
vagrant@precise64:/vagrant_data/dragonfly$ tree -F  application/ext/
application/ext/
`-- direct/
    |-- Actor.php
    |-- Database.php
    |-- Echo.php
    |-- Exception.php
    |-- ExtProfile.php
    |-- File.php
    |-- Kaleidoscope.php
    |-- Navigation.php
    |-- Profile.php
    |-- Rbac.php
    |-- TestAction.php      # 下面以此为例(store proxy)
    `-- Time.php            # 下面以此为例(直接调用)
```

Time.php

```php
class Time
{
	/**
	 * @remotable
	 */
	public function get()
	{
		return date('m-d-Y H:i:s');
	}
}
```

此时，在Chrome Console中执行
```html
Time.get(function(r){console.log('得到了后台的时间：', r);})
```
![direct 输出演示1](http://ww2.sinaimg.cn/mw690/62dabf66gw1f4g5pv4ytij20df02cweq.jpg)

对上面的代码需要注意的是，一般的代码注释没有实际作用。但是，这里不一样。

**如果方法没有 @remotable 的签名，是不会被发布到前台供js调用的**。

具体规则可参考：[codeigniter-ext-direct readme](https://github.com/huanle0610/codeigniter-ext-direct/tree/master){target=_blank} 就可以了.

在js里用到direct的方法, 分两种 store的proxy和直接调用; 上面的Time.get就是直接调用.

#### 在定义Store时,使用direct方法

后台 TestAction.php

```php
class TestAction
{
	/**
	 * Get Grid data
	 * @remotable
	 * @access public
	 */
	function getGrid($params)
	{
		return array(
			'items' => array(
				array('name' => 'a', 'id' => 9),
				array('name' => 'm', 'id' => 10),
				array('name' => 't', 'id' => 1),
				array('name' => 'f', 'id' => 2)
			),
			'totalCount' => 4
		);
	}
}
```

JS

```html
var logStore = Ext.create('Ext.data.Store', {
    autoLoad: true,
    fields: [
        'id', 'name'
    ],
    proxy: {
        type: 'direct',
        directFn: 'TestAction.getGrid',
        reader: {
            type: 'json',
            root: 'items',
            totalProperty: 'totalCount'
        }
    }
});
```

![direct store proxy应用](http://ww1.sinaimg.cn/mw690/62dabf66gw1f4g6wgy5d6j20dw08a755.jpg)

NOTE：

* 如果对Direct API启用了缓存的话，添加新类或方法需要清除一下缓存。

#### 后台Direct API的增加流程

1. 增加php类 application/ext/NewClass.php, 及添加方法（注意添加相应注释签名）

2. 在 application/controllers/Direct.php 的route方法添加类名，即NewClass.(根据Dragonfly版本不同，此步略有差异)

3. 清理 application/cache 中direct 相关缓存。

版本差异：

* V1.0 之前版本， 需要1、2、3 共三步；
* V1.1 版本， 需要1、3 共两步；
* V1.2 版本， 需要1、2、3 共两步；
    