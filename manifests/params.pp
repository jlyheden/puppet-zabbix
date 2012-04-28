/*
 * ==:Class zabbix::params
 * 
 * Parameter class with default values
 */
 class zabbix::params {
 	
 	# OS dependent settings
 	case $::operatingsystem {
 		ubuntu: {
			# Global settings
 			$version = "1.8"
 			$alertd_dir = "${config_dir}/alert.d"
 			$externalscripts_dir = "${config_dir}/externalscripts"
 			$user = "zabbix"
 			$group = "zabbix"
 			$config_dir = "/etc/zabbix"
 			$agent_init_has_status = false
 			$server_init_has_status = false
 			$proxy_init_has_status = false
 			$mysql_package = "mysql-server-5.1"
 			
 			# Agent settings
 			$agent_package = "zabbix-agent"
 			$agent_service = "zabbix-agent"
 			$agent_config_file = "${config_dir}/zabbix_agentd.conf"
 			$agent_config_include = "${config_dir}/include.d"
 			$agent_pid_dir = "/var/run/zabbix-agent"
 			$agent_log_dir = "/var/log/zabbix-agent"
 			
 			# Server settings
 			$server_package = "zabbix-server-mysql"
 			$server_php_package = "zabbix-frontend-php"
 			$server_config_file = "${config_dir}/zabbix_server.conf"
 			$server_php_config_file = "${config_dir}/dbconfig.php"
 			$server_pid_dir = "/var/run/zabbix-server"
 			$server_log_dir = "/var/log/zabbix-server"
 			$server_service = "zabbix-server"
 			$server_manage_db = false
 			
 			# Proxy settings
 			$proxy_package = "zabbix-proxy-mysql"
 			$proxy_config_file = "${config_dir}/zabbix_proxy.conf"
 			$proxy_service = "zabbix-proxy"
 			$proxy_pid_dir = "/var/run/zabbix-proxy"
 			$proxy_log_dir = "/var/log/zabbix-proxy"
 			$proxy_manage_db = false
 			
 			# Frontend settings
 			$frontend_config_file = "${config_dir}/dbconfig.php"
 			$frontend_package = "zabbix-frontend-php"
 			$frontend_webserver = "apache2"
 		}
		default: {
			fail("Operating system $::operatingsystem not supported")
		}
 	}

	# Zabbix frontend defaults
	$frontend_dbport = 0

	# Zabbix agent defaults
	$agent_port = 10050
	$agent_active_mode = true
	$agent_remote_commands = true
	$agent_auto_register = true
	$agent_startagents = 5
	$agent_debuglevel = 3
	$agent_timeout = 3
	
	# Zabbix server defaults	
 	$server_nodeid = 0
 	$server_port = 10051
 	$server_startpollers = 5
 	$server_startipmipollers = 0
 	$server_startpollersunreachable = 1
 	$server_starttrappers = 5
 	$server_startpingers = 1
 	$server_startdiscoverers = 1
 	$server_starthttppollers = 1
 	$server_housekeepingfrequency = 1
 	$server_senderfrequency = 30
 	$server_housekeeping = true
 	$server_debuglevel = 3
 	$server_timeout = 5
 	$server_trappertimeout = 5
 	$server_unreachableperiod = 45
 	$server_unavailabledelay = 60
 	$server_logfilesize = 10
 	$server_tmpdir = "/tmp"
 	$server_pingerfrequency = 60
 	$server_cachesize = "8M"

}