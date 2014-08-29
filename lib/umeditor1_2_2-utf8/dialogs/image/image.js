(function () {
    var UPLOADED_IMAGE_LIST = []; // 已将上传完成的图片
    var gen_image_url = function(image_key){
      return UMEDITOR_CONFIG.upload.domain + '/' + image_key;
    };
    var gen_image_key = function(file){
      return 'media/images/dongzone_web/' + (file.id + Date.now()) + '.' + file.type.replace('image/', '');
    };
    UM.registerWidget('image', {
        tpl: '<div id="_uploader_076g5dy">\n' +
            '<p>对不起，您的浏览器没有支持Flash, Silverlight, HTML5中的任何一种多媒体技术.</p>\n' +
            '</div>\n' +
            '',
        initContent: function (editor, $dialog) {
            var lang = editor.getLang('image')["static"],
                opt = $.extend({}, lang, {
                    image_url: UMEDITOR_CONFIG.UMEDITOR_HOME_URL + 'dialogs/image/'
                });
            if (lang) {
                var html = $.parseTmpl(this.tpl, opt);
            }
            currentDialog = $dialog.edui();
            this.root().html(html);
        },
        initEvent: function (editor, $w) {
            var prepend_in = '__prepend_96h01jf'
              , footer = $w.find('.edui-modal-footer')
              , ok_btn = $w.find('.edui-modal-footer .edui-btn-primary')
              , _ok_btn;
            ok_btn.hide();
            // 如果搜索到 按钮 没有插入过
            if ( $w.find('#' + prepend_in).length === 0 ) {
                _ok_btn = $('<div class="edui-btn" id="'+ prepend_in +'">确定</div>').css({'background-color': '#ccc'});
                footer.prepend(_ok_btn);
            }
            _ok_btn = $w.find('#' + prepend_in).show();
            Qiniu.uploader({
              wapper: '#_uploader_076g5dy',
              // upload runtimes
              runtimes: 'html5,flash,silverlight,html4',
              // 文件上传，下载 服务器 配置
              uptoken_url: UMEDITOR_CONFIG.upload.utoken_url,
              domain: UMEDITOR_CONFIG.upload.domain,
              unique_names: false,
              save_key: false,
              // 最大上传文件大小
              max_file_size: '10mb',
              // User can upload no more then 20 files in one go (sets multiple_queues to false)
              max_file_count: 20,
              max_retries: 3,                //上传失败最大重试次数
              dragdrop: true,                //开启可拖曳上传
              //drop_element: 'form',        //拖曳上传区域元素的ID，拖曳文件或文件夹后可触发上传
              chunk_size: '1mb',
              //auto_start: true,            //选择文件后自动上传，若关闭需要自己绑定事件触发上传
              // Resize images on clientside if we can
              resize : {
                width: 500,
                height: 800,
                quality: 90,
                crop: false // crop to exact dimensions
              },
              // Specify what files to browse for
              filters: [
                { title: "图像", extensions: "jpg,gif,png" }
              ],
              // Rename files by clicking on their titles
              rename: true,
              // Sort files
              sortable: true,
              // Enable ability to drag'n'drop files onto the widget (currently only HTML5 supports that)
              dragdrop: true,
              // Views to activate
              views: {
                list: true,
                thumbs: true, // Show thumbs
                active: 'thumbs'
              },
              // Flash settings
              flash_swf_url : 'lib/plupload-2.1.2/Moxie.swf',
              // Silverlight settings
              silverlight_xap_url : 'lib/plupload-2.1.2/Moxie.xap',
              init: {
                      'UploadComplete': function(up, files){
                          ok_btn.show();
                          _ok_btn.hide();
                      },
                      'FileUploaded': function(up, file, info_str) {
                          var infoObj;
                          try {
                            infoObj = JSON.parse(info_str);
                          } catch (e) {
                            alert('远程服务器返回结果不正确: Error -> ' + e.message);
                          }
                          var src = gen_image_url(infoObj.key);
                          UPLOADED_IMAGE_LIST.push({ _src: src, src: src });
                      },
                      'Key': function(up, file) {
                          // 该配置必须要在 unique_names: false , save_key: false 时才生效
                          var key = gen_image_key(file);
                          return key;
                      }
                  }
            }, function(opt){
              var $uploader = $(opt.wapper).plupload(opt);
              return $uploader.plupload('getUploader');
            });
        },
        buttons: {
            'ok': {
                exec: function (editor, $w) {
                    editor.execCommand('insertimage', UPLOADED_IMAGE_LIST);
                }
            },
            'cancel': {}
        },
        width: 700,
        height: 320
    });
})();
