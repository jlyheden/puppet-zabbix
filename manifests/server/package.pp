/*
 * ==:Class zabbix::server::package
 * 
 * Manages the Zabbix server package 
 */
class zabbix::server::package {
	package { $zabbix::params::server_package:
		ensure	=> $zabbix::server::ensure
	}
}