/*
 * ==:Class zabbix::server
 * 
 * Installs, configures and manages the Zabbix server service
 * 
 * @params
 * @ensure				String value present or absent
 * @version				String value Zabbix version
 * @port				Integer value listen port
 * @dbhost				String value MySQL db server
 * @dbname				String value MySQL db name
 * @dbuser				String value MySQL db user
 * @dbpassword			String value MySQL db password
 * @dbrootpassword      String value MySQL db root password if using preseeded installation
 * @manage_db           Boolean value preseeded installation
 * @nodeid				Integer value unique NodeID in distributed setup
 * @startpollers		Integer value number of pre-forked instances of pollers
 * @startipmipollers	Integer value number of pre-forked instances of IPMI pollers
 * @startpollersunreachable	Integer value number of pre-forked instances of pollers for unreachable hosts (including IPMI)
 * @starttrappers		Integer value number of pre-forked instances of trappers
 * @startpingers		Integer value number of pre-forked instances of ICMP pingers
 * @startdiscoverers	Integer value number of pre-forked instances of discoverers
 * @starthttppollers	Integer value number of pre-forked instances of HTTP pollers
 * @housekeepingfrequency	Integer value how often Zabbix will perform housekeeping procedure (in hours)
 * @senderfrequency		Integer value how often Zabbix will try to send unsent alerts (in seconds)
 * @housekeeping		Boolean value if house keeping should be enabled
 * @debuglevel			Integer value debuglevel
 * @timeout				Integer value specifies how long we wait for agent, SNMP device or external check (in seconds)
 * @trappertimeout		Integer value specifies how many seconds trapper may spend processing new data
 * @unreachableperiod	Integer value after how many seconds of unreachability treat a host as unavailable
 * @unavailabledelay	Integer value how often host is checked for availability during the unavailability period, in seconds
 * @logfilesize			Integer value size in megabytes until log file is rotated
 * @tmpdir				String value path to tmp directory
 * @pingerfrequency		Integer value pingerfrequency
 * @cachesize			String value size of configuration cache, in bytes (1K, 1M, 1G etc)
 * @autoupgrade   Boolean, version or 
 */
class zabbix::server ( $ensure = "present",
                       $version = $zabbix::params::version,
                       $port = $zabbix::params::server_port,
                       $dbhost,
                       $dbname,
                       $dbuser,
                       $dbpassword,
                       $dbrootpassword = undef,
                       $managedb = $zabbix::params::server_managedb,
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
                       $cachesize = $zabbix::params::server_cachesize,
                       $autoupgrade = undef,
                       $custom_template = undef
 ) inherits zabbix {

    include zabbix::params

    case $autoupgrade {
      latest: {
        Package['zabbix/server/package'] { ensure => latest }
      }
      /[0-9]+[0-9\.\-\_\:a-zA-Z]/: {
        Package['zabbix/server/package'] { ensure => $autoupgrade }
      }
      undef: {
        # Do nothing
      }
      default: {
        warning('Parameter ensure_version only supports values: latest, version-number or undef')
      }
    }

    File['zabbix/server/config/file'] {
      content => $custom_template ? {
        undef   => template('zabbix/server/zabbix_server.conf.erb'),
        default => template($custom_template),
      }
    }

    if $managedb == true {
      if $dbrootpassword == undef {
        fail('You must set dbrootpassword when managedb is set to true')
      }
      File['mysql/preseed'] { ensure => present, content => template('zabbix/mysql/preseed.erb'), before  => Package['mysql/packages'] }
      File['zabbix/server/preseed'] { ensure => present, content => template('zabbix/server/preseed.erb') }
      Package['mysql/packages'] { before +> Package['zabbix/server/package'] }
      Package['zabbix/server/package'] { responsefile => $zabbix::params::server_preseed_file }
      realize(Package['mysql/packages'])
    }

    File <| tag == server |>
    Group <| title == 'zabbix/group' |> -> User <| title == 'zabbix/user' |> -> Package <| title == 'zabbix/server/package' |> -> Service <| title == 'zabbix/server/service' |>

}
