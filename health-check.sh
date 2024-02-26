#!/bin/bash

website=$1
ok=0
status=(304 404 405 429 500 502 503)

is_ok() {
  exit ok
}

for code in "${status[@]}"; do
  if [ "$(curl -I -s $website | awk '/^HTTP/{print $2}')" = $code ]; then    
    ok=1 
    is_ok
    break
  fi
done

if [ "$ok" -eq 0 ]; then
  is_ok
fi