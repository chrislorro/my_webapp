# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   my_webapp::vhost_svc { 'namevar': }
define my_webapp::vhost_svc (
  String $ensure_vhost = present,
  String $servername   = $title,
  String $listen_ip    = $listen_ip,
  Integer $websvc_port  = $port,
) {

  # if $ensure_vhost {

    # apache::vhost { "${servername}:${listen_ip}:${websvc_port}":
    #   ensure     => $ensure_vhost,
    #   servername => $servername,
    #   ip         => $listen_ip,
    #   port       => $websvc_port,
    # }
  # }
}
