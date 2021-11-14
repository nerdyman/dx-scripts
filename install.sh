#!/bin/sh

# shellcheck disable=SC1091,SC2164

echo "[install]"

_TEMP_DIR=$(mktemp -d)
curl https://github.com/nerdyman/dx-scripts/archive/refs/heads/main.tar.gz | tar xz -C "$_TEMP_DIR"
cd "$_TEMP_DIR"

if test "$(grep -e ID=ubuntu /etc/os-release)"; then
  echo "[install] => Ubuntu detected"
  source ./ubuntu.sh
else
  echo "[install] => Distro does not have a preset script, using agnostic set up"
  source ./agnostic.sh
fi

echo "[install] Done"
