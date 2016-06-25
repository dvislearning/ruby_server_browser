require 'socket' 
require 'json'              # Get sockets from stdlib

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run forever
  client = server.accept       # Wait for a client to connect

  header =  client.gets.split(" ")
  command = header[0].upcase
  file = header[1]
  version = header[2]

  
  length = client.gets
  content = client.gets

   case command
   when 'GET'
     if File.exist?(file)
       client.puts "#{version} 200 OK\nDate: #{Time.now.ctime}\nContent-Type: text/html\nContent-Length: #{File.size(file)}\r\n\r\n\n"
       File.open(file, "r").each { |line| client.puts line }
     else
       client.puts "404 Not Found"
     end
  when 'POST'
    params = (JSON.parse(content))
    viking = params["viking"]
    individual_thanks = "<li>Name: #{viking["name"]}</li>\r\n<li>Email: #{viking["email"]}</li>"
    client.puts "POST #{file} #{version}\nFrom: #{viking["email"]}\nUser-Agent: HTTPTool/1.0\nContent-Type: application/x-www-form-urlencoded\nContent-Length: #{File.size(file)}\r\n\r\n\n"
    form = File.read(file)
    client.puts form.gsub("<%= yield %>",individual_thanks)
  else
    client.puts "This server cannot handle #{command} requests."
   end
  client.close                 # Disconnect from the client
}

