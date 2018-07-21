```bash
npm set registry https://registry.npm.taobao.org # 注册模块镜像
npm set disturl https://npm.taobao.org/dist # node-gyp 编译依赖的 node 源码镜像

## 以下选择添加
npm set sass_binary_site https://npm.taobao.org/mirrors/node-sass # node-sass 二进制包镜像
npm set electron_mirror https://npm.taobao.org/mirrors/electron/ # electron 二进制包镜像
npm set puppeteer_download_host https://npm.taobao.org/mirrors # puppeteer 二进制包镜像
npm set chromedriver_cdnurl https://npm.taobao.org/mirrors/chromedriver # chromedriver 二进制包镜像
npm set operadriver_cdnurl https://npm.taobao.org/mirrors/operadriver # operadriver 二进制包镜像
npm set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs # phantomjs 二进制包镜像
npm set selenium_cdnurl https://npm.taobao.org/mirrors/selenium # selenium 二进制包镜像
npm set node_inspector_cdnurl https://npm.taobao.org/mirrors/node-inspector # node-inspector 二进制包镜像

npm cache clean --force # 清空缓存
```

```bash
[amtf@amtf-s3 xx-net]$ npm search vue
npm WARN search fast search endpoint errored. Using old search.
npm WARN Failed to read search cache. Rebuilding
npm WARN Building the local index for the first time, please be patient
npm ERR! No search sources available

npm ERR! A complete log of this run can be found in:
npm ERR!     /home/amtf/.npm/_logs/2018-07-21T09_49_45_202Z-debug.log
[amtf@amtf-s3 xx-net]$ npm search --registry=http://registry.npmjs.org/ vue
NAME                      | DESCRIPTION          | AUTHOR          | DATE       | VERSION  | KEYWORDS          
vue-router                | Official router for… | =yyx990803      | 2017-10-13 | 3.0.1    | vue router routing
vue-resource              | The HTTP client for… | =steffans…      | 2018-05-20 | 1.5.1    | vue xhr http ajax
```

```bash
echo "alias npm-search='npm search --registry=http://registry.npmjs.org/'" >> ~/.bashrc
source ~/.bashrc
[amtf@amtf-s3 xx-net]$ echo "alias npm-search='npm search --registry=http://registry.npmjs.org/'" >> ~/.bashrc
[amtf@amtf-s3 xx-net]$ source ~/.bashrc
[amtf@amtf-s3 xx-net]$ npm-search vue
NAME                      | DESCRIPTION          | AUTHOR          | DATE       | VERSION  | KEYWORDS          
vue-router                | Official router for… | =yyx990803      | 2017-10-13 | 3.0.1    | vue router routing
```