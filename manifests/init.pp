/*
 * ==:Class zabbix
 * 
 * Base class for Zabbix, must be included
 */
class zabbix inherits zabbix::params {

	# The base config directory is shared between agent, server, frontend and proxy
	# So we realize this resource in each separate config
 	@file { $zabbix::params::config_dir:
 		ensure	=> directory,
 		mode	=> 755
 	}

	# Alert and externalscripts dir is used by both zabbix-proxy and zabbix-server
	@file { [ $zabbix::params::alertd_dir, $zabbix::params::externalscripts_dir]:
	 		ensure	=> directory,
	 		mode	=> 755,
	 		require	=> File[$zabbix::params::config_dir]
	}

}
