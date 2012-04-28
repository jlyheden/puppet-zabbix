/*
 * ==:Class zabbix::agent
 * 
 * Manages Zabbix agent
 * 
 * @params
 * @ensure			String value present or absent
 * @version			String value Zabbix version
 * @server_host		String value ip address or hostname of zabbix server
 * @server_port		Integer value port number of zabbix server
 * @startagents		Integer value number of zabbix agent processes
 * @debuglevel		Integer value debuglevel
 * @timeout			Integer value timeout in seconds
 * @port			Integer value listen port for zabbix agent
 * @active_mode		Boolean value if active mode should be used
 * @remote_commands	Boolean value if remote commands should be allowed
 * @auto_register	Boolean value if agent should auto register (TODO)
 */
 class zabbix::agent ( $ensure = "present",
                       $version = $zabbix::params::version,
 	                   $server_host,
 	                   $server_port = $zabbix::params::server_port,
 	                   $startagents = $zabbix::params::agent_startagents,
 	                   $debuglevel = $zabbix::params::agent_debuglevel,
 	                   $timeout = $zabbix::params::agent_timeout,
 	                   $port = $zabbix::params::agent_port,
 	                   $active_mode = $zabbix::params::agent_active_mode,
 	                   $remote_commands = $zabbix::params::agent_remote_commands,
 	                   $auto_register = $zabbix::params::agent_auto_register ) inherits zabbix::params {
 	include zabbix::agent::config
 	include zabbix::agent::package
 	include zabbix::agent::service
 }