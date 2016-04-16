require 'socket'
require 'json'
 
host = 'localhost'     # The web server
port = 2000                           # Default HTTP port
path = "thanks.html"                 # The file we want 


puts "Which method would you like to use?"
method = gets.chomp.upcase

content_length = nil
content = nil
request = nil
if method == 'POST'
  content = {:viking => {}}
  puts "Please Enter Viking Name"
  name = gets.chomp
  puts "Please Enter Viking Email"
  email = gets.chomp
  content[:viking] = {:name => name, :email => email}
  content = content.to_json
  request = "#{method} #{path} HTTP/1.0" + "\r\n" + "Content_length: #{content.length}" + "\r\n\r\n" + "#{content}" + "\r\n" + "END"  
else
  request = "#{method} #{path} HTTP/1.0" + "END"
end

# This is the HTTP request we send to fetch a file


socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
response = socket.read              # Read complete response
# Split response at first blank line into headers and body
headers,body = response.split("\r\n\r\n", 2) 
puts headers
puts body                          # And display it
