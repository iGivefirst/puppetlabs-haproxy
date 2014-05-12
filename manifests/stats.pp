# == Define Resource Type: haproxy::stats
#
define haproxy::stats (
  $port,
  $ipaddress        = $::ipaddress,
  $mode             = 'http',
  $username,
  $password,
  $config_file = '/etc/haproxy/haproxy.cfg',
) {

  # Template uses: $ipaddress, $port, $mode, $username, $password
  concat::fragment { "${ipaddress}_stats_block":
    order   => "20-${ipaddress}-stats-00",
    target  => $config_file,
    content => template('haproxy/haproxy_stats_block.erb'),
  }
}
