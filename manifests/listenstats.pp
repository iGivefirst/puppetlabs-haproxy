# == Define Resource Type: haproxy::listenstats
#
define haproxy::listenstats (
  $port,
  $ipaddress        = $::ipaddress,
  $mode             = undef,
  $username,
  $password
  $config_file = '/etc/haproxy/haproxy.cfg',
) {

  # Template uses: $ipaddress, $port, $mode, $username, $password
  concat::fragment { "${name}_listenstatus_block":
    order   => "20-${name}-00",
    target  => $config_file,
    content => template('haproxy/haproxy_listenstats_block.erb'),
  }
}
