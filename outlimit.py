import time
t = time.time()
while True:
    try:
        j = input()
        t2 = time.time()
        if t2 - t > 1:
            print(j)
            t = t2
    except EOFError:
        break