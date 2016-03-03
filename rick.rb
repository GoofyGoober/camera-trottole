require 'webrick'
require 'awesome_print'
server = WEBrick::HTTPServer.new :Port => 8080

class Simple < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response

    response.status = 200
    response['Content-Type'] = 'text/plain'
    response.body = 'Hello, World!'
  end
  def do_POST req, res
    filedata= req.body
    f = File.open("/Users/ale/test.jpg", "w")
    f.syswrite filedata
    f.close
    res.status = 200
    res['Content-Type'] = 'text/plain'
    res.body = 'ok'
  end
end

server.mount '/', Simple
server.start