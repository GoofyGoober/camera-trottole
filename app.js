
var WebSocketServer = require('ws').Server
var http = require('http');
var server = http.createServer(function(request, response) {
  console.log((new Date()) + ' Received request for ' + request.url);
  response.writeHead(200, {'Content-Type': 'text/plain'});
  response.write("Welcome to Node.js on OpenShift!\n\n");
  response.end("Thanks for visiting us! \n");
});
server.listen( 8080, "192.168.0.5", function() {
  console.log((new Date()) + ' Server is listening on port 8080');
});
wss = new WebSocketServer({
  server: server
  //autoAcceptConnections: false
});
wss.on('connection', function(ws) {
  console.log("New connection");
  ws.on('message', function(message) {
    ws.send("hai ragione'")
  });
});
console.log("Listening to " + "192.168.0.5" + ":" + 8080 + "...");