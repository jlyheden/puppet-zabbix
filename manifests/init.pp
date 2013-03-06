# == Class zabbix
#
# Installs, configures and manages Zabbix
#
# === Parameters
#
# === Requires
#
# === Sample Usage
#
# Don't access this class directly, instead use classes zabbix::agent, zabbix::proxy, zabbix::frontend or zabbix::server
#
class zabbix {

  include zabbix::params

  @file {
    'zabbix/conf_d':
      ensure	=> directory,
      tag     => [global,agent,server,proxy,frontend],
      path    => $zabbix::params::config_dir,
      owner   => 'root',
      group   => 'root',
      mode	  => '0644';
    'zabbix/run_d':
      ensure  => directory,
      tag     => [global,agent,server,proxy],
      path    => $zabbix::params::run_dir,
      mode    => '0644',
      owner   => $zabbix::params::user,
      group   => $zabbix::params::group;
    'zabbix/log_d':
      ensure  => directory,
      tag     => [global,agent,server,proxy],
      path    => $zabbix::params::log_dir,
      mode    => '0640',
      owner   => $zabbix::params::user,
      group   => $zabbix::params::group;
    'zabbix/server/alert_d':
      ensure  => directory,
      tag     => [server,proxy],
      path    => $zabbix::params::alertd_dir,
      owner   => 'root',
      group   => $zabbix::params::group,
      mode    => '0640';
    'zabbix/server/externalscripts_d':
      ensure  => directory,
      tag     => [server,proxy],
      path    => $zabbix::params::externalscripts_dir,
      owner   => 'root',
      group   => $zabbix::params::group,
      mode    => '0640';
    'zabbix/server/preseed':
     tag     => server,
            path    => $zabbix::params::server_preseed_file,
            ensure  => undef,
            mode    => 400,
            owner   => root,
            group   => root,
            before  => Package['zabbix/server/package'];
        'zabbix/frontend/preseed':
            tag     => frontend,
            path    => $zabbix::params::frontend_preseed_file,
            ensure  => undef,
            mode    => 400,
            owner   => root,
            group   => root,
            before  => Package['zabbix/frontend/package'];
    }

    @package {
        'zabbix/server/package':
            ensure  => present,
            name    => $zabbix::params::server_package;
        'zabbix/frontend/package':
            ensure  => present,
            name    => $zabbix::params::frontend_package;
        'mysql/packages':
            ensure       => present,
            name         => $zabbix::params::mysql_packages,
            responsefile => $::operatingsystem ? {
              ubuntu     => $zabbix::params::mysql_preseed_file,
              default    => undef,
            },
            require      => $::operatingsystem ? {
              ubuntu     => File['mysql/preseed'],
              default    => undef,
            }
    }

    @service {
        'zabbix/server/service':
            ensure  => running,
            enable  => true,
            hasstatus => $zabbix::params::server_hasstatus,
            restart => "/etc/init.d/${zabbix::params::server_service} restart",
            stop    => "/etc/init.d/${zabbix::params::server_service} stop",
            start   => "/etc/init.d/${zabbix::params::server_service} start",
            pattern => $zabbix::params::server_pattern,
            name    => $zabbix::params::server_service,
            require => Package['zabbix/server/package']
    }

}
