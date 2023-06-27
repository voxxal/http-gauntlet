CHALLENGES = [
  {
    method:  "GET",
    key:     "welcome",
    headers: nil,
    body:    nil,

    instructions: "HTTP/1.1 200 OK

Welcome to the HTTP gauntlet!
HTTP is a protocol for transmitting hypermedia documents. It was designed for communication between web browsers and web servers. HTTP follows a classical client-server model, with a client opening a connection to make a request, then waiting until it receives a response.
If you have ever visited a website, your browser sends a HTTP request to the server under the hood. We'll cover how the client request the web server first, then move onto how the server responds to the request.

Your job here is to put your request in the REQUEST variable in order to access the next challenge.

To get started, we'll cover the request header, which is always the first line in an HTTP request, which contains information about which resources is request.
The format of the request header is <method> <path> <version>.
For example, GET /1-methods HTTP/1.1
GET is the method, /1-methods is the path, and HTTP/1.1 is the version
Put that into the REQUEST variable to do exactly that.",
  },
  {
    method:  "GET",
    key:     "methods",
    headers: nil,
    body:    nil,

    instructions: "HTTP/1.1 200 OK

Methods are an important part of any request. It is the first part of any HTTP request.
There are #{METHODS.size} methods, being:
#{METHODS.join(", ")}
You'll be using GET requests most of the time, but we'll check out other requests later.
For now, send a GET request at /2-paths. Use a request like this.
GET /2-paths HTTP/1.1",
  },
  {
    method:  "GET",
    key:     "paths",
    headers: nil,
    body:    nil,

    instructions: "HTTP/1.1 200 OK

The next part of the request header is the path. You've been using it in order to procced to the next challenge.
If you type something like https://cyberclasscamp.com/our-team into your URL bar the /our-team section would be our path.
Generally paths help websites differenciate between different resources on the server.
Next we'll cover the HTTP version part of the request header. Send a GET request at the path /3-protocol",
  },
  {
    method:  "GET",
    key:     "protocol",
    headers: nil,
    body:    nil,

    instructions: "HTTP/1.1 200 OK

HTTP stands for Hypertext Transmission Protocol was developed by Tim Berners-Lee for sharing documents with each other.
He developed a markup language known as HTML to use with HTTP. The original version of HTTP, version 1.0, came out in 1996, with HTTP 1.1 coming out in 1997.
More recently there have been attempts to update HTTP with HTTP 2 in 2015 and HTTP 3 in 2022. Most of these version upgrades only helped with stability and speed, and not much has changed with the protocol itself.
Alright, we are going to get into the real meat of the HTTP protocol, headers and the body. Send a GET request at the path /4-request-headers",
  },
  {
    method:  "GET",
    key:     "request-headers",
    headers: nil,
    body:    nil,

    instructions: "HTTP/1.1 200 OK

Headers are in the format <headerName>:<headerValue>. They come right after the request header.
They generally convey information about what the request is doing.
Make a header with name of Hello and value of World (case sensitive.) at /5-common-request-headers. It'll look something like this.
GET / HTTP/1.1
Header-Name: Header-Value",
  },
  {
    method:  "GET",
    key:     "common-request-headers",
    headers: {
      "Hello" => "World",
    },
    body: nil,

    instructions: "HTTP/1.1 200 OK

There are a lot of common headers for HTTP requests.
Host: specifies the domain of the server it is communicating with
Examples: google.com, apple.com

Referer: tells the server where the requested URL came from.
Examples: If you clicked a link on Google, whatever link you clicked on will have a referer header that will come from Google
  Referer: https://www.google.com/search?hl=en&q=youtube

User-Agent: tells the server what application sent the request
Examples: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36
This contains information about which operating system and browser the user is using.

Cookie: some data that the server set and wants you to repeat.
Examples: hello=world;key=value
The cookie header is always in the form <key>=<value> and semicolons to seperate them.
Cookies are often used to store data between visits, such as authuntication.

There are a LOT more headers, along with custom headers that start with X-, but if you want to see them all check out this website
https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers

For now, I want you to set a header called Name with the value being your name. This will help me figure out who you are so I can award points :)
Add this to every single request for the rest of the activity.
Now send a GET request to /6-request-body",
  },
  {
    method:  "GET",
    key:     "request-body",
    headers: nil,
    body:    nil,

    instructions: "HTTP/1.1 200 OK

After the Headers in a request comes the body. You need to put an empty line to seperate the headers and the body.
While you can include a body in any type of request, you should not include them in GET requests.
An example if I wanted to login to verycoolwebsite.com, my browser would send the following request to their server
POST /login HTTP/1.1
Content-Type: application/x-www-form-urlencoded
Content-Length: 49

username=aiden&password=correcthorsebatterystaple

Notice the method is POST, Content-Type, and Content-Length headers.
Content-Type is what type the body is. The body could be an image (image/png, image/gif, etc), it could be plain text (text/plain), or other formats (application/json)
Content-Length is how long the body is. in this case the entire body is 49 characters long.
PLEASE make sure that your body length is greater than Content-Length. Due to the way the server works, if Content-Length is longer than the body length, the server will do nothing. If this happens, press Ctrl+C to stop the process then try again.
Both Content-Type and Content-Length are required.

Send a POST request at /7-request-end with a *plain text body* of \"Hello Body\". Make sure to include Content-Type and Content-Length",
  },
  {
    method:  "POST",
    key:     "request-end",
    headers: {
      "Content-Type" => "text/plain",
    },
    body: "Hello Body",

    instructions: "HTTP/1.1 200 OK

Congrats! You got through how requests are formatted! You have earned your team 10 points.
Wait for everyone else to finish, and after that we'll cover how servers respond.",
  },
]
#
