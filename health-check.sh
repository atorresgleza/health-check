#!/bin/bash

website=$1
ok=0
res=""
status=(304 404 405 429 500 502 503)

read HTTP CODE MSG <<< "$(curl -I -s $website | awk '/^HTTP/{print $1, $2, $3}')"

is_ok() {
  if [ "$ok" -eq 0 ]; then 
    echo "[+] OK -> $HTTP $CODE $MSG" 
    else echo "[-] FAIL -> $HTTP $CODE $MSG" 
  fi
  exit $ok
}

for code in "${status[@]}"; do
  if [ "$CODE" = "$code" ]; then    
    ok=1
    is_ok
    break
  fi
done

if [ "$ok" -eq 0 ]; then
  res=$CODE
  is_ok
fi
