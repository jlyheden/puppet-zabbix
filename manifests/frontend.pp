/*
 * ==:Class zabbix::frontend
 * 
 * Manages Zabbix frontend
 * 
 * @params
 * @ensure			String value present or absent
 * @version			String value Zabbix version
 * @server_host		String value ip address or hostname of zabbix server
 * @server_port		Integer value port number of zabbix server
 * @dbhost			String value MySQL db server
 * $dbport			Integer value MySQL db port
 * @dbname			String value MySQL db name
 * @dbuser			String value MySQL db user
 * @dbpassword		String value MySQL db password
 * @webserver		String value name of webserver service
 */
class zabbix::frontend ( $ensure = "present",
                         $nodename = $zabbix::params::nodename,
	                     $version = $zabbix::params::version,
 	                     $server_host,
 	                     $server_port = $zabbix::params::server_port,
	                     $dbhost,
	                     $dbport = $zabbix::params::frontend_dbport,
	                     $dbname,
	                     $dbuser,
	                     $dbpassword,
	                     $webserver = $zabbix::params::frontend_webserver ) inherits zabbix::params {
	include zabbix::frontend::package
	include zabbix::frontend::config
}