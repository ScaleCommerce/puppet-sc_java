# == Class: sc_java
#
# register oracle java repository and install java
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*java_distribution*]
#   either openjdk or oracle, default is 'oracle'
# [*java_version*]
#   java version, default is '8'
#
#
# === Authors
#
# Andreas Ziethen <az@scale.sc>
# Thomas Lohner <tl@scale.sc>
#
# === Copyright
#
# Copyright 2018 ScaleCommerce GmbH
#
class sc_java(
  $java_distribution = 'oracle',
  $java_version = '8',
) {

  case $java_distribution {
    'openjdk': {
      package { "openjdk-$java_version-jdk":
        ensure => 'installed',
      }
    }
    'oracle', default: {
      include apt

      case $java_version {
        8, default:  {
          apt::key { 'ppa:webupd8team/java':
            ensure => present,
            id     => '7B2C3B0889BF5709A105D03AC2518248EEA14886',
          }->

          apt::ppa { 'ppa:webupd8team/java':
            ensure => present,
            notify => Exec['java_apt_get_update'],
          }->

          exec { 'acceptLicense':
            command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections',
            unless => "/usr/bin/debconf-show oracle-java$java_version-installer | grep 'accepted-oracle-license-v1-1: true'",
            before => Exec['java_apt_get_update'],
          }
        }
        11:  {
          apt::key { 'ppa:linuxuprising/java':
            ensure => present,
            id     => '1CC3D16E460A94EE17FE581CEA8CACC073C3DB2A',
          }->

          apt::ppa { 'ppa:linuxuprising/java':
            ensure => present,
            notify => Exec['java_apt_get_update'],
          }->

          exec { 'acceptLicense':
            command => '/bin/echo oracle-java11-installer shared/accepted-oracle-license-v1-2 select true | /usr/bin/debconf-set-selections',
            unless => "/usr/bin/debconf-show oracle-java$java_version-installer | grep 'accepted-oracle-license-v1-2: true'",
            before => Exec['java_apt_get_update'],
          }
        }
      }

      # apt class is not used due to problems with dependency cylce in rundeck module
      exec { 'java_apt_get_update':
        command => '/usr/bin/apt-get update',
        before => Package["oracle-java$java_version-installer"],
        refreshonly => true,
      }

      package { "oracle-java$java_version-installer":
        ensure => 'installed',
      }
    }
  }
}
