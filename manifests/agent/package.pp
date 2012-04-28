/*
 * ==:Class zabbix::agent::package
 * 
 * Manages the Zabbix agent package
 */
 class zabbix::agent::package {
 	package { $zabbix::params::agent_package:
 		ensure	=> $zabbix::agent::ensure
 	}
 }