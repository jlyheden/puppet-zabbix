/*
 * ==:Class zabbix::server::config
 * 
 * Manages the Zabbix server config
 */
class zabbix::server::config {

	# Some defaults
 	File {
 		owner	=> root,
 		group	=> root,
 		require	=> Class["zabbix::server::package"]
 	}

	#if !defined(File[$zabbix::params::config_dir]) {
	# 	file { $zabbix::params::config_dir:
	# 		ensure	=> $zabbix::server::ensure ? {
	# 			present	=> directory,
	# 			default	=> undef
	# 		},
	# 		mode	=> 755
	# 	}
	#}

	#file { [ $zabbix::params::server_config_alertd_dir, $zabbix::params::server_config_externalscripts_dir]:
	# 		ensure	=> $zabbix::server::ensure ? {
	# 			present	=> directory,
	# 			default	=> undef
	# 		},
	# 		mode	=> 755,
	# 		require	=> File[$zabbix::params::config_dir]
	#}

	realize ( File[$zabbix::params::config_dir], File[$zabbix::params::alertd_dir], File[$zabbix::params::externalscripts_dir] )

	file { $zabbix::params::server_config_file:
		ensure	=> $zabbix::server::ensure,
		mode	=> 640,
		group	=> $zabbix::params::group,
		notify	=> Class["zabbix::server::service"],
		content	=> template("zabbix/server/$::lsbdistcodename/zabbix_server.conf.erb")
	}

 	file { [$zabbix::params::server_pid_dir, $zabbix::params::server_log_dir]:
 		ensure	=> $zabbix::server::ensure ? {
 			present	=> directory,
 			default	=> absent
 		},
 		owner	=> $zabbix::params::user,
 		group	=> $zabbix::params::group,
 		mode	=> 755
 	}

}