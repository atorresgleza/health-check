#!/bin/bash

function set_up() {
  ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."
  SCRIPT="$ROOT_DIR/health-check.sh"
  MURL="http://example.com"
}