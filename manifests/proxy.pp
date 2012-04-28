/*
 * ==:Class zabbix::server::proxy
 * 
 * Manages Zabbix proxy
 */
class zabbix::proxy ( $ensure = "present",
                      $version = $zabbix::params::version,
                      $port = $zabbix::params::proxy_port,
                      $server_host,
	                  $server_port = $zabbix::params::server_port,
	                  $dbhost,
	                  $dbname,
	                  $dbuser,
	                  $dbpassword,
	                  $dbrootpassword = "",
	                  $manage_db = $zabbix::params::proxy_manage_db,
	                  $heartbeatfrequency = $zabbix::params::proxy_heartbeatfrequency,
	                  $startpollers = $zabbix::params::proxy_startpollers,
	                  $startipmipollers = $zabbix::params::proxy_startipmipollers,
	                  $startpollersunreachable = $zabbix::params::proxy_startpollersunreachable,
	                  $starttrappers = $zabbix::params::proxy_starttrappers,
	                  $startpingers = $zabbix::params::proxy_startpingers,
	                  $startdiscoverers = $zabbix::params::proxy_startdiscoverers,
	                  $starthttppollers = $zabbix::params::proxy_starthttppollers,
	                  $housekeepingfrequency = $zabbix::params::proxy_housekeepingfrequency,
	                  $configfrequency = $zabbix::params::proxy_configfrequency,
	                  $senderfrequency = $zabbix::params::proxy_senderfrequency,
	                  $proxylocalbuffer = $zabbix::params::proxy_proxylocalbuffer,
	                  $proxyofflinebuffer = $zabbix::params::proxy_proxyofflinebuffer,
	                  $housekeeping = $zabbix::params::proxy_housekeeping,
	                  $debuglevel = $zabbix::params::proxy_debuglevel,
	                  $timeout = $zabbix::params::proxy_timeout,
	                  $trappertimeout = $zabbix::params::proxy_trappertimeout,
	                  $unreachableperiod = $zabbix::params::proxy_unreachableperiod,
	                  $unavailabledelay = $zabbix::params::proxy_unavailabledelay,
	                  $logfilesize = $zabbix::params::proxy_logfilesize,
	                  $tmpdir = $zabbix::params::proxy_tmpdir,
	                  $pingerfrequency = $zabbix::params::proxy_pingerfrequency,
	                  $cachesize = $zabbix::params::proxy_cachesize ) inherits zabbix::params {
	include zabbix::proxy::package
	include zabbix::proxy::config
	include zabbix::proxy::service
}