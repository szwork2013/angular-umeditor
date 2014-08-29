module.exports = (grunt)->

  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)

  grunt.initConfig

    coffee:
      options:
        bare: false
      compile:
        files:
          '.tmp/angular-umeditor.js': 'angular-umeditor.coffee'

    copy:
      'lib':
        files: [
          {
            expand: true
            cwd: 'lib/plupload-2.1.2'
            src: ['**']
            dest: '.tmp/lib/plupload'
          }
          {
            expand: true
            cwd: 'lib/umeditor1_2_2-utf8'
            src: ['**']
            dest: '.tmp/lib/umeditor'
          }
          {
            expand: true
            cwd: 'lib/qiniu'
            src: ['**']
            dest: '.tmp/lib/qiniu'
          }
          {
            expand: true
            cwd: 'lib/jquery-ui'
            src: ['**']
            dest: '.tmp/lib/jquery-ui'
          }
        ]

      'plupload-images-to-umeditor':
        expand: true
        cwd: '.tmp/lib/plupload/jquery.ui.plupload/css/'
        src: ['*.css']
        dest: '.tmp/lib/umeditor/themes/default/css/'

      'plupload-css-to-umeditor':
        expand: true
        cwd: '.tmp/lib/plupload/jquery.ui.plupload/images/'
        src: ['*.*']
        dest: '.tmp/lib/umeditor/themes/default/images/'

      'build':
        files: [
          {
            name: 'images'
            expand: true
            cwd: '.tmp/lib/umeditor/themes/default/images/'
            src: ['**']
            dest: 'build/images/'
          }
          {
            name: 'dialogs'
            expand: true
            cwd: '.tmp/lib/umeditor/dialogs/'
            src: ['**/*']
            dest: 'build/dialogs/'
          }
          {
            name: 'ui-images'
            expand: true
            cwd: '.tmp/lib/jquery-ui/'
            src: ['**']
            dest: 'build'
          }
        ]

    concat:
      js:
        files: [
          {
            name: 'umeditor'
            src: ['.tmp/lib/umeditor/umeditor.config.js', '.tmp/lib/umeditor/umeditor.js', '.tmp/lib/umeditor/lang/zh-cn/zh-cn.js']
            dest: '.tmp/lib/umeditor/umeditor.full.js'
          }
          {
            name: 'plupload-js'
            src: ['.tmp/lib/plupload/plupload.full.min.js', '.tmp/lib/plupload/jquery.ui.plupload/jquery.ui.plupload.js', '.tmp/lib/plupload/i18n/zh_CN_Image.js']
            dest: '.tmp/lib/plupload/plupload-with-ui.full.js'
          }
          {
            name: 'umeditor-with-plupload-js-with-qiniu'
            src: ['.tmp/lib/qiniu/qiniu-simplify.js', '.tmp/lib/plupload/plupload-with-ui.full.js', '.tmp/lib/umeditor/umeditor.full.js']
            dest: '.tmp/dist/umeditor.dist.js'
          }
        ]

      css:
        files: [
          src: ['.tmp/lib/umeditor/themes/default/css/jquery.ui.plupload.css', '.tmp/lib/umeditor/themes/default/css/jquery-ui.css', '.tmp/lib/umeditor/themes/default/css/umeditor.css']
          dest: '.tmp/dist/umeditor.dist.css'
        ]

    uglify:
      compress:
        drop_console: true
      'build':
        files:[
          {
            src: '.tmp/dist/umeditor.dist.js'
            dest: 'build/umeditor.min.js'
          }
          {
            src: '.tmp/angular-umeditor.js'
            dest: 'build/angular-umeditor.min.js'
          }
        ]
      'ueditor-dialogs':
        files:[
          {
            expand: true
            cwd: 'build/dialogs'
            src: ['**/*.js']
            dest: 'build/dialogs/'
            ext: '.js'
          }
        ]

    cssmin:
      'build':
        files: [
          {
            src: '.tmp/dist/umeditor.dist.css'
            dest: 'build/umeditor.min.css'
          }
          {
            name: 'jquery-ui'
            src: '.tmp/lib/jquery-ui/jquery-ui.css'
            dest: 'build/jquery-ui.min.css'
          }
        ]

      'ueditor-dialogs':
        files:
          [
            {
              expand: true
              cwd: 'build/dialogs'
              src: ['**/*.css']
              dest: 'build/dialogs/'
              ext: '.css'
            }
          ]

    htmlmin:
      'options':
        removeComments: true
        collapseWhitespace: true
        keepClosingSlash: true
        caseSensitive: true
        minifyJS: true
        minifyCSS: true
      'dialog':
        files: [
          {
            expand: true
            cwd: 'build/dialogs'
            src: ['**/*.html']
            dest: 'build/dialogs/'
            ext: '.html'
          }
        ]
    clean:
      'tmp':
        src: '.tmp'
      'build':
        src: 'build'

  # 将百度 umeditor 中的，css 种的 url 位置做 offset
  grunt.registerTask 'css-replace-url', ()->
    done = this.async()
    fs = require('fs')
    cssContent = fs.readFileSync('.tmp/dist/umeditor.dist.css', 'utf8')
    newCssContent = cssContent.replace(/\.\.\/images/gm, 'images')
    fs.writeFileSync('.tmp/dist/umeditor.dist.css', newCssContent)
    done()
  # 给编译的 umeditor.min.js 加 闭包，防止 意外变量污染
  grunt.registerTask 'js-add-closures', ()->
    done = this.async()
    fs = require('fs')
    jsContent = fs.readFileSync('.tmp/dist/umeditor.dist.js', 'utf-8')
    newJsContent = ';(function(){\r\n' + jsContent + '})();';
    fs.writeFileSync('.tmp/dist/umeditor.dist.js', newJsContent)
    done()

  grunt.registerTask 'compile', ['clean:tmp', 'copy', 'concat', 'css-replace-url', 'js-add-closures']

  grunt.registerTask 'build', ['clean:build', 'compile', 'uglify', 'cssmin', 'htmlmin', 'clean:tmp']

  grunt.registerTask 'default', ['copy:lib', 'coffee:compile']