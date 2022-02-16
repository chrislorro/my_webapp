# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   my_webapp::virtual_svc { 'namevar': }
define my_webapp::virtual_svc (
  String $servicename  = $title,
  String $config_path  = $config_path,
  String $listen_ip    = $listen_ip,
  Integer $websvc_port = $websvc_port,
) {

  $file_owner = lookup('my_webapp::svc_owner')

  file { "${title}_${websvc_port}.conf":
    ensure  => file,
    path    => $config_path,
    mode    => '0640',
    content => epp('my_webapp/web_svc.conf.epp', {
      'listen_ip'   => $listen_ip,
      'websvc_port' => $websvc_port,
      'servicename' => $title,
      }),
    owner   => $file_owner,
  }
}
