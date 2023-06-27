import socket
import signal
import sys




# Insert a HTTP request between the quotes below. Good Luck!
REQUEST = """
GET /0-welcome HTTP/1.1
""".lstrip()




with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect(('', 3500))
    if any(map(lambda x: not x, REQUEST.splitlines())):
        s.sendall((REQUEST).encode("utf-8"))
    else:
        s.sendall((REQUEST + '\n').encode("utf-8"))
    data = s.recv(10000)

print(data.decode("utf-8"))


