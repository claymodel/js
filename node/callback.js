var dns = require('dns')
  , http = require('http')
  , fs = require('fs');

/*
 The callback function is usually the last argument 
 provided in an I/O operation. Here, dnsCallback is
 a function that'll get triggered once dns.lookup
 has been completed.
*/
dns.lookup('google.com', dnsCallback); 

/*
 Callback functions typically contain two arguments at a minimum;
 The first is used to output any errors that occured.
 If the operation completed successfully, the second argument will
 contain the result of the operation, while the first (error) argument
 will be left undefined or null.
*/
function dnsCallback(error, ipAddress) {
  if (error) console.error('An error occured: '+ error);

  console.log('google.com resolved to %s', ipAddress);
}

// Starting an HTTP server and serving up an html file on the file system.
http.createServer(function (req, res) {

  /*
   fs.readFile contains an inline callback function.
   It's contents will get executed when triggered.
   The arguments work the same as the dnsCallback
   function above.
  */
  fs.readFile('./index.html', function(err, html) {
    if (err) console.log('Error occured: '+ err);
    
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
    res.end(html);
  });

}).listen(80);

