require "./parser.cr"
require "socket"
require "http/headers"

def handle_client(client)
  begin
    req_line = read_request_line(client)

    headers = HTTP::Headers.new
    while header_line = read_header_line(client)
      case header_line
      when EndOfRequest
        break
      else
        if !headers.add?(header_line.name, header_line.value)
          raise "Your header #{header_line.name} is invalid. You cannot have spaces in header names."
          break
        end
      end
    end

    challenge = get_challenge(req_line, headers)

    client.puts challenge[:instructions]
    client.close
  rescue e
    client.puts e.message
    client.close
  end
end

server = TCPServer.new(3500)
while client = server.accept?
  spawn handle_client(client)
end
