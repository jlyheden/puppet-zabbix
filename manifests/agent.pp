# == Class zabbix::agent
#
# Installs, configures and manages the Zabbix agent service
#
# === Parameters
#
# === Sample Usage
#
# include zabbix::agent
#
class zabbix::agent (
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
  $agent_parameters = 'UNDEF'
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
    'UNDEF' => $zabbix::params::agent_source,
    default => $source
  }
  $conf_d_purge_real = $conf_d_purge ? {
    'UNDEF' => $zabbix::params::agent_conf_d_purge,
    default => $conf_d_purge
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
    'UNDEF' => $zabbix::params::agent_server,
    default => $server
  }
  $agent_parameters_real = $agent_parameters ? {
    'UNDEF' => $zabbix::params::agent_parameters,
    default => $agent_parameters
  }

  $agent_parameters_real['LogFile'] = "${log_d_real}/zabbix_agentd.log"
  $agent_parameters_real['PidFile'] = "${run_d_real}/zabbix_agentd.pid"

  # Evaluate template as late as possible
  $content_real = $content ? {
    'UNDEF'   => $zabbix::params::agent_template ? {
      ''      => '',
      default => template($zabbix::params::agent_template)
    },
    default   => $content
  }

  # Input validation
  validate_re($ensure_real,$zabbix::params::valid_ensure_values)
  validate_re($service_status_real,$zabbix::params::valid_service_statuses)
  validate_bool($service_enable_real)
  validate_bool($autoupgrade_real)
  validate_bool($autorestart_real)
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
        Package['zabbix::agent'] -> File['zabbix/run_d']
        realize(File['zabbix/run_d'])
      } else {
        Package['zabbix::agent'] -> File['zabbix::agent/run_d']
        file { 'zabbix::agent/run_d':
          ensure  => directory,
          path    => $run_d_real,
          owner   => $zabbix::params::user,
          group   => $zabbix::params::group,
          mode    => '0644'
        }
      }
      if $log_d_real == $zabbix::params::log_dir {
        Package['zabbix::agent'] -> File['zabbix/log_d']
        realize(File['zabbix/log_d'])
      } else {
        Package['zabbix::agent'] -> File['zabbix::agent/log_d']
        file { 'zabbix::agent/log_d':
          ensure  => directory,
          path    => $log_d_real,
          owner   => $zabbix::params::user,
          group   => $zabbix::params::group,
          mode    => '0640'
        }
      }
      if $source_real != '' {
        File['zabbix::agent/conf'] { source => $source_real }
      }
      elsif $content_real != '' {
        File['zabbix::agent/conf'] { content => $content_real }
      }
      if $autorestart_real {
        File['zabbix::agent/conf'] { notify => Service['zabbix::agent'] }
        File['zabbix::agent/conf_d'] { notify => Service['zabbix::agent'] }
        File_line['set_init_script_run_dir'] { notify => Service['zabbix::agent'] }
      }
      if $conf_d_purge_real {
        File['zabbix::agent/conf_d'] {
          force   => true,
          purge   => true,
          recurse => true
        }
      }
      if $zabbix::params::agent_hasstatus {
        Service['zabbix::agent'] {
          hasstatus => true
        }
      } else {
        Service['zabbix::agent'] {
          hasstatus => false,
          restart   => "/etc/init.d/${zabbix::params::agent_service} restart",
          stop      => "/etc/init.d/${zabbix::params::agent_service} stop",
          start     => "/etc/init.d/${zabbix::params::agent_service} start",
          pattern   => $zabbix::params::agent_pattern,
        }
      }
      # Should set the pid file dir in the zabbix agent init script
      # Why can't this be overrided in a sourced variable file..
      file_line { 'set_init_script_run_dir':
        ensure  => present,
        path    => $zabbix::params::agent_init,
        line    => "DIR=${run_d_real}",
        match   => '^DIR=.*$',
        require => Package['zabbix::agent']
      }
      file { 'zabbix::agent/conf':
        ensure  => present,
        path    => $zabbix::params::agent_conf,
        owner   => 'root',
        group   => $zabbix::params::group,
        mode    => '0640'
      }
      file { 'zabbix::agent/conf_d':
        ensure  => directory,
        path    => $zabbix::params::agent_conf_d,
        owner   => 'root',
        group   => $zabbix::params::group,
        mode    => '0640'
      }
      service { 'zabbix::agent':
        ensure    => $service_status_real,
        name      => $zabbix::params::agent_service,
        enable    => $service_enable_real,
        require   => [ Package['zabbix::agent'], File['zabbix::agent/conf'], File['zabbix::agent/conf_d'] ]
      }
      # Let package create user
      File <| tag == 'userparameter' |>
      Package['zabbix::agent'] -> File['zabbix::agent/conf','zabbix::agent/conf_d']
    }
    default: {}
  }

  package { 'zabbix::agent':
    ensure  => $ensure_package,
    name    => $zabbix::params::agent_package;
  }

}
