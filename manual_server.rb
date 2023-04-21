require "socket"

def parse_request(request_line)
  http_method, path_and_params, http_version = request_line.split

  path, params = path_and_params.split('?')
  params = (params || '').split('&').each_with_object({}) do |pair_string, hash|
    param, val = pair_string.split('=')
    hash[param] = val
  end

  [http_method, path, params, http_version]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  next unless request_line
  next if !request_line || request_line =~ /favicon/
  puts request_line

  http_method, path, params, http_version = parse_request(request_line)

  client.puts "#{http_version} 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"

  number = params['number'].to_i

  client.puts "<p>The current number is #{number}.</p>"

  # old code for dice rolling using params in url:
  # if params
  #   client.puts "<h1>Rolls!</h1>"

  #   rolls = params['rolls'].to_i
  #   sides = params['sides'].to_i
  #   rolls.times do
  #     roll = rand(1..sides)
  #     client.puts "<p>", roll, "</p>"
  #   end
  # else
  #   puts "Pass me some info using the url, how many rolls and sides?"
  # end

  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"
  client.puts "</body>"
  client.puts "</html>"
  client.close
end
