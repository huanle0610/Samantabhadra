## 常用单词

总有一些单词，常用到又忘了怎么拼写。欢迎回复加入你认为的易忘词汇。

<table>
    <tr>
        <td>单词</td>
        <td width=90>含义</td>
        <td>用途</td>
    </tr>   
     <tr>
        <td>width</td>
        <td>宽度</td>
        <td></td>
    </tr>
    <tr>
         <td>height</td>
         <td>高度</td>
         <td></td>
     </tr>
     <tr>
          <td>container</td>
          <td>器件</td>
          <td></td>
      </tr>
      <tr>
        <td>property</td>
        <td>属性</td>
        <td></td>
    </tr>
    <tr>
        <td>stretch</td>
        <td>属性</td>
        <td>child items are stretched vertically/horizontally to fill the height of the container.</td>
    </tr>
    <tr>
        <td>collapsible</td>
        <td>可收缩性</td>
        <td>Set to true to make the component collapsible and have the expand/collapse toggle button automatically rendered into the legend element, false to keep the fieldset statically sized with no collapse button. </td>
    </tr>
     <tr>
        <td>collapsed</td>
        <td>收缩的</td>
        <td>Set to true to render the component as collapsed by default. </td>
    </tr>  
    <tr>
        <td>maximize</td>
        <td>使最大化</td>
        <td>Fits the window within its current container and automatically replaces the 'maximize' tool button with the 'restore' tool button. </td>
    </tr>    
    <tr>
        <td>remoteFilter</td>
        <td>远程过滤</td>
        <td>true to defer any filtering operation to the server. If false, filtering is done locally on the client. </td>
    </tr>     
    <tr>
        <td>remoteSort</td>
        <td>远程排序</td>
        <td>True to defer any sorting operation to the server. If false, sorting is done locally on the client. </td>
    </tr> 
    <tr>
        <td>listeners</td>
        <td>监听者</td>
        <td>A config object containing one or more event handlers to be added to this object during initialization. </td>
    </tr>    
    <tr>
        <td>sorters</td>
        <td>对store添加排序规则。sorter: Represents a single sorter that can be applied to a Store. </td>
        <td>
        The initial set of Sorters.
<pre>
        sorters: [{
                 property: 'age',
                 direction: 'DESC'
             }, {
                 property: 'firstName',
                 direction: 'ASC'
             }]
</pre>
              </td>
    </tr>   
    <tr>
        <td>filters</td>
        <td>对store添加过滤条件。Array of Filters for this store. Can also be passed array of functions which will be used as the filterFn config for filters. </td>
        <td>
        Eg:
<pre>
        filters: [
                    {
                        property: 'level',
                        value: '1'
                    },
                    {
                        property: 'project',
                        value: '100'
                    }
        ]
</pre>
              </td>
    </tr>
</table>