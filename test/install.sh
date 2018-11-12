#!/bin/bash
export PATH=/opt/puppetlabs/bin:$PATH
sed -i -e "s/nodaemon=true/nodaemon=false/" /etc/supervisord.conf
/usr/local/bin/supervisord -c /etc/supervisord.conf
echo "Running in $(pwd)"
echo "Puppet Version: $(puppet -V)"

# configure puppet
ln -sf $(pwd)/test/hiera.yaml $(puppet config print confdir |cut -d: -f1)/
ln -sf $(pwd)/test/hieradata $(puppet config print confdir |cut -d: -f1)/hieradata
puppet config set certname puppet-test.scalecommerce

# install global-puppet-modules
mkdir -p /opt/repos/global-puppet-modules/ && git clone https://gitlab.scale.sc/scalecommerce/global-puppet-modules.git /opt/repos/global-puppet-modules/
rm -rf /opt/puppetlabs/puppet/modules/ && ln -s /opt/repos/global-puppet-modules/modules /opt/puppetlabs/puppet
rm -rf /opt/puppetlabs/puppet/modules/sc_java/

# install current module
ln -sf $(pwd) $(puppet config print modulepath |cut -d: -f1)/sc_java

#fix for scalecommerce/base:0.6
if ! dpkg-query -W apt-transport-https ; then
    apt-get -y install --no-install-recommends apt-transport-https
fi

# install inspec
curl -s https://omnitruck.chef.io/install.sh | bash -s -- -P inspec
