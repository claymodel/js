var fs = require('fs') // the file system module
  , http = require('http');

// create the http server
http.createServer(function (req, res) {

  //read the 'index.html' file stored in the same directory
  // so we can serve it up
  res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
  fs.createReadStream('./index.html').pipe(res);

}).listen(80);
