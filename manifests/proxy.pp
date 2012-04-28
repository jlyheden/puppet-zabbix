/*
 * ==:Class zabbix::server::proxy
 * 
 * Installs, configures and manages the Zabbix proxy service
 * 
 * @params
 * @ensure				String value present or absent
 * @nodename            String value name of this Zabbix proxy node
 * @version				String value Zabbix version
 * @port				Integer value listen port
 * @server_host		    String value ip address or hostname of zabbix server
 * @server_port		    Integer value port number of zabbix server
 * @dbhost				String value MySQL db server
 * @dbname				String value MySQL db name
 * @dbuser				String value MySQL db user
 * @dbpassword			String value MySQL db password
 * @dbrootpassword      String value MySQL db root password if using preseeded installation
 * @manage_db           Boolean value preseeded installation
 * @heartbeatfrequency  Integer value frequency of heartbeat messages in seconds
 * @startpollers		Integer value number of pre-forked instances of pollers
 * @startipmipollers	Integer value number of pre-forked instances of IPMI pollers
 * @startpollersunreachable	Integer value number of pre-forked instances of pollers for unreachable hosts (including IPMI)
 * @starttrappers		Integer value number of pre-forked instances of trappers
 * @startpingers		Integer value number of pre-forked instances of ICMP pingers
 * @startdiscoverers	Integer value number of pre-forked instances of discoverers
 * @starthttppollers	Integer value number of web check pollers
 * @housekeepingfrequency	Integer value how often Zabbix will perform housekeeping procedure (in hours)
 * @senderfrequency		Integer value how often Zabbix will try to send unsent alerts (in seconds)
 * @proxylocalbuffer    Integer value proxy will keep data locally for N hours
 * @proxyofflinebuffer  Integer value proxy will keep data for N hours in case if no connectivity with Zabbix Server
 * @debuglevel			Integer value specifies debug level
 * @timeout				Integer value specifies how long we wait for agent, SNMP device or external check (in seconds)
 * @trappertimeout		Integer value specifies how many seconds trapper may spend processing new data.
 * @unreachableperiod	Integer value after how many seconds of unreachability treat a host as unavailable
 * @unavailabledelay	Integer value how often host is checked for availability during the unavailability period, in seconds
 * @logfilesize			Integer value size in megabytes until log file is rotated
 * @tmpdir				String value path to tmp directory
 * @pingerfrequency		Integer value pingerfrequency
 */
class zabbix::proxy ( $ensure = "present",
                      $nodename = $zabbix::params::nodename,
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
	                  $debuglevel = $zabbix::params::proxy_debuglevel,
	                  $timeout = $zabbix::params::proxy_timeout,
	                  $trappertimeout = $zabbix::params::proxy_trappertimeout,
	                  $unreachableperiod = $zabbix::params::proxy_unreachableperiod,
	                  $unavailabledelay = $zabbix::params::proxy_unavailabledelay,
	                  $logfilesize = $zabbix::params::proxy_logfilesize,
	                  $tmpdir = $zabbix::params::proxy_tmpdir,
	                  $pingerfrequency = $zabbix::params::proxy_pingerfrequency ) inherits zabbix::params {
	include zabbix::proxy::package
	include zabbix::proxy::config
	include zabbix::proxy::service
}