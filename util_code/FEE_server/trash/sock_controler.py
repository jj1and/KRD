import sys
import socket

IP_ADDRESS = '192.168.1.7'
PORT = 5002

if __name__ == "__main__":
    cmd = ""
    res = ""

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        print("INFO: Connect server to :", IP_ADDRESS)
        s.connect((IP_ADDRESS, PORT))

        while(1):
            res = s.recv(2048)
            print(res.decode())
            cmd = input("INFO: input cmd: ")
            s.send(cmd.encode('utf-8'))
            if cmd == "quit":
                break
