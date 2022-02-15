# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include my_webapp::config
class my_webapp::config {

  include my_webapp

  $file_config = $facts['kernel'] ? {
    'Windows' => {
                    'path'      => "C:/Users/${my_webapp::run_user}/AppData/Roaming/Apache24/conf/httpd.conf",
                    'owner'     => 'Administrator',
                  },
    default   => {
                    'path'      => '/etc/httpd/conf/httpd.conf',
                    'owner'     => 'root',
                    'group'     => 'root',
                  }
  }

  file { 'httpd.conf':
    ensure  => file,
    mode    => '0644',
    *       => $file_config,
    require => Class['my_webapp::install']
  }

  if my_webapp::ensure_vhost {
    case $facts['kernel'] {
      default: {
        warning("Apache not supported on ${facts['kernel']}")
      }
      # 'Linux': {
      #   my_webapp::vhost_svc { $my_webapp::servicename:
      #     listen_ip   => $my_webapp::listen_ip,
      #     websvc_port => $my_webapp::websvc_port,
      #   }
      # }
    }
  }
}
