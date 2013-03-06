# == Class: zabbix::mysql
#
# Simple mysql class for Zabbix
# Replace with references to your own mysql module
#
class zabbix::mysql (
  $ensure         = 'UNDEF',
  $root_password  = 'UNDEF',
  $my_cnf         = 'UNDEF',
  $source         = 'UNDEF'
) inherits zabbix {

  $ensure_real = $ensure ? {
    'UNDEF' => $zabbix::params::ensure,
    default => $ensure
  }
  $my_cnf_real = $my_cnf ? {
    'UNDEF' => '/etc/mysql/my.cnf',
    default => $my_cnf
  }
  $source_real = $source ? {
    'UNDEF' => '',
    default => $source
  }
  if $root_password == 'UNDEF' {
    fail('Parameter root_password must be set')
  }

  validate_re($ensure_real,$zabbix::params::valid_ensure_values)

  case $ensure_real {
    present: {
      if $::operatingsystem in [ 'Ubuntu', 'Debian' ] {
        file { 'zabbix::mysql/responsefile':
          ensure  => present,
          path    => $zabbix::params::mysql_preseed_file,
          mode    => '0400',
          owner   => 'root',
          group   => 'root',
          content => template('zabbix/mysql/preseed.erb'),
          before  => Package['zabbix::mysql']
        }
        Package['zabbix::mysql'] {
          responsefile  => $zabbix::params::mysql_preseed_file,
          require       => File['zabbix::mysql/responsefile']
        }
      }
      service { 'zabbix::mysql':
        ensure    => running,
        name      => $zabbix::params::mysql_service,
        enable    => true,
        require   => Package['zabbix::mysql']
      }
    }
    default: {}
  }

  package { 'zabbix::mysql':
    ensure  => $ensure_real,
    name    => $zabbix::params::mysql_packages
  }

}
