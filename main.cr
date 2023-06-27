require "./parser.cr"
require "socket"
require "http/headers"
require "http/content"

def handle_client(client)
  begin
    req_line = read_request_line(client)

    headers = HTTP::Headers.new
    body = nil
    while header_line = read_header_line(client)
      case header_line
      when EndOfRequest
        length_headers = headers.get? "content-length"
        break unless length_headers
        body = HTTP::FixedLengthContent.new(client, length_headers[0].to_u64).gets_to_end
        puts()
        break
      else
        if !headers.add?(header_line.name, header_line.value)
          raise "Your header #{header_line.name} is invalid."
          break
        end
      end
    end

    challenge = get_challenge(req_line, headers, body)

    case challenge[:key]
    when "request-end"
      puts "#{headers["name"]} finished requests portion!"
    end

    client.puts challenge[:instructions]
    client.close
  rescue e
    client.puts "HTTP/1.1 400 Bad Request\n\n#{e.message}"
    client.close
  end
end

server = TCPServer.new(3500)
while client = server.accept?
  spawn handle_client(client)
end
