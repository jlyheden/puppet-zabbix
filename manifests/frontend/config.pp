/*
 * ==:Class zabbix::frontend::config
 * 
 * Manages the Zabbix frontend config
 */
 class zabbix::frontend::config {
 
	# Some defaults
 	File {
 		owner	=> root,
 		group	=> root,
 		require	=> Class["zabbix::frontend::package"]
 	}

	#if !defined(File[$zabbix::params::config_dir]) {
	# 	file { $zabbix::params::config_dir:
	# 		ensure	=> $zabbix::agent::ensure ? {
	# 			present	=> directory,
	# 			default	=> undef
	# 		},
	# 		mode	=> 755
	# 	}
	#}

	realize (File[$zabbix::params::config_dir])
 
 	file { $zabbix::params::frontend_config_file:
 		ensure	=> $zabbix::frontend::ensure,
 		mode	=> 644,
 		notify	=> Service[$zabbix::frontend::webserver],
 		content	=> template("zabbix/frontend/${zabbix::agent::version}/dbconfig.php.erb")
 	}
  
 }