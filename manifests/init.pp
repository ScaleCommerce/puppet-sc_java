# == Class: sc_java
#
# register oracle java repository and install java
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*java_version*]
#   java version, default is '8'
#
# === Examples
#
#  class { 'sc_java':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Andreas Ziethen <az@scale.sc>
#
# === Copyright
#
# Copyright 2016 ScaleCommerce GmbH
#
class sc_java(
  $java_version = '8',
) {
  include apt

    apt::key { 'ppa:webupd8team/java':
      ensure => present,
      id     => '7B2C3B0889BF5709A105D03AC2518248EEA14886',
    }->
    apt::ppa { 'ppa:webupd8team/java':
      ensure => present,
    }

    exec { 'acceptLicense':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections',
      unless => "/usr/bin/debconf-show oracle-java$java_version-installer | grep 'accepted-oracle-license-v1-1: true'",
    }->

    package { "oracle-java$java_version-installer":
      ensure => 'installed',
    }
}
