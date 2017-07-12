#!/bin/bash
timedatectl set-timezone Europe/Kiev
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install puppet-agent
cat >> /etc/puppetlabs/puppet/puppet.conf << EOF
[main]
server = ${dns_name}
environment = ${env}
EOF
systemctl start puppet
