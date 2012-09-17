# == Class zabbix::server
#
# Installs, configures and manages the Zabbix server service
#
# === Parameters
#
# [*nodename*]
#   Optional. Name of this Zabbix proxy node. Default: $::hostname
#
# [*port*]
#   Optional. Listening port for Zabbix Server. Default: 10051
#
# [*server_host*]
#   Required. IP address or hostname of Zabbix server.
#
# [*server_port*]
#   Optional. Port of Zabbix server. Default: 10051
#
# [*dbhost*]
#   Required. IP address or hostname of database server.
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
#   Optional. If zabbix-proxy installation should pull mysql-server from pkg repository and install it. Note this might conflict with other MySQL modules. Default: false
#
# [*heartbeatfrequency*]
#   Optional. Frequency in seconds to send heartbeat messages. Default: XXXXXXXX
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
# [*proxylocalbuffer*]
#   Optional. Number of hours, in which proxy will buffer data. Default: XXXXX
#
# [*proxyofflinebuffer*]
#   Optional. Number of hours, in which proxy will buffer data in case of unavailable server. Default: XXXXX
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
# [*autoupgrade*]
#   Optional. Boolean to automatically install latest version or pin to specific version. Default: false
#
# [*custom_template*]
#   Optional. Path to template file to use in place for zabbix_proxy.conf. Default: undef
#
# === Requires
#
# === Sample Usage
#
# class { 'zabbix-proxy':
#   server_host     => 'zabbix-server.localdomain',
#   dbhost          => 'localhost',
#   dbpassword      => 'secretzabbixpw'
#   dbrootpassword  => 'omgmysqlrootpw',
#   autoupgrade     => true
# }
#
class zabbix::proxy ( $nodename = $zabbix::params::nodename,
                      $port = $zabbix::params::proxy_port,
                      $server_host,
                      $server_port = $zabbix::params::server_port,
                      $dbhost,
                      $dbname,
                      $dbuser,
                      $dbpassword,
                      $dbrootpassword = undef,
                      $managedb = $zabbix::params::proxy_manage_db,
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
                      $pingerfrequency = $zabbix::params::proxy_pingerfrequency,
                      $autoupgrade = false,
                      $custom_template = undef ) inherits zabbix {

    include zabbix::params

    case $autoupgrade {
      true: {
        Package['zabbix/proxy/package'] { ensure => latest }
      }
      /[0-9]+[0-9\.\-\_\:a-zA-Z]/: {
        Package['zabbix/proxy/package'] { ensure => $autoupgrade }
      }
      false: {
        # Do nothing
      }
      default: {
        warning('Parameter autoupgrade only supports values: true, false or version-number')
      }
    }

    File['zabbix/proxy/config/file'] {
      content => $custom_template ? {
        undef   => template('zabbix/proxy/zabbix_proxy.conf.erb'),
        default => template($custom_template),
      }
    }

    if $managedb == true {
      if $dbrootpassword == undef {
        fail('You must set dbrootpassword when managedb is set to true')
      }
      File['mysql/preseed'] { ensure => present, content => template('zabbix/mysql/preseed.erb'), before  => Package['mysql/packages'] }
      File['zabbix/proxy/preseed'] { ensure => present, content => template('zabbix/proxy/preseed.erb') }
      Package['mysql/packages'] { before +> Package['zabbix/proxy/package'] }
      Package['zabbix/proxy/package'] { responsefile => $zabbix::params::proxy_preseed_file }
      realize(Package['mysql/packages'])
    }

    File <| tag == proxy |>
    Group <| title == 'zabbix/group' |> -> User <| title == 'zabbix/user' |> -> Package <| title == 'zabbix/proxy/package' |> -> Service <| title == 'zabbix/proxy/service' |>

}