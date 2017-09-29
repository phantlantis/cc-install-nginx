#!/bin/bash
sudo apt-get update

#Install Chefdk and curl
apt-get -y install curl
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 2.0.28

cp -r ./berks-cookbooks/ /var/

mkdir ~/.chef/
cp ./knife.rb ~/.chef/knife.rb

chef-client --local-mode --runlist 'recipe[nginxserver]'
