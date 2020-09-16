# socket サーバを作成

import socket

# AF = IPv4 という意味
# TCP/IP の場合は、SOCK_STREAM を使う
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    # IPアドレスとポートを指定
    s.bind(('127.0.0.1', 5001))
    # 1 接続
    s.listen(1)
    # connection するまで待つ
    while True:
        # 誰かがアクセスしてきたら、コネクションとアドレスを入れる
        conn, addr = s.accept()
        with conn:
            df = "AAAA00526395F008FF4BFF54FF53FF4BFF49FF50FF52FF49FF4DFF53FF52FF49FF4DFF53FF53FF4AFF4CFF56FF53FF4CFF4CFF54FF54FF4CFF4DFF54FF54FF4CFF4FFF57FF57FF4E0000010000015555"
            data = bytes.fromhex(df)
            if not data:
                break
            print('data : {}, addr: {}'.format(data, addr))
            # クライアントにデータを返す(b -> byte でないといけない)
            conn.sendall(data)
        break