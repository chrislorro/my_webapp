# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include my_webapp::service
class my_webapp::service {

  $http_config = "${my_webapp::config_path}/${my_webapp::http_config}"

  service { $my_webapp::web_service:
    ensure    => $my_webapp::http_ensure,
    enable    => $my_webapp::http_enable,
    subscribe => File[$http_config],
  }
}
