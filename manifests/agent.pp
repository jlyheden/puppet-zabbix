# ==: Class zabbix::agent
#
# Installs, configures and manages the Zabbix agent service
#
# ==: Parameters
#
#   [*nodename*]
#     Hostname of zabbix agent, defaults to "$::hostname".
#     Optional
#
#   [*version*]
#     Zabbix version.
#     Optional
#
#   [*server_host*]
#     Comma separated list of Zabbix servers. Defaults to "zabbix.${::domain}".
#     Required
#
#   [*server_port*]
#     Zabbix server port, defaults to default zabbix server port.
#     Optional
#
#   [*startagents*]
#     Number of pre-forked instances to start.
#     Optional
#
#   [*debuglevel*]
#     Numerical debug level.
#     Optional
#
#   [*timeout*]
#     Maximum time in second spent on processing.
#     Optional
#
#   [*port*]
#     Passive listening port for agent. Defaults to default agent port.
#     Optional
#
#   [*active_mode*]
#     Boolean if active mode should be enabled. Defaults to true.
#     Optional
#
#   [*remote_commands*]
#     Boolean if remote commands should be allowed.
#     Optional
#
#   [*ensure_version*]
#     Pin package to specific version or ensure latest.
#     Optional
#
#   [*custom_template*]
#     Custom zabbix_agentd.conf template use.
#     Optional
#
#   [*zabbix_uid*]
#     Numerical UID for zabbix user to use.
#     Optional
#
#   [*zabbix_gid*]
#     Numerical GID for zabbix user to use.
#     Optional
#
# ==: Requires
#
# ==: Sample Usage
#
#   class { "zabbix::agent": ensure => present }
# 
class zabbix::agent ( $nodename = $zabbix::params::nodename,
                      $server_host = $zabbix::params::server_host,
                      $server_port = $zabbix::params::server_port,
                      $startagents = $zabbix::params::agent_startagents,
                      $debuglevel = $zabbix::params::agent_debuglevel,
                      $timeout = $zabbix::params::agent_timeout,
                      $port = $zabbix::params::agent_port,
                      $active_mode = $zabbix::params::agent_active_mode,
                      $remote_commands = $zabbix::params::agent_remote_commands,
                      $ensure_version = undef,
                      $custom_template = undef,
                      $zabbix_uid = $zabbix::params::uid,
                      $zabbix_gid = $zabbix::params::gid ) inherits zabbix {

    include zabbix::params

    case $ensure_version {
    	latest: {
    		Package["zabbix/agent/package"] { ensure => latest }
    	}
    	/[0-9]+[0-9\.\-\_\:a-zA-Z]/: {
    		Package["zabbix/agent/package"] { ensure => $ensure_version }
    	}
    	undef: {
    		# Do nothing
    	}
    	default: {
    		warning("Parameter ensure_version only supports values: latest, version-number or undef")
    	}
    }    

    File["zabbix/agent/config/file"] {
      content => $custom_template ? {
        undef   => template('zabbix/agent/zabbix_agentd.conf.erb'),
        default => template($custom_template),
      }
    }

    User["zabbix/user"] { uid => $zabbix_uid }
    Group["zabbix/group"] { gid => $zabbix_gid }

    File <| tag == "agent" |>

    Group <| title == "zabbix/group" |> -> User <| title == "zabbix/user" |> -> Package <| title == "zabbix/agent/package" |> -> Service <| title == "zabbix/agent/service" |>

}
