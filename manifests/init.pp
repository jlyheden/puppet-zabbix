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
  }

}
