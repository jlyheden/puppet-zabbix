/*
 * ==:Class zabbix::agent::config
 * 
 * Manages the Zabbix agent config
 */
 class zabbix::agent::config {
 
	# Some defaults
 	File {
 		owner	=> root,
 		group	=> root,
 		require	=> Class["zabbix::agent::package"]
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
 	
 	file { $zabbix::params::agent_config_include:
 		ensure	=> $zabbix::agent::ensure ? {
 			present	=> directory,
 			default	=> absent
 		},
 		mode	=> 755,
 		force	=> true,
 		purge	=> true,
 		notify	=> Class["zabbix::agent::service"],
 		require	=> File[$zabbix::params::config_dir]
 	}
 
 	file { $zabbix::params::agent_config_file:
 		ensure	=> $zabbix::agent::ensure,
 		mode	=> 644,
 		notify	=> Class["zabbix::agent::service"],
 		content	=> template("zabbix/agent/$::lsbdistcodename/zabbix_agentd.conf.erb")
 	}
 
 	file { [$zabbix::params::agent_pid_dir, $zabbix::params::agent_log_dir]:
 		ensure	=> $zabbix::agent::ensure ? {
 			present	=> directory,
 			default	=> absent
 		},
 		owner	=> $zabbix::params::user,
 		group	=> $zabbix::params::group,
 		mode	=> 755
 	}
 
 }