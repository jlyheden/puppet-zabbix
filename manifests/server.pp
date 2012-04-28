/*
 * ==:Class zabbix::server
 * 
 * Manages Zabbix server
 * 
 * @params
 * @ensure				String value present or absent
 * @version				String value Zabbix version
 * @port				Integer value listen port
 * @dbhost				String value MySQL db server
 * @dbname				String value MySQL db name
 * @dbuser				String value MySQL db user
 * @dbpassword			String value MySQL db password
 * @nodeid				Integer value node id
 * @startpollers		Integer value number of pollers
 * @startipmipollers	Integer value number of ipmipollers
 * @startpollersunreachable	Integer value number of unreachable pollers
 * @starttrappers		Integer value number of trapper pollers
 * @startpingers		Integer value number of ping pollers
 * @startdiscoverers	Integer value number of discover pollers
 * @starthttppollers	Integer value number of web check pollers
 * @housekeepingfrequency	Integer value interval of housekeeping in hours, 0 means disabled
 * @senderfrequency		Integer value sender frequency
 * @housekeeping		Boolean value if house keeping should be enabled
 * @debuglevel			Integer value debuglevel
 * @timeout				Integer value timeout in seconds for item monitoring
 * @trappertimeout		Integer value timeout in seconds for trapper item monitoring
 * @unreachableperiod	Integer value unreachableperiod
 * @unavailabledelay	Integer value unavailabledelay
 * @logfilesize			Integer value size in megabytes until log file is rotated
 * @tmpdir				String value path to tmp directory
 * @pingerfrequency		Integer value pingerfrequency
 * @cachesize			String value zabbix server cache size, specifiy metric
 */
class zabbix::server ( $ensure = "present",
                       $version = $zabbix::params::version,
	                   $port = $zabbix::params::server_port,
	                   $dbhost,
	                   $dbname,
	                   $dbuser,
	                   $dbpassword,
	                   $dbrootpassword = "",
	                   $manage_db = $zabbix::params::server_manage_db,
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
	include zabbix::server::config
	include zabbix::server::package
	include zabbix::server::service
}