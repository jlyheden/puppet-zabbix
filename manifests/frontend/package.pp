/*
 * ==:Class zabbix::frontend::package
 * 
 * Manages the Zabbix frontend package 
 */
class zabbix::frontend::package {
	package { $zabbix::params::frontend_package:
		ensure	=> $zabbix::frontend::ensure
	}
}