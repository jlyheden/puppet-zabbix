/*
 * ==:Class zabbix::proxy::service
 * 
 * Manages the Zabbix proxy service
 */
class zabbix::proxy::service {
 	service { $zabbix::params::proxy_service:
 		ensure	=> $zabbix::proxy::ensure ? {
 			present	=> running,
 			absent	=> stopped,
 			default	=> undef
 		},
 		enable	=> $zabbix::proxy::ensure ? {
 			present	=> true,
 			absent	=> false,
 			default	=> false
 		},
 		hasstatus => $zabbix::params::proxy_init_has_status,
 		require	=> Class["zabbix::proxy::package"]
 	}
}