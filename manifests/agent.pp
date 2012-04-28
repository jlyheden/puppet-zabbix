/*
 * ==:Class zabbix::agent
 * 
 * Installs, configures and manages the Zabbix agent service
 * 
 * @params
 * @ensure			String value present or absent
 * @nodename        String value name of this Zabbix agent node
 * @version			String value Zabbix version
 * @server_host		String value list of comma delimited IP addresses (or hostnames) of Zabbix servers. No spaces allowed
 * @server_port		Integer value server port for retrieving list of and sending active checks
 * @startagents		Integer value number of pre-forked instances of zabbix_agentd that process passive checks
 * @debuglevel		Integer value debuglevel
 * @timeout			Integer value spend no more than Timeout seconds on processing
 * @port			Integer value agent will listen on this port for connections from the server
 * @active_mode		Boolean value if active mode should be used
 * @remote_commands	Boolean value whether remote commands from Zabbix server are allowed
 * @auto_register	Boolean value if agent should auto register (TODO)
 */
 class zabbix::agent ( $ensure = "present",
                       $nodename = $zabbix::params::nodename,
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