curl -G "http://$IP:8086/query?pretty=true" \
  --data-urlencode "q=SHOW DATABASES" \
  --header "Authorization: Bearer [REDACTED]"
