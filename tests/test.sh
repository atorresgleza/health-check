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

