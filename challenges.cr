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
    method:       "GET",
    key:          "headers",
    headers:      nil,
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