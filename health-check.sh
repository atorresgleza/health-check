#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <website_url> [bad_status_codes...]"
    exit 1
fi

timeout=5
max_time=10
website=$1

shift
status_codes_to_check=("${@:-304 404 405 429 500 502 503}")

response=$(curl -I -s --connect-timeout "$timeout" -m "$max_time" --fail "$website" | head -n 1)
curl_exit_status=$?

read -r HTTP CODE <<< "$(awk '/^HTTP/{print $1, $2}' <<< "$response")"
MSG="$(cut -d " " -f3- <<< "$response")"

msg() {
    local status_code="$1"
    local message="[+] OK $HTTP $status_code $MSG"
    local exit_code=0
    
    if [[ " ${status_codes_to_check[*]} " =~ ${status_code} || $curl_exit_status -ne 0 || -z "$status_code" ]]; then
        message="[-] FAIL $HTTP $status_code $MSG"; exit_code=1
    fi
    echo "$message" | xargs; exit $exit_code
}

msg "$CODE"
