#!/bin/bash
rpm -Uvh https://yum.puppetlabs.com/puppet/puppet-release-el-5.noarch.rpm
yum -y install puppet-agent
cat >> /etc/puppetlabs/puppet/puppet.conf << EOF
[main]
server = ${dns_name}
environment = ${env}
EOF
cat >> /etc/hosts << EOF
${puppet_ip} ${dns_name}
EOF
service puppet start
