#!/bin/bash

function set_up() {
  ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."
  SCRIPT="$ROOT_DIR/health-check.sh"
  MURL="http://example.com"
}

function testOKWebsiteResponds() {
    mock curl echo "HTTP/1.1 200 OK"
    assert_equals "[+] OK HTTP/1.1 200 OK" "$( $SCRIPT "$MURL" )"
}

function testFailWebsiteResponds404() {
    mock curl echo "HTTP/1.1 404 Not Found"
    assert_equals "[-] FAIL HTTP/1.1 404 Not Found" "$( $SCRIPT "$MURL" )"
}

function testFailNewStatusCodeList401() {
    mock curl echo "HTTP/1.1 401 Unauthorized"
    assert_equals "[-] FAIL HTTP/1.1 401 Unauthorized" "$( $SCRIPT "$MURL" 304 401 404 405 429 500 502 503 )"
}

function testOKNewStatusCodeList404() {
    mock curl echo "HTTP/1.1 404 Not Found"
    assert_equals "[+] OK HTTP/1.1 404 Not Found" "$( $SCRIPT "$MURL" 304 405 429 500 502 503 )"
}

function testFailURLNotExist() {
    mock curl echo ""
    assert_equals "[-] FAIL" "$( $SCRIPT "$MURL" )"
}

function testFailURLEmpty() {
    assert_equals "Usage: $SCRIPT <website_url> [bad_status_codes...]" "$( $SCRIPT )"
}