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
#   Don't access this class directly, instead use classes zabbix::agent, zabbix::proxy, zabbix::frontend or zabbix::server
#
class zabbix inherits zabbix::params {

    @file {
        'zabbix/config/dir':
            tag     => [agent,server,proxy],
            path    => $zabbix::params::config_dir,
            ensure	=> directory,
            mode	  => 755;
        'zabbix/server/config/alert/dir':
            tag     => server,
            path    => $zabbix::params::alertd_dir,
            ensure  => directory,
            mode    => 755;
        'zabbix/server/config/externalscripts/dir':
            tag     => server,
            path    => $zabbix::params::externalscripts_dir,
            ensure  => directory,
            mode    => 755;
        'zabbix/agent/config/file':
            tag     => agent,
            path    => $zabbix::params::agent_config_file,
            ensure  => present,
            mode    => 644,
            notify  => Service['zabbix/agent/service'],
            require => Package['zabbix/agent/package'];
        'zabbix/agent/config/include/dir':
            tag     => agent,
            path    => $zabbix::params::agent_config_include,
            ensure  => directory,
            force   => true,
            purge   => true,
            recurse => true,
            notify  => Service['zabbix/agent/service'],
            mode    => 755;
        'zabbix/agent/pid/dir':
            tag     => agent,
            path    => $zabbix::params::agent_pid_dir,
            ensure  => directory,
            mode    => 755,
            owner   => $zabbix::params::user,
            group   => $zabbix::params::group;
        'zabbix/agent/log/dir':
            tag     => agent,
            path    => $zabbix::params::agent_log_dir,
            ensure  => directory,
            mode    => 755,
            owner   => $zabbix::params::user,
            group   => $zabbix::params::group,
    }

    @package {
        'zabbix/agent/package':
            ensure  => present,
            name    => $zabbix::params::agent_package;
        'zabbix/server/package':
            ensure  => present,
            name    => $zabbix::params::server_package;
        'zabbix/proxy/package':
            ensure  => present,
            name    => $zabbix::params::proxy_package
    }

    @service {
        'zabbix/agent/service':
            ensure  => running,
            enable  => true,
            hasstatus => $zabbix::params::agent_hasstatus,
            name    => $zabbix::params::agent_service,
            require => Package['zabbix/agent/package'];
        'zabbix/server/service':
            ensure  => running,
            enable  => true,
            name    => $zabbix::params::server_service,
            require => Package['zabbix/server/package'];
        'zabbix/proxy/service':
            ensure  => running,
            enable  => true,
            name    => $zabbix::params::proxy_service,
            require => Package['zabbix/proxy/package'];
    }

    @user { 'zabbix/user':
        ensure      => present,
        name        => $zabbix::params::user,
        shell       => '/bin/false',
        managehome  => false,
        home        => "/home/${zabbix::params::user}",
        gid         => $zabbix::params::group
    }

    @group { 'zabbix/group':
    	ensure     => present,
    	name       => $zabbix::params::group,
    }

}
