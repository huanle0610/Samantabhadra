## Extjs4 Components

**手册是最好的老师**

Extjs 4  application's UI 是由components组成的.
所有Extjs4的Component都是继承自Ext.Component.

## 重要的开箱即用的component：

<table class="table table-striped table-bordered table-condensed"> <thead>
<tr>
<th>Component Name</th>
<th>Class Name</th>
<th class="hidden-xs">xtype</th>
</tr>
</thead>
<tbody>
<tr>
<td>TextField</td>
<td><a href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.Text" class="sub_link" target="_blank">Ext.form.field.Text</a></td>
<td class="hidden-xs">textfield</td>
</tr>
<tr>
<td>Label</td>
<td><a href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.Label" class="sub_link" target="_blank">Ext.form.Label</a> </td>
<td class="hidden-xs">label</td>
</tr>
<tr>
<td>Button</td>
<td><a href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.button.Button" class="sub_link" target="_blank">Ext.button.Button</a></td>
<td class="hidden-xs">button</td>
</tr>
<tr>
<td>DateField</td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.Date" target="_blank">Ext.form.field.Date</a>
</td>
<td class="hidden-xs">datefield</td>
</tr>
<tr>
<td>ComboBox</td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.ComboBox" target="_blank">Ext.form.field.ComboBox</a>
</td>
<td class="hidden-xs">combobox or combo</td>
</tr>
<tr>
<td>Radio Button</td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.Radio" target="_blank">Ext.form.field.Radio</a>
</td>
<td class="hidden-xs">radio or radiofield</td>
</tr>
<tr>
<td>Checkbox</td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.Checkbox" target="_blank">Ext.form.field.Checkbox</a>
</td>
<td class="hidden-xs">checkbox or checkboxfield</td>
</tr>
<tr>
<td>File Upload</td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.File" target="_blank">Ext.form.field.File</a>
</td>
<td class="hidden-xs">filefield, fileuploadfield</td>
</tr>
<tr>
<td>Hidden Field</td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.Hidden" target="_blank">Ext.form.field.Hidden</a>
</td>
<td class="hidden-xs">hidden</td>
</tr>
<tr>
<td>Number Field</td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.Number" target="_blank">Ext.form.field.Number</a>
</td>
<td class="hidden-xs">numberfield</td>
</tr>
<tr>
<td>Spinner</td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.Spinner" target="_blank">Ext.form.field.Spinner</a>
</td>
<td class="hidden-xs">spinnerfield</td>
</tr>
<tr>
<td>Text Area</td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.TextArea" target="_blank">Ext.form.field.TextArea</a>
</td>
<td class="hidden-xs">textarea</td>
</tr>
<tr>
<td>Time Field </td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.Time" target="_blank">Ext.form.field.Time</a>
</td>
<td class="hidden-xs">timefield</td>
</tr>
<tr>
<td>Trigger</td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.Trigger" target="_blank">Ext.form.field.Trigger</a>
</td>
<td class="hidden-xs">triggerfield, trigger</td>
</tr>
<tr>
<td>Chart </td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.chart.Chart" target="_blank">Ext.chart.Chart</a>
</td>
<td class="hidden-xs">chart</td>
</tr>
<tr>
<td>Html Editor</td>
<td>
<a class="sub_link" href="http://docs.php-admin.com/extjs4/docs/index.html#!/api/Ext.form.field.HtmlEditor" target="_blank">Ext.form.field.HtmlEditor</a>
</td>
<td class="hidden-xs">htmleditor</td>
</tr>
</tbody>
</table>


## Ext JS 4 Containers:
container是特殊的component, 即能包含其他component.
均继承自Ext.container.Container

<table class="table table-striped table-bordered table-condensed">
<thead>
<tr>
<th>Class Name</th>
<th class="hidden-xs">xtype</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.1/#!/api/Ext.container.Viewport" target="_blank">Ext.container.Viewport</a>
</td>
<td class="hidden-xs">viewport</td>
<td>ViewPort is a specialized container representing the viewable application area (the browser viewport). Generally there is a single ViewPort in an Ext JS application which will define the application's main areas like north, west, south, east and center.</td>
</tr>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.1/#!/api/Ext.container.Container" target="_blank">container</a>
</td>
<td class="hidden-xs">container</td>
<td>Container is lightweight container which provides basic functionality of containing items, namely adding, inserting and removing items. So use this container when you just want to add other components and arrange them.</td>
</tr>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.1/#!/api/Ext.panel.Panel" target="_blank">Ext.panel.Panel</a>
</td>
<td class="hidden-xs">panel</td>
<td>Panel is a special type of container that has specific functionality and components. Each panel has header, tool, body, toolbar components. So use Panel when you want specific user interface with header, toolbar and body part. Do not use it if you do not want these features in panel, use container instead.</td>
</tr>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.1/#!/api/Ext.form.Panel" target="_blank">Ext.form.Panel</a>
</td>
<td class="hidden-xs">form</td>
<td>Ext.form.Panel provides standard containers for form. Use it when you want standard application form kind of user interface.</td>
</tr>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.1/#!/api/Ext.form.FieldContainer" target="_blank">Ext.form.FieldContainer</a>
</td>
<td class="hidden-xs">fieldcontainer</td>
<td>FieldContainer implements labelable mixins so that it can be rendered with label and error message around every sub-item component. You can use fieldcontainer in the form to arrange inner fields.</td>
</tr>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.2/#!/api/Ext.form.FieldSet" target="_blank">Ext.form.FieldSet</a>
</td>
<td class="hidden-xs">fieldset</td>
<td>Fieldset is a container for group of fields in a Ext.form.Panel.</td>
</tr>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.1/#!/api/Ext.grid.Panel" target="_blank">Ext.grid.Panel</a>
</td>
<td class="hidden-xs">grid</td>
<td>Grid displays large amount of tabular data with sorting, filtering and other functionality.</td>
</tr>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.1/#!/api/Ext.container.ButtonGroup" target="_blank">Ext.container.ButtonGroup</a>
</td>
<td class="hidden-xs">buttongroup</td>
<td>ButtonGroup provides a container for arranging a group of related Buttons in a tabular manner.</td>
</tr>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.1/#!/api/Ext.tab.Panel" target="_blank">Ext.tab.Panel</a>
</td>
<td class="hidden-xs">tabpanel</td>
<td>Ext.tab.Panel is a basic tab container. Use it when you want tab or wizard in your user interface.</td>
</tr>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.1/#!/api/Ext.tree.Panel" target="_blank">Ext.tree.Panel</a>
</td>
<td class="hidden-xs">treepanel</td>
<td>TreePanel provides tree-structured UI representation of tree-structured data.</td>
</tr>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.2/#!/api/Ext.menu.Menu" target="_blank">Ext.menu.Menu</a>
</td>
<td class="hidden-xs">menu</td>
<td>Menu is a container to which you can add Menu Items.</td>
</tr>
<tr>
<td>
<a class="sub_link" href="http://docs.sencha.com/extjs/4.2.2/#!/api/Ext.toolbar.Toolbar" target="_blank">Ext.toolbar.Toolbar</a>
</td>
<td class="hidden-xs">toolbar</td>
<td>Toolbar is a container for toolbar buttons, text, fill, item etc.</td>
</tr>
</tbody>
</table>

## 常用布局 layout

- border
- hbox 
- vbox 
- card 
- fit 




下面举例：

* [简单的表单](http://runjs.cn/code/a0nf75qj){target=_blank}
* [GRID](http://runjs.cn/code/yjarahah){target=_blank}
* [GRID双击播放音频](http://runjs.cn/code/zo4sbeiv){target=_blank}




