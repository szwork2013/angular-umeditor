var express = require('express');
var qiniu = require('qiniu');

qiniu.conf.ACCESS_KEY = '<%= ACCESS_KEY %>';
qiniu.conf.SECRET_KEY = '<%= SECRET_KEY %>';

var app = express();

app.use(express.static(__dirname));

app.get('/uptoken', function(req, res){
  var uptoken = new qiniu.rs.PutPolicy('dongzone-test1');
  res.json({uptoken: uptoken.token()});
});

app.listen(8000);
