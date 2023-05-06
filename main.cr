require "socket"
require "http/headers"

METHODS = %w(GET HEAD POST PUT DELETE CONNECT OPTIONS PATCH TRACE)

alias Challenge = NamedTuple(method: String, key: String, instructions: String, headers: Hash(String, String) | Nil)
CHALLENGES = [
  {
    method:       "GET",
    key:          "welcome",
    headers:      nil,
    instructions: "Welcome to the HTTP gauntlet! Send a GET request at /1-methods to get started.
Put this into the BODY variable to do exactly that.
GET /1-methods HTTP/1.1",
  },
  {
    method:  "GET",
    key:     "methods",
    headers: nil,

    instructions: "Methods are an important part of any request. It is the first part of any HTTP request.
There are #{METHODS.size} methods, being:
#{METHODS.join("\n")}
You'll be using GET requests most of the time, but we'll check out other requests later.
For now, send a GET request at /2-paths.
GET /2-paths HTTP/1.1",
  },
  {
    method:  "GET",
    key:     "paths",
    headers: nil,

    instructions: "The next part of the request header is the path. You've been using it in order to procced to the next challenge.
If you type something like https://cyberclasscamp.com/our-team into your URL bar the /our-team section would be our path.
Generally paths help websites differenciate between different resources on the server.
Next we'll cover the HTTP protocol. Send a GET request at the path /3-protocol",
  },
  {
    method:  "GET",
    key:     "protocol",
    headers: nil,

    instructions: "HTTP stands for Hypertext Transmission Protocol was developed by Tim Berners-Lee for sharing documents with each other.
He developed a markup language known as HTML to use with HTTP. The original version of HTTP, version 1.0, came out in 1996, with HTTP 1.1 coming out in 1997.
More recently there have been attempts to update HTTP with HTTP 2 in 2015 and HTTP 3 in 2022. Most of these version upgrades only helped with stability and speed, and not much has changed with the protocol itself.
Alright, we are going to get into the real meat of the HTTP protocol, headers and the body. Send a GET request at the path /4-headers",
  },
  {
    method:  "GET",
    key:     "headers",
    headers: nil,
    instructions: "Headers are in the format <headerName>:<headerValue>. They come right after the request header.
    Make a header with name of Hello and value of World (case sensitive.) at /5-common-headers. It'll look something like this.
    GET / HTTP/1.1
    Header-Name: Header-Value",
  },
  {
    method:  "GET",
    key:     "common-headers",
    headers: {
      "Hello" => "World",
    },
    instructions: "</gauntlet>",
  },
]

record EndOfRequest
record RequestLine, method : String, path : String
record HeaderLine, name : String, value : String, bytesize : Int32

# TODO switch to exceptions instead of returning error, could make control flow nicer.
def read_request_line(io) : RequestLine
  request_line = io.gets
  raise "This request looks empty. Are you sure you have anything typed into the string?" unless !request_line.empty?
  portions = request_line.split(' ')
  raise "Your request header does not have 3 arguments. Remember that a request header is <method> <path> <protocol>." unless portions.size == 3
  method, path, protocol = portions
  raise "#{method} does not seem to be a valid http method. Make sure that your method is ALL CAPS. All methods can be found here https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods" unless METHODS.includes?(method)
  raise "#{path} is an invalid path. Make sure that your path starts with a slash ( / )" unless path.starts_with?('/')
  raise "#{protocol} is not a valid http protocol accepted by this server, make sure your protocol is HTTP/1.0 or HTTP/1.1" unless protocol == "HTTP/1.0" || protocol == "HTTP/1.1"
  return RequestLine.new method: method, path: path
end

def get_challenge(req_line : RequestLine, headers : HTTP::Headers) : Challenge
  portions = req_line.path[1..].split("-", 2)
  raise "All paths in this gauntlet are formatted as /<id>-<key>, for example /0-welcome. 0 would be the id and welcome would be the key. Make sure that you typed the URL correctly" unless portions.size == 2
  id, key = portions
  begin
    challenge = CHALLENGES[id.to_i]
  rescue
    raise "All paths in this gauntlet are formatted as /<id>-<key>, for example /0-welcome. It seems that your id is not a number. Double check that your id is a number."
  end

  raise "All paths in this gauntlet are formatted as /<id>-<key>, for example /0-welcome. It seems that your key is incorrect. Make sure that you typed in the path correctly" unless challenge[:key] == key

  raise "Make sure your method is correct. the correct method to use is #{challenge[:method]} but you sent #{req_line.method}." unless challenge[:method] == req_line.method

  if chall_headers = challenge[:headers]
    chall_headers.each do |name, value|
      raise "Header #{name} does not exist" unless headers[name.downcase]?
      raise "Header #{name} with value #{headers[name.downcase]?} is wrong. (Expected a value of #{value})" unless headers[name.downcase]? == value
    end
  end
  return challenge
end

def read_header_line(io) : EndOfRequest | HeaderLine | Nil
  line = io.gets(16_384, chomp: true)
  return nil unless line
  if line.bytesize > 16_384
    return HeaderLine.new name: "", value: "", bytesize: 16_384
  end

  if line.empty?
    return EndOfRequest.new
  end

  name, value = line.split ":", 2 rescue raise "Headers are formatted <headerName>:<headerValue>. Make sure you have your colon."
  HeaderLine.new name: name.downcase, value: value.lstrip, bytesize: line.bytesize
end

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
