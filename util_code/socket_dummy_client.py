import sys
"""create dummy socket client"""
import socket
"""check size of sending data"""

IP_ADDRESS = '127.0.0.1'  # localhost
PORT = 5001

DATA_FRAME1 = [
    'AA00000AF00000FF', '000000DC0000000F',
    '0003000200010000', '0007000600050004',
    '0004000300020001', '0008000700060005',
    '0005000400030002', '0009000800070006',
    '0006000500040003', '000A000900080007',
    '0007000600050004', '000B000A00090008',
    '0000000000000155']
DATA_FRAME2 = [
    'AA000008CF000104', '000001400000000F',
    '0008000700060005', '000C000B000A0009',
    '0009000800070006', '000D000C000B000A',
    '000A000900080007', '000E000D000C000B',
    '000B000A00090008', '000F000E000D000C',
    '0000000000000155']

DATA_FRAME = ''.join([ele[::-1] for ele in DATA_FRAME1]) + \
    ''.join([ele[::-1] for ele in DATA_FRAME2])
DATA_FRAMES = ''

if __name__ == "__main__":

    while len(DATA_FRAMES)/2 < 10*1E6:
        DATA_FRAMES += DATA_FRAME

    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        DATA = bytes.fromhex(DATA_FRAMES)
        print("Connect server to :", IP_ADDRESS)
        s.connect((IP_ADDRESS, PORT))
        print("Send: {0:.2f} Mbytes".format(len(DATA)*1E-6))
        s.sendall(DATA)
