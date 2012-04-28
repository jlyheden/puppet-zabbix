/*
 * ==:Class zabbix::proxy::config
 * 
 * Manages the Zabbix proxy config
 */
class zabbix::proxy::config {

	# Some defaults
 	File {
 		owner	=> root,
 		group	=> root,
 		require	=> Class["zabbix::proxy::package"]
 	}

	realize ( File[$zabbix::params::config_dir], File[$zabbix::params::alertd_dir], File[$zabbix::params::externalscripts_dir] )

	file { $zabbix::params::proxy_config_file:
		ensure	=> $zabbix::proxy::ensure,
		mode	=> 640,
		group	=> $zabbix::params::group,
		notify	=> Class["zabbix::proxy::service"],
		content	=> template("zabbix/proxy/${zabbix::proxy::version}/zabbix_proxy.conf.erb")
	}

 	file { [$zabbix::params::proxy_pid_dir, $zabbix::params::proxy_log_dir]:
 		ensure	=> $zabbix::proxy::ensure ? {
 			present	=> directory,
 			default	=> absent
 		},
 		owner	=> $zabbix::params::user,
 		group	=> $zabbix::params::group,
 		mode	=> 755
 	}

}