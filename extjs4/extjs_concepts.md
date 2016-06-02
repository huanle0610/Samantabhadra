## Extjs4 基本概念

**手册是最好的老师**

### 手册此六个概念要熟悉
![六个概念](http://ww3.sinaimg.cn/mw690/62dabf66gw1f4h9pndhy1j207s07at9q.jpg)

1和2属于规范，3、4、5、6属于必备基础。

#### Component

所有页面上的UI控件都是Component.

Component 按能否容纳其他component，分为Container(能容) 和非Container(不能容) .

Container 是容器，其属性items即是其所容纳的子component.
常用container有：panel, grid, window, tabpanel, container, viewport;
常用非container有：button, box, textfield, combo, checkbox, radio...

而一个Container中有很多components时，这些components在容器内是怎样放置的问题就是布局(layout). 
布局一般是通过**容器**的属性layout来设置的。


#### Data

当UI和Data产生联系时，UI一般只和Store沟通就可以了。
![Data Package in ExtJS4](http://ww3.sinaimg.cn/mw690/62dabf66gw1f4ha5h4hc3j20il0fa758.jpg)


更清晰一点的图

![详解](http://ww3.sinaimg.cn/mw690/62dabf66gw1f4ha5owk4vj20fe0hfn00.jpg)


##### 哪些UI依赖Store?

![官方组件需要store支持的](http://ww2.sinaimg.cn/mw690/62dabf66gw1f4ha5vg8ptj20fe04r74o.jpg)


##### 数据处理的流程 

直接面向服务器端的是Proxy

![数据处理的流程](http://ww4.sinaimg.cn/mw690/62dabf66gw1f4ha608xglj20fe06at98.jpg)


下面举例：

* [简单的表单](http://runjs.cn/code/a0nf75qj){target=_blank}
* [GRID](http://runjs.cn/code/yjarahah){target=_blank}
* [GRID双击播放音频](http://runjs.cn/code/zo4sbeiv){target=_blank}




