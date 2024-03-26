#!/usr/bin/env bash

website=$1
res=""
status_bad=(304 404 405 429 500 502 503)

read HTTP CODE MSG <<< "$(curl -I -s $website | awk '/^HTTP/{print $1, $2, $3}')"
curl_exit_status=$?

msg() {
  echo "$1 $HTTP $CODE $MSG"
  exit $2
}

searh_bad() {
  local st=$1
  for code in "${status_bad[@]}"; do
    if [ "$st" = "$code" ]; then    
      return 1
      break
    fi
  done
  return 0
}

is_ok() {
  local st=$1
  local code=$2
  if [ -z "$code" ]; then 
       msg "[-] FAIL" 1; 
  else searh_bad "$code"
    if [ $? -eq 0 ]; then
       msg "[+] OK" 0
    else msg "[-] FAIL" 1
    fi 
  fi
}

is_ok $curl_exit_status $CODE
