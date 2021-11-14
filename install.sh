#!/bin/bash -e

# shellcheck disable=SC1091,SC2164

export __HAS_PREINSTALL_SCRIPT__=true

echo "[install]"

_temp_dir=$(mktemp -d)
curl -SL https://github.com/nerdyman/dx-scripts/archive/refs/heads/main.tar.gz | tar xz -C "$_temp_dir"

echo "[install] => Using temporary directory $_temp_dir"

pushd "$_temp_dir/dx-scripts-main"

if test "$(grep -e ID=ubuntu /etc/os-release)"; then
  echo "[install] => Ubuntu detected"
  source ./ubuntu.sh
else
  echo "[install] => Distro does not have a preset script, using agnostic set up"
  source ./agnostic.sh
fi

popd

rm -r "$_temp_dir"

echo "[install] Done"
