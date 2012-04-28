/*
 * ==:Class zabbix::server::proxy
 * 
 * Manages Zabbix proxy
 */
class zabbix::proxy ( $ensure = "present",
                      $version = $zabbix::params::version,
	                  $port = $zabbix::params::server_port,
	                  $dbhost,
	                  $dbname,
	                  $dbuser,
	                  $dbpassword,
	                  $dbrootpassword = "",
	                  $manage_db = $zabbix::params::proxy_manage_db,
	                  $nodeid = $zabbix::params::server_nodeid,
	                  $startpollers = $zabbix::params::server_startpollers,
	                  $startipmipollers = $zabbix::params::server_startipmipollers,
	                  $startpollersunreachable = $zabbix::params::server_startpollersunreachable,
	                  $starttrappers = $zabbix::params::server_starttrappers,
	                  $startpingers = $zabbix::params::server_startpingers,
	                  $startdiscoverers = $zabbix::params::server_startdiscoverers,
	                  $starthttppollers = $zabbix::params::server_starthttppollers,
	                  $housekeepingfrequency = $zabbix::params::server_housekeepingfrequency,
	                  $senderfrequency = $zabbix::params::server_senderfrequency,
	                  $housekeeping = $zabbix::params::server_housekeeping,
	                  $debuglevel = $zabbix::params::server_debuglevel,
	                  $timeout = $zabbix::params::server_timeout,
	                  $trappertimeout = $zabbix::params::server_trappertimeout,
	                  $unreachableperiod = $zabbix::params::server_unreachableperiod,
	                  $unavailabledelay = $zabbix::params::server_unavailabledelay,
	                  $logfilesize = $zabbix::params::server_logfilesize,
	                  $tmpdir = $zabbix::params::server_tmpdir,
	                  $pingerfrequency = $zabbix::params::server_pingerfrequency,
	                  $cachesize = $zabbix::params::server_cachesize ) inherits zabbix::params {
	include zabbix::proxy::package
	include zabbix::proxy::config
	include zabbix::proxy::service
}