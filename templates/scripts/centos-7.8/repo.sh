#!/bin/bash

set -e
set -x

sudo yum -y install https://download.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-12.noarch.rpm
sudo yum -y install cloud-init cloud-utils-growpart dracut-modules-growroot 
sudo yum update -y && sudo yum update -y
#sudo sed -i -e 's/^enabled=1/enabled=0/' /etc/yum.repos.d/epel.repo
