require 'em-websocket'
require 'faker'

EM.run {
  EM::WebSocket.run(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen do |handshake|
      puts "WebSocket connection open"
      puts "origin: #{handshake.origin}"
      puts "headers: #{handshake.headers}"

      ws.send "Hello Client, you connected to #{handshake.path}"
    end

    ws.onerror do |error|
      puts "[error] #{error}"
    end

    ws.onclose do 
      puts "Connection closed" 
    end

    ws.onbinary do |msg|
      IO.write("/Users/ale/test.jpg", msg)
    end

    ws.onmessage do |msg|
      puts "message from client: #{msg}"
      ws.send Faker::Hacker.say_something_smart
    end
  end
}
