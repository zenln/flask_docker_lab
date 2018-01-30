#!/bin/bash

# Customizes the operating environment for cloudshift labs
# Assumes lubuntu desktop is installed

# this is how we captured the configurations for our desktop
# tar zcvf css.profile.tgz Downloads .config .mozilla 

# unpack all the configurations for our desktop
cd /home/ubuntu
chown ubunu css.profile.tgz
sudo -u ubuntu tar zxvf css.profile.tgz
rm css.profile.tgz
