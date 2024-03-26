#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <website_url> [bad_status_codes...]"
    exit 1
fi

timeout=5
max_time=10
website=$1
res=""
status_bad=(304 404 405 429 500 502 503)

shift
status_codes_to_check=("${@:-304 404 405 429 500 502 503}")

response=$(curl -I -s --connect-timeout "$timeout" -m "$max_time" --fail "$website" | head -n 1)
curl_exit_status=$?

read -r HTTP CODE <<< "$(awk '/^HTTP/{print $1, $2}' <<< "$response")"
MSG="$(cut -d " " -f3- <<< "$response")"

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
