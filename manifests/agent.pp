# ==: Class zabbix::agent
#
# Installs, configures and manages the Zabbix agent service
#
# ==: Parameters
#   [*ensure*]
#     Deprecated. In place to prevent errors if user sets the parameter
#
#   [*nodename*]
#     Hostname of zabbix agent, defaults to $::hostname
#     Optional
#
#   [*version*]
#     Zabbix version.
#     Optional
#
#   [*server_host*]
#     Comma separated list of Zabbix servers
#     Required
#
#   [*server_port*]
#     Zabbix server port, defaults to default zabbix server port
#     Optional
#
#   [*startagents*]
#     Number of pre-forked instances to start
#     Optional
#
#   [*debuglevel*]
#     Numerical debug level
#     Optional
#
#   [*timeout*]
#     Maximum time in second spent on processing
#     Optional
#
#   [*port*]
#     Passive listening port for agent
#     Optional
#
#   [*active_mode*]
#     Boolean if active mode should be enabled.
#     Optional
#
#   [*remote_commands*]
#     Boolean if remote commands should be allowed
#     Optional
#
#   [*ensure_version*]
#     Pin package to specific version or ensure latest
#     Optional
#
# ==: Requires
#
# ==: Sample Usage
#
#   class { "zabbix::agent": ensure => present }
# 
class zabbix::agent ( $ensure = "present",
                      $nodename = $zabbix::params::nodename,
                      $server_host = $zabbix::params::server_host,
                      $server_port = $zabbix::params::server_port,
                      $startagents = $zabbix::params::agent_startagents,
                      $debuglevel = $zabbix::params::agent_debuglevel,
                      $timeout = $zabbix::params::agent_timeout,
                      $port = $zabbix::params::agent_port,
                      $active_mode = $zabbix::params::agent_active_mode,
                      $remote_commands = $zabbix::params::agent_remote_commands,
                      $ensure_version = undef,
                      $custom_template = undef ) inherits zabbix::params {

    include zabbix

    case $ensure_version {
    	latest: {
    		Package["zabbix/agent"] { ensure => latest }
    	}
    	/[0-9]+[0-9\.\-\_\:a-zA-Z]/: {
    		Package["zabbix/agent"] { ensure => $ensure_version }
    	}
    	undef: {
    		# Do nothing
    	}
    	default: {
    		warning("Parameter ensure_version only supports latest, version-number or undef")
    	}
    }    

    if $custom_template != undef {
    	File["zabbix/config/agent/file"] { content => template($custom_template) }
    }

    File <| tag == [global,agent] |>

    realize(Package["zabbix/agent"], Service["zabbix/agent"], User["user/zabbix"], Group["group/zabbix"])

}