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
class zabbix inherits zabbix::params {

    @file {
        'zabbix/config/dir':
            tag     => [global,agent,server,proxy,frontend],
            path    => $zabbix::params::config_dir,
            ensure	=> directory,
            mode	  => 755;
        'zabbix/frontend/config/file':
            tag     => frontend,
            path    => $zabbix::params::frontend_config_file,
            ensure  => present,
            owner   => root,
            group   => root,
            mode    => 644;
        'zabbix/server/config/alert/dir':
            tag     => [server,proxy],
            path    => $zabbix::params::alertd_dir,
            ensure  => directory,
            mode    => 755;
        'zabbix/server/config/externalscripts/dir':
            tag     => [server,proxy],
            path    => $zabbix::params::externalscripts_dir,
            ensure  => directory,
            mode    => 755;
        'zabbix/server/config/file':
            tag     => server,
            path    => $zabbix::params::server_config_file,
            ensure  => present,
            mode    => 640,
            owner   => root,
            group   => $zabbix::params::group,
            require => Package['zabbix/server/package'],
            notify  => Service['zabbix/server/service'];
        'zabbix/proxy/config/file':
            tag     => proxy,
            path    => $zabbix::params::proxy_config_file,
            ensure  => present,
            mode    => 640,
            owner   => root,
            group   => $zabbix::params::group,
            require => Package['zabbix/proxy/package'],
            notify  => Service['zabbix/proxy/service'];
        'zabbix/proxy/pid/dir':
            tag     => proxy,
            path    => $zabbix::params::proxy_pid_dir,
            ensure  => directory,
            owner   => $zabbix::params::user,
            group   => $zabbix::params::group;
        'zabbix/proxy/log/dir':
            tag     => proxy,
            path    => $zabbix::params::proxy_log_dir,
            ensure  => directory,
            owner   => $zabbix::params::user,
            group   => $zabbix::params::group;
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
            group   => $zabbix::params::group;
        'zabbix/server/pid/dir':
            tag     => server,
            path    => $zabbix::params::server_pid_dir,
            ensure  => directory,
            mode    => 755,
            owner   => $zabbix::params::user,
            group   => $zabbix::params::group;
        'zabbix/server/log/dir':
            tag     => server,
            path    => $zabbix::params::server_log_dir,
            ensure  => directory,
            mode    => 755,
            owner   => $zabbix::params::user,
            group   => $zabbix::params::group;
        'mysql/preseed':
            tag     => [server,frontend,proxy],
            path    => $zabbix::params::mysql_preseed_file,
            ensure  => undef,
            mode    => 400,
            owner   => root,
            group   => root;
        'zabbix/server/preseed':
            tag     => server,
            path    => $zabbix::params::server_preseed_file,
            ensure  => undef,
            mode    => 400,
            owner   => root,
            group   => root,
            before  => Package['zabbix/server/package'];
        'zabbix/proxy/preseed':
            tag     => proxy,
            path    => $zabbix::params::proxy_preseed_file,
            ensure  => undef,
            mode    => 400,
            owner   => root,
            group   => root,
            before  => Package['zabbix/proxy/package'],
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
            name    => $zabbix::params::proxy_package;
        'zabbix/frontend/package':
            ensure  => present,
            name    => $zabbix::params::frontend_package;
        'mysql/packages':
            ensure       => present,
            name         => $zabbix::params::mysql_packages,
            responsefile => $::operatingsystem ? {
              ubuntu  => $zabbix::params::mysql_preseed_file,
              default => undef,
            },
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
            hasstatus => $zabbix::params::server_hasstatus,
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
