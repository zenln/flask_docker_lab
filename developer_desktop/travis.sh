#!/bin/bash
# Install travis cli

sudo apt-get -y install ruby ruby-dev
sudo gem install travis -v 1.8.8 --no-rdoc --no-ri
