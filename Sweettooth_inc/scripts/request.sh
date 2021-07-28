curl -G "http://$IP:8086/query?db=demodb" \
  -X POST \
  --data-urlencode "q=CREATE USER todd WITH PASSWORD '123456' WITH ALL PRIVILEGES"\
  --header "Authorization: Bearer [REDACTED]"
