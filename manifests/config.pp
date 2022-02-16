# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include my_webapp::config
class my_webapp::config {

  $app_user = lookup('my_webapp::websvc_user')

  $app_user.each |$user, $config| {
    user { $user:
      ensure => present,
      *      => $config,
    }
  }

  $http_config = "${my_webapp::config_path}/${my_webapp::http_config}"

  file { $http_config:
    ensure  => file,
    mode    => '0644',
    owner   => $my_webapp::app_user,
    require => Class['my_webapp::install']
  }

  if my_webapp::ensure_vhost {
    case $facts['kernel'] {
      default: {
        warning("Apache not supported on ${facts['kernel']}")
      }
      'Linux': {
        my_webapp::virtual_svc { $my_webapp::servicename:
          config_path => $my_webapp::config_path,
          listen_ip   => $my_webapp::listen_ip,
          websvc_port => $my_webapp::websvc_port,
        }
      }
    }
  }
}
