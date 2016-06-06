## 选择器

Extjs的视图是由非常多的component (eg: grid/panel/view/form/combo/textarea...)组成，

开发者经常需要操作一个component让其动作(eg: show/hide/load data/change data)

必须用到选择器，才能找到要操作的对象。

### 三个属性

#### id

不推荐

像html一样，extjs的component也可以设置id属性。
然后就可以通过Ext.getCmp方法得到这个component。

id的局限性就是必须 **全局唯一**。

#### itemId

推荐

获取一个component引用的较佳方法（较 id）,
**同一个container中必须唯一**


#### xtype
每个组件都是一个类，其类名较长

eg: 表格的 类名是 Ext.grid.GridPanel, xtype 为 grid.

通过xtype也可以查找component.


### 两个方法

#### Ext.ComponentQuery.query

[Ext.ComponentQuery-手册](http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.ComponentQuery){target=_blank}

核心查找类，被很多extjs构架方法内部调用。
所以，许多方法的传参都是依照方法的参数规则（敬请详阅上面链接的手册）。

#### Ext.getCmp

根据component的id获取component的引用。


下面举例：

* [选择器举例](http://runjs.cn/code/qqvg8gwk){target=_blank}

