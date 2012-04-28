/*
 * ==:Class zabbix::server::service
 * 
 * Manages the Zabbix server service
 */
class zabbix::server::service {
 	service { $zabbix::params::server_service:
 		ensure	=> $zabbix::server::ensure ? {
 			present	=> running,
 			absent	=> stopped,
 			default	=> undef
 		},
 		enable	=> $zabbix::server::ensure ? {
 			present	=> true,
 			absent	=> false,
 			default	=> false
 		},
 		hasstatus => $zabbix::params::server_init_has_status,
 		require	=> Class["zabbix::server::package"]
 	}
}