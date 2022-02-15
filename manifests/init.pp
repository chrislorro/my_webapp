# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include my_webapp
class my_webapp (

  String          $pkg_version,
  String          $run_user,
  String          $servicename,
  String          $listen_ip,
  Integer         $websvc_port,
  String          $web_package,
  String          $web_service,
  Optional[String]          $ensure_vhost = undef,
  Boolean         $http_enable,
  Enum['stopped',
      'running']  $http_ensure,
  Hash            $websvc_user,
){

  if $facts['kernel'] == 'windows' {
    include chocolatey
  }

  contain my_webapp::install
  contain my_webapp::config
  contain my_webapp::service

  Class['my_webapp::install']
  -> Class['my_webapp::config']
  ~> Class['my_webapp::service']

}
