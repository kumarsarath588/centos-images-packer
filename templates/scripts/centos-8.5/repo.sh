#!/bin/bash

set -e
set -x

sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

sudo yum -y install https://kartolo.sby.datautama.net.id/EPEL/8/Everything/x86_64/Packages/e/epel-release-8-13.el8.noarch.rpm
sudo yum -y install cloud-init cloud-utils-growpart
sudo yum update -y && sudo yum update -y
#sudo sed -i -e 's/^enabled=1/enabled=0/' /etc/yum.repos.d/epel.repo
