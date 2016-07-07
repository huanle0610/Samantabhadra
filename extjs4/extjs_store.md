# Store

Store是许多重型Extjs4组件(grid/combo/chart/view...)的数据支柱。

数据过滤、分组、排序、分页等许多操作只需要简单配置即可完成。

加载和保存数据的动作由Proxy完成

![数据处理的流程](http://ww4.sinaimg.cn/mw690/62dabf66gw1f4ha608xglj20fe06at98.jpg)

proxy的5种不同实现(3种服务器端 + 2种客户端)

![Store Proxy](http://ww1.sinaimg.cn/mw1024/62dabf66gw1f4ls71bdhzj20fe078t9s.jpg)

其中前两种为最常用到的，在Dragonfly中则广泛使用第二种Direct的proxy.


## Model 

从store的定义(The Store class encapsulates a client side cache of Model objects. )

可知store是在客户端对模型集合的缓存。

模型可以是显式(explicit)定义的一个模型，也可以是含蓄(implicit)声明的模型。

* 显式

```html
 Ext.define('User', {
     extend: 'Ext.data.Model',
     fields: [
         {name: 'firstName', type: 'string'},
         {name: 'lastName',  type: 'string'},
         {name: 'age',       type: 'int'},
         {name: 'eyeColor',  type: 'string'}
     ]
 });

 var myStore = Ext.create('Ext.data.Store', {
     model: 'User',
     proxy: {
         type: 'ajax',
         url: '/users.json',
         reader: {
             type: 'json',
             root: 'users'
         }
     },
     autoLoad: true
 });
```

* 含蓄
```html
 var myStore = Ext.create('Ext.data.Store', {
     fields: [
              {name: 'firstName', type: 'string'},
              {name: 'lastName',  type: 'string'},
              {name: 'age',       type: 'int'},
              {name: 'eyeColor',  type: 'string'}
          ],
     proxy: {
         type: 'ajax',
         url: '/users.json',
         reader: {
             type: 'json',
             root: 'users'
         }
     },
     autoLoad: true
 });
```

**对用fields含蓄创建模型的方式建议用于2、3个字段的简单store上，否则明显的定义Model较好**
.

## 数据过滤

数据过滤可以在前台或后台完成， 通过后台完成时 需要设置store的 remoteFilter: true .

后台处理时， 一般都是根据前台的条件映射到组装出来查询SQL语句。

### 传递过滤条件到后台

常用以下两种形式

- filter

[/api/Ext.data.Store-method-addFilter](http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.data.Store-method-addFilter)

配置添加filter

```html
var userStore = Ext.create('Ext.data.DirectStore', {
    autoLoad: true,
    directFn: 'Users.userList',
    pageSize: 1000,
    root: 'items',
    totalProperty: 'totalCount',
    fields: ['realname', 'username', 'user_id_'],
    filters: [
        {
            property: 'sex',
            value: 'male'
        }
    ]
});
```


动态添加filter

```html
filter = [];
if (!Ext.isEmpty(v.keywords)) {
    if (v.type == 1) {
        filter.push({
            property: 'subject',
            value: v.keywords
        });
    } else {
        filter.push({
            property: 'content',
            value: v.keywords
        });
    }
}
searchStore.addFilter(filter); //添加后会自动触发store加载数据， 详见手册
```

后台处理

```html
    /**
     * table list for curd
     * @remotable
     */
    function getList($params)
    {
        if(isset($params->filter))
        {
            foreach($params->filter as $filter)
            {
                var_dump($filter); // 前台传递的filter
            }
        }
        //根据条件过滤
     
        return array(
            'msg' => '记得返回数据给前台'
        );
    }
```


- extraParams

[/api/Ext.data.proxy.Server-cfg-extraParams](http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.data.proxy.Server-cfg-extraParams)

配置项

```html
var store = Ext.create('Ext.data.TreeStore', {
    root: {
        expanded: true
    },
    proxy: {
        type: 'direct',
        directFn: 'Users.sysMenuList',
        extraParams: {   //在配置时，传递参数到后台
            cat: 'UAC'
        }
    }
});
```

动态修改参数

```html
var st = grid.getStore();
Ext.apply(st.getProxy().extraParams, {
	cat: cmp.checked //覆盖参数后，需要手动加载store
});
st.reload();
```

后台处理

```html
    /**
     * table list for curd
     * @remotable
     */
    function getList($params)
    {
        var_dump($params->cat); //前台传递的参数
        //根据条件过滤
     
        return array(
            'msg' => '记得返回数据给前台'
        );
    }
```

## 前台操作

### 创建新记录 Create Blank

```html
var store = Downq('grid').getStore();
var Node = store.model;
for(var i=0; i< 30; i++){
   var tmp = new Node({'nid' : parseInt(Math.random() * 1000), 'update_time': Ext.Date.format(new Date(), 'Y-m-d H:i:s')});
   store.insert(store.getCount(), tmp);
}
```

### 拷贝记录 Copy OLD


```html
store.first()
j {raw: Object, modified: Object, data: Object, hasListeners: l, events: Object…}
store.first().$className
"Ext.data.Store.ImplicitModel-ext-gen3319"

var store = Downq('grid').getStore();
var record= store.first();
for(var i=0; i< 30; i++){
   var rec = record.copy(); // clone the record
   Ext.data.Model.id(rec); // automatically generate a unique sequential id
   store.insert(store.getCount(), rec );
}
```


### 过滤 FILTER

```html
var store = Downq('grid').getStore();
store.remoteFilter=false;
store.clearFilter();
store.filter('USR_USERNAME', /^fun/);

store.filter('USR_ROLE', 'user');
store.filter('USR_USERNAME', /^a/);

EQUAL
store.filter([{property: 'USR_USERNAME', value: /^a/}, {property: 'USR_ROLE', value: 'user'}]);

```


### 过滤回调 FILTER BY

```html
store.filterBy(function(record, id) {
   var due = record.get('USR_DUE_DATE');
   if( due >= '2015-09-02' &&   due <= '2015-09-09') {
       return true;
   }
   return false;
});
```


### 排序 SORT

```html
var store = Downq('grid').getStore();
store.remoteSort=false;
store.sort('USR_USERNAME', 'desc');
```
