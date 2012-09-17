# == Class zabbix::server
#
# Installs, configures and manages the Zabbix server service
#
# === Parameters
#
# [*port*]
#   Optional. Listening port for Zabbix Server. Default: 10051
#
# [*dbhost*]
#   Required. IP or hostname of database server.
#
# [*dbname*]
#   Optional. Name of database. Default: zabbix
#
# [*dbuser*]
#   Optional. Name of database user. Default: zabbix
#
# [*dbpassword*]
#   Required. Password for database user.
#
# [*dbrootpassword*]
#   Required if managedb is enabled. MySQL root password.
#
# [*managedb*]
#   Optional. If zabbix-server installation should pull mysql-server from pkg repository and install it. Note this might conflict with other MySQL modules. Default: false
#
# [*nodeid*]
#   Optional. NodeID in distributed setup. Default: 0
#
# [*startpollers*]
#   Optional. Number of pre-forked instances of poller. Default: 5
#
# [*startipmipollers*]
#   Optional. Number of pre-forked instances of IPMI poller. Default: 0
#
# [*startpollersunreachable*]
#   Optional. Number of pre-forked instances of poller for unreachable hosts (including IPMI). Default: 1
#
# [*starttrappers*]
#   Optional. Number of pre-forked instances of trapper. Default: 5
#
# [*startpingers*]
#   Optional. Number of pre-forked instances of pinger. Default: 1
#
# [*startdiscovers*]
#   Optional. Number of pre-forked instances of discover. Default: 1
#
# [*starthttppollers*]
#   Optional. Number of pre-forked instances of web check. Default: 1
#
# [*housekeepingfrequency*]
#   Optional. Interval in hours, at which housekeeping will be performed. Default: 1
#
# [*senderfrequency*]
#   Optional. Interval in seconds, at which Zabbix will retry to send unsent alerts. Default: 30
#
# [*housekeeping*]
#   Optional. Boolean if housekeeping should be enabled. Default: true
#
# [*debuglevel*]
#   Optional. Numerical log verbosity. Default: 3
#
# [*timeout*]
#   Optional. Timeout in seconds, waiting for agent, SNMP or external check. Default: 5
#
# [*trappertimeout*]
#   Optional. Timeout in seconds, how many seconds trapper may process new data. Default: 5
#
# [*unreachableperiod*]
#   Optional. Period in seconds, after how long time a host is set as unreachable. Default: 45
#
# [*unavailabledelay*]
#   Optional. Delay in seconds, how often host is checked for avaibility during the unavailability period. Default: 60
#
# [*logfilesize*]
#   Optional. Size in MB after which the daemon log file will be rotated. Default: 10
#
# [*tmpdir*]
#   Optional. Path to temp directory. Default: /tmp
#
# [*pingerfrequency*]
#   Optional. Frequency in seconds. Default: 60
#
# [*cachesize*]
#   Optional. Size of configuration cache in bytes. Supports metric prefixes. Default: 8M
#
# [*autoupgrade*]
#   Optional. Boolean to automatically install latest version or pin to specific version. Default: false
#
# [*custom_template*]
#   Optional. Path to template file to use in place for zabbix_server.conf. Default: undef
#
# === Requires
#
# === Sample Usage
#
# class { 'zabbix-server':
#   dbhost          => 'localhost',
#   dbpassword      => 'secretzabbixpw'
#   dbrootpassword  => 'omgmysqlrootpw',
#   managedb        => true
# }
#
class zabbix::server ( $port = $zabbix::params::server_port,
                       $dbhost,
                       $dbname = $zabbix::params::server_dbname,
                       $dbuser = $zabbix::params::server_dbuser,
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
                       $autoupgrade = $zabbix::params::server_autoupgrade,
                       $custom_template = undef ) inherits zabbix {

    include zabbix::params

    case $autoupgrade {
      true: {
        Package['zabbix/server/package'] { ensure => latest }
      }
      /[0-9]+[0-9\.\-\_\:a-zA-Z]/: {
        Package['zabbix/server/package'] { ensure => $autoupgrade }
      }
      false: {
        # Do nothing
      }
      default: {
        warning('Parameter autoupgrade only supports values: true, false or version-number')
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
