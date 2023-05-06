require "./challenges.cr"
require "socket"
require "http/headers"


METHODS = %w(GET HEAD POST PUT DELETE CONNECT OPTIONS PATCH TRACE)

record EndOfRequest
record RequestLine, method : String, path : String
record HeaderLine, name : String, value : String, bytesize : Int32
alias Challenge = NamedTuple(method: String, key: String, instructions: String, headers: Hash(String, String) | Nil)

def read_request_line(io) : RequestLine
  request_line = io.gets
  raise "This request looks empty. Are you sure you have anything typed into BODY?" unless request_line
  raise "This request looks empty. Are you sure you have anything typed into BODY?" unless !request_line.empty?
  portions = request_line.split(' ')
  raise "Your request header does not have 3 arguments. Remember that a request header is <method> <path> <protocol>." unless portions.size == 3
  method, path, protocol = portions
  raise "#{method} does not seem to be a valid http method. Make sure that your method is ALL CAPS. All methods can be found here https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods" unless METHODS.includes?(method)
  raise "#{path} is an invalid path. Make sure that your path starts with a slash ( / )" unless path.starts_with?('/')
  raise "#{protocol} is not a valid http protocol accepted by this server, make sure your protocol is HTTP/1.0 or HTTP/1.1" unless protocol == "HTTP/1.0" || protocol == "HTTP/1.1"
  return RequestLine.new method: method, path: path
end

def get_challenge(req_line : RequestLine, headers : HTTP::Headers) : Challenge
  portions = req_line.path[1..].split('-')
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