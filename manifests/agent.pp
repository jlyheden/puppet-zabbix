# == Class zabbix::agent
#
# Installs, configures and manages the Zabbix agent service
#
# === Parameters
#
# [*nodename*]
#   Optional. Hostname of zabbix agent. Default: hostname
#
# [*server_host*]
#   Optional. Comma separated list of Zabbix servers. Default: zabbix.domainname
#
# [*server_port*]
#   Optional. Zabbix server port. Default: 10051
#
# [*startagents*]
#   Optional. Number of pre-forked instances to start. Default: 5
#
# [*debuglevel*]
#   Optional. Numerical level level. Default: 3
#
# [*timeout*]
#   Optional. Maximum time in second spent on processing. Default: 3
#
# [*port*]
#   Optional. Passive listening port for agent. Default: 10050
#
# [*active_mode*]
#   Optional. Boolean if active mode should be enabled. Default: true
#
# [*remote_commands*]
#   Optional. Boolean if remote commands should be allowed. Default: true
#
# [*autoupgrade*]
#   Optional. Boolean to automatically install latest version or pin to specific version. Default: false
#
# [*custom_template*]
#   Optional. Custom zabbix_agentd.conf template use. Default: undef
#
# [*zabbix_uid*]
#   Optional. Numerical UID for zabbix user to use. If undef a random UID will be used. Default: undef
#
# [*zabbix_gid*]
#   Optional. Numerical GID for zabbix user to use. If undef a random GID will be used. Default: undef
#
# === Requires
#
# === Sample Usage
#
# include zabbix::agent
#
#   or
#
# class { 'zabbix-agent':
#   nodename    => 'my-different-than $::hostname hostname',
#   server_host => 'my-custom-zabbix-server',
#   active_mode => false
# }
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
                      $autoupgrade = $zabbix::params::agent_autoupgrade,
                      $custom_template = undef,
                      $zabbix_uid = undef,
                      $zabbix_gid = undef ) inherits zabbix {

    include zabbix::params

    case $autoupgrade {
    	true: {
    		Package['zabbix/agent/package'] { ensure => latest }
    	}
    	/[0-9]+[0-9\.\-\_\:a-zA-Z]/: {
    		Package['zabbix/agent/package'] { ensure => $autoupgrade }
    	}
    	false: {
    		# Do nothing
    	}
    	default: {
    		warning('Parameter autoupgrade only supports values: true, false or version-number')
    	}
    }

    File['zabbix/agent/config/file'] {
      content => $custom_template ? {
        undef   => template('zabbix/agent/zabbix_agentd.conf.erb'),
        default => template($custom_template),
      }
    }

    User['zabbix/user'] { uid => $zabbix_uid }
    Group['zabbix/group'] { gid => $zabbix_gid }

    File <| tag == agent |>

    Group <| title == 'zabbix/group' |> -> User <| title == 'zabbix/user' |> -> Package <| title == 'zabbix/agent/package' |> -> Service <| title == 'zabbix/agent/service' |>

}
