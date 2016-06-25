require 'socket'
require 'json'
 
host = 'localhost'     # The web server
port = 2000                           # Default HTTP port
post_path = "thanks.html"                 # The file we want 
get_path = "hello.html"

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
  request = "#{method} #{post_path} HTTP/1.0\nContent_length: #{content.length}\n#{content}\n"
else
  request = "#{method} #{get_path} HTTP/1.0\n\n\n"
end

# This is the HTTP request we send to fetch a file


socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
response = socket.read              # Read complete response
# Split response at first blank line into headers and body
headers,body = response.split("\r\n\r\n", 2) 
puts headers
puts body                          # And display it
