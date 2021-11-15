#!/bin/bash

# Test script to run in Docker container.
# E.g. `docker run -it ubuntu:rolling /bin/bash`

apt-get update && \
apt-get install -y neovim curl git ssh sudo && \
mkdir -p /root/.ssh && \
eval "$(ssh-agent)" && \
mkdir -p ~/Documents/projects && \
git clone https://github.com/nerdyman/react-compare-slider.git ~/Documents/projects/react-compare-slider && \
bash -c "$(curl -fsSL https://raw.github.com/nerdyman/dx-scripts/main/install.sh)"
