# ==: Class zabbix
#
# Installs, configures and manages Zabbix
#
# ==: Parameters
#
# ==: Requires
#
# ==: Sample Usage
#
#   Don't access this class directly, instead use classes zabbix::agent, zabbix::proxy, zabbix::frontend or zabbix::server
# 
class zabbix inherits zabbix::params {

    @file {
        "zabbix/config/dir":
            tag     => global,
            path    => $zabbix::params::config_dir,
            ensure	=> directory,
            mode	=> 755;
        "zabbix/config/server/alert/dir":
            tag     => server,
            path    => $zabbix::params::alertd_dir,
            ensure  => directory,
            mode    => 755;
        "zabbix/config/server/externalscripts/dir":
            tag     => server,
            path    => $zabbix::params::externalscripts_dir,
            ensure  => directory,
            mode    => 755;
        "zabbix/config/agent/file":
            tag     => agent,
            path    => $zabbix::params::agent_config_file,
            ensure  => file,
            mode    => 644,
            notify  => Service["zabbix/agent"],
            require => [ Package["zabbix/agent"], Service["zabbix/agent"] ];
        "zabbix/agent/pid/dir":
            tag     => agent,
            path    => $zabbix::params::agent_pid_dir,
            ensure  => directory,
            mode    => 755,
            owner   => $zabbix::params::user,
            group   => $zabbix::params::group;
        "zabbix/agent/log/dir":
            tag     => agent,
            path    => $zabbix::params::agent_log_dir,
            ensure  => directory,
            mode    => 755,
            owner   => $zabbix::params::user,
            group   => $zabbix::params::group,
    }

    @package {
        "zabbix/agent":
            ensure  => present,
            name    => $zabbix::params::agent_package;
        "zabbix/server":
            ensure  => present,
            name    => $zabbix::params::server_package;
        "zabbix/proxy":
            ensure  => present,
            name    => $zabbix::params::proxy_package
    }

    @service {
        "zabbix/agent":
            ensure  => running,
            enable  => true,
            name    => $zabbix::params::agent_service;
        "zabbix/server":
            ensure  => running,
            enable  => true,
            name    => $zabbix::params::server_service;
        "zabbix/proxy":
            ensure  => running,
            enable  => true,
            name    => $zabbix::params::proxy_service;
    }

    @user { "user/zabbix":
        ensure      => present,
        name        => $zabbix::params::user,
        system      => true,
        shell       => false,
        managehome  => false,
        home        => "/home/${zabbix::params::user}",
        gid         => $zabbix::params::group
    }

    @group { "group/zabbix":
    	ensure     => present,
    	name       => $zabbix::params::group,
    	system     => true
    }

}