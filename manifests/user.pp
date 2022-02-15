# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include my_webapp::user
class my_webapp::user {

  include my_webapp

  $app_user = lookup('my_webapp::websvc_user')

  $app_user.each |$user, $config| {
    user { $user:
      ensure => present,
      *      => $config,
    }
  }
}
