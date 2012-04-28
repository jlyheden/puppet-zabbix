/*
 * ==:Class zabbix::agent::service
 * 
 * Manages the Zabbix agent service
 */
 class zabbix::agent::service {
 	service { $zabbix::params::agent_service:
 		ensure	=> $zabbix::agent::ensure ? {
 			present	=> running,
 			absent	=> stopped,
 			default	=> undef
 		},
 		enable	=> $zabbix::agent::ensure ? {
 			present	=> true,
 			absent	=> false,
 			default	=> false
 		},
 		hasstatus => $zabbix::params::agent_init_has_status,
 		require	=> Class["zabbix::agent::package"]
 	}
 }