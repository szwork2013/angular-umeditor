baidu umeditor for angularjs
============================
> 百度 umeditor 富文本编辑器 angularjs 插件

> * 将图片上传功能调整为 plupload 上传组件(并且该功能组件使用了简化过的 (qiniu javascript sdk->`lib/qiniu/qiniu-simplify.js`) 封装，可以直接将图片上传至七牛云存储, 只需要简单的配置)
> * 将视频插入功能修改为，插入一个 iframe 标签。(目前只支持youku，没有做其他视频网站处理)

# build
`$ grunt build`
    build
        ├─dialogs
        │  ├─emotion
        │  │  └─images
        │  ├─formula
        │  │  └─images
        │  ├─image
        │  │  └─images
        │  ├─image.back
        │  │  └─images
        │  ├─link
        │  ├─map
        │  ├─video
        │  │  └─images
        │  └─video.back
        │  └─images
        └─images
        ├─jquery-ui.min.css
        ├─jquery-ui.min.js
        ├─umeditor.min.css
        ├─umeditor.min.js
        ├─angular-umeditor.min.js
#install
`requirejs`
    wrapper angular-umeditor.coffee 1: `#define ['angular'], (angular)->` open
`scriptsrc`
    <link rel="stylesheet" href="build/umeditor.min.css" />
    <link rel="stylesheet" href="build/jquery-ui.min.css" />
    <script src="build/jquery-ui.min.js"></script>
    <script src="build/umeditor.min.css"></script>
    
> `angular.module('myApp', ['ng-umeditor'])`
> `<textarea ng-umeditor style="width: 600px; height: 200px;"></textarea>`

[1]: http://www.yin-blog.cn
Author: [@yinchangsheng][1]

#other
> 如果想 继续使用 百度 umeditor 提供的 image,video 功能的话，可以 dialogs 中的 `.back` 还原