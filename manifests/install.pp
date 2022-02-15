# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include my_webapp::install
class my_webapp::install {

  include my_webapp

  if $facts['kernel'] == 'windows' {
    Package { provider => 'chocolatey'}
  }

  package { $my_webapp::web_package:
    ensure => installed,
    name   => $my_webapp::web_package,
  }
}
