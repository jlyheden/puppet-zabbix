# == Class zabbix::server
#
# Installs, configures and manages the Zabbix server service
#
# === Parameters
#
# === Sample Usage
#
# TBD
#
class zabbix::proxy (
  $ensure           = 'UNDEF',
  $service_enable   = 'UNDEF',
  $service_status   = 'UNDEF',
  $autoupgrade      = 'UNDEF',
  $autorestart      = 'UNDEF',
  $source           = 'UNDEF',
  $content          = 'UNDEF',
  $conf_d_purge     = 'UNDEF',
  $run_d            = 'UNDEF',
  $log_d            = 'UNDEF',
  $server           = 'UNDEF',
  $dbhost           = 'UNDEF',
  $dbname           = 'UNDEF',
  $dbuser           = 'UNDEF',
  $dbport           = 'UNDEF',
  $dbpassword       = 'UNDEF',
  $dbrootpassword   = 'UNDEF',
  $managedb         = 'UNDEF',
  $proxy_parameters = 'UNDEF' 
) inherits zabbix {

  include zabbix::params

  # puppet 2.6 compatibility
  $ensure_real = $ensure ? {
    'UNDEF' => $zabbix::params::ensure,
    default => $ensure
  }
  $service_enable_real = $service_enable ? {
    'UNDEF' => $zabbix::params::service_enable,
    default => $service_enable
  }
  $service_status_real = $service_status ? {
    'UNDEF' => $zabbix::params::service_status,
    default => $service_status
  }
  $autoupgrade_real = $autoupgrade ? {
    'UNDEF' => $zabbix::params::autoupgrade,
    default => $autoupgrade
  }
  $autorestart_real = $autorestart ? {
    'UNDEF' => $zabbix::params::autorestart,
    default => $autorestart
  }
  $source_real = $source ? {
    'UNDEF' => $zabbix::params::proxy_source,
    default => $source
  }
  $run_d_real = $run_d ? {
    'UNDEF' => $zabbix::params::run_dir,
    default => $run_d
  }
  $log_d_real = $log_d ? {
    'UNDEF' => $zabbix::params::log_dir,
    default => $log_d
  }
  $server_real = $server ? {
    'UNDEF' => $zabbix::params::proxy_server,
    default => $server
  }
  $dbhost_real = $dbhost ? {
    'UNDEF' => $zabbix::params::dbhost,
    default => $dbhost
  }
  $dbname_real = $dbname ? {
    'UNDEF' => $zabbix::params::dbname,
    default => $dbname
  }
  $dbuser_real = $dbuser ? {
    'UNDEF' => $zabbix::params::dbuser,
    default => $dbuser
  }
  $dbport_real = $dbport ? {
    'UNDEF' => $zabbix::params::dbport,
    default => $dbport
  }
  $dbpassword_real = $dbpassword ? {
    'UNDEF' => $zabbix::params::dbpassword,
    default => $dbpassword
  }
  $dbrootpassword_real = $dbrootpassword ? {
    'UNDEF' => $zabbix::params::dbrootpassword,
    default => $dbrootpassword
  }
  $managedb_real = $managedb ? {
    'UNDEF' => $zabbix::params::managedb,
    default => $managedb
  }
  $proxy_parameters_real = $proxy_parameters ? {
    'UNDEF' => $zabbix::params::proxy_parameters,
    default => $proxy_parameters
  }

  $proxy_parameters_real['LogFile'] = "${log_d_real}/zabbix_proxy.log"
  $proxy_parameters_real['PidFile'] = "${run_d_real}/zabbix_proxy.pid"

  # Evaluate template as late as possible
  $content_real = $content ? {
    'UNDEF'   => $zabbix::params::proxy_template ? {
      ''      => '',
      default => template($zabbix::params::proxy_template)
    },
    default   => $content
  }

  # Input validation
  validate_re($ensure_real,$zabbix::params::valid_ensure_values)
  validate_re($service_status_real,$zabbix::params::valid_service_statuses)
  validate_bool($service_enable_real)
  validate_bool($autoupgrade_real)
  validate_bool($autorestart_real)
  validate_bool($managedb_real)
  if $source_real != ''  and $content_real != '' {
    fail('Only one of parameters source and content can be set')
  }

  if $ensure_real == 'present' and $autoupgrade_real == true {
    $ensure_package = 'latest'
  } else {
    $ensure_package = $ensure_real
  }

  $ensure_service = $service_status_real ? {
    'unmanaged' => undef,
    default     => $service_status_real
  }

  case $ensure_real {
    present: {

      if $run_d_real == $zabbix::params::run_dir {
        Package['zabbix::proxy'] -> File['zabbix/run_d']
        realize(File['zabbix/run_d'])
      } else {
        Package['zabbix::proxy'] -> File['zabbix/proxy/run_d']
        file { 'zabbix/proxy/run_d':
          ensure  => directory,
          path    => $run_d_real,
          owner   => $zabbix::params::user,
          group   => $zabbix::params::group,
          mode    => '0644'
        }
      }

      if $log_d_real == $zabbix::params::log_dir {
        Package['zabbix::proxy'] -> File['zabbix/log_d']
        realize(File['zabbix/log_d'])
      } else {
        Package['zabbix::proxy'] -> File['zabbix/proxy/log_d']
        file { 'zabbix/proxy/log_d':
          ensure  => directory,
          path    => $log_d_real,
          owner   => $zabbix::params::user,
          group   => $zabbix::params::group,
          mode    => '0640'
        }
      }

      if $source_real != '' {
        File['zabbix/proxy/conf'] { source => $source_real }
      }
      elsif $content_real != '' {
        File['zabbix/proxy/conf'] { content => $content_real }
      }

      if $autorestart_real {
        File['zabbix/proxy/conf'] { notify => Service['zabbix::proxy'] }
        File_line['set_proxy_init_script_run_dir'] { notify => Service['zabbix::proxy'] }
      }

      if $zabbix::params::proxy_hasstatus {
        Service['zabbix::proxy'] {
          hasstatus => true
        }
      } else {
        Service['zabbix::proxy'] {
          hasstatus => false,
          restart   => "/etc/init.d/${zabbix::params::proxy_service} restart",
          stop      => "/etc/init.d/${zabbix::params::proxy_service} stop",
          start     => "/etc/init.d/${zabbix::params::proxy_service} start",
          pattern   => $zabbix::params::proxy_pattern,
        }
      }

      if $managedb_real == true {
        if $dbrootpassword_real == '' {
          fail('You must set dbrootpassword when managedb is set to true')
        }
        if $::operatingsystem in [ 'Ubuntu', 'Debian' ] {
          file { 'zabbix::proxy/responsefile':
            ensure  => present,
            path    => $zabbix::params::proxy_preseed_file,
            mode    => '0400',
            owner   => 'root',
            group   => 'root',
            content => template('zabbix/proxy/preseed.erb'),
            before  => Package['zabbix::proxy']
          } 
          Package['zabbix::proxy'] {
            responsefile  => $zabbix::params::proxy_preseed_file,
            require       => File['zabbix::proxy/responsefile']
          }
        }
        class { 'zabbix::mysql':
          root_password => $dbrootpassword_real
        } ->
        Package['zabbix::proxy']
      }

      # Should set the pid file dir in the zabbix proxy init script
      # Why can't this be overrided in a sourced variable file..
      file_line { 'set_proxy_init_script_run_dir':
        ensure  => present,
        path    => $zabbix::params::proxy_init,
        line    => "DIR=${run_d_real}",
        match   => '^DIR=.*$',
        require => Package['zabbix::proxy']
      }

      file { 'zabbix/proxy/conf':
        ensure  => present,
        path    => $zabbix::params::proxy_conf,
        owner   => 'root',
        group   => $zabbix::params::group,
        mode    => '0640'
      }

      service { 'zabbix::proxy':
        ensure    => $service_status_real,
        name      => $zabbix::params::proxy_service,
        enable    => $service_enable_real,
        require   => [ Package['zabbix::proxy'], File['zabbix/proxy/conf'] ]
      }

      Package['zabbix::proxy'] -> File['zabbix/proxy/conf']
      Package['zabbix::proxy'] -> File <| tag == 'proxy' |>

    }
    default: {}
  }

  package { 'zabbix::proxy':
    ensure  => $ensure_package,
    name    => $zabbix::params::proxy_package;
  }

}
