import socket



# Insert a HTTP request between the quotes below. Good Luck!
BODY = """
GET /0-welcome HTTP/1.1
""".lstrip()



with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect(('', 3500))
    s.send((BODY + '\n').encode("utf-8"))
    data = s.recv(1024)

print(data.decode("utf-8"))
