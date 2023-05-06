import socket



# Insert a HTTP request between the quotes below. Good Luck!
BODY = """
GET /5-common-headers HTTP/1.1
Hello:World
""".lstrip()



with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect(('8.tcp.ngrok.io', 15825))
    s.send((BODY + '\n').encode("utf-8"))
    data = s.recv(1024)

print(data.decode("utf-8"))
