# == Class zabbix::frontend
#
# Installs, configures and manages the Zabbix PHP frontend service.
# Note, by default (at least with the Debian package) the Zabbix frontend
# package will pull Apache2 from the APT repository. If you already have
# another webserver installed satifying the 'httpd' dependency it will
# settle for that. Regardless, management of web server settings are
# outside the scope of this module, at the very least a 'softmanage_apache'
# parameter is available that runs an Exec to reload Apache in case of
# config changes.
#
# === Parameters
#
# [*server_host*]
#   Required. IP address or hostname of server running Zabbix server.
#
# [*server_port*]
#   Optional. Port of Zabbix server. Default: 10051
#
# [*dbhost*]
#   Required. IP address or hostname of MySQL server.
#
# [*dbport*]
#   Optional. Port number of MySQL service. Default: 3306
#
# [*dbname*]
#   Optional. MySQL database name. Default: zabbix
#
# [*dbuser*]
#   Optional. MySQL database user. Default: zabbix
#
# [*dbpass*]
#   Required. MySQL database user password.
#
# [*dbrootpassword*]
#   Required if managedb is enabled. MySQL root password.
#
# [*managedb*]
#   Optional. If zabbix-frontend installation should pull mysql-server from pkg repository and install it. Note this might conflict with other MySQL modules. Default: false
#
# [*autoupgrade*]
#   Optional. Boolean to automatically install latest version or pin to specific version. Default: false
#
# [*softmanage_apache*]
#   Optional. Boolean if Apache should be reloaded via shell Execs on config changes. Default: false
#
# === Requires
#
# === Sample Usage
#
# class { 'zabbix::frontend':
#   server_host         => 'zabbix.localdomain',
#   dbhost              => 'mydb.localdomain',
#   dbpassword          => 'secret',
#   dbrootpassword      => 'omgmysqlrootpw',
#   managedb            => true,
#   softmanage_apache   => true
# }
#
class zabbix::frontend ( $server_host,
 	                     $server_port = $zabbix::params::server_port,
	                     $dbhost,
	                     $dbport = $zabbix::params::frontend_dbport,
	                     $dbname = $zabbix::params::server_dbname,
	                     $dbuser = $zabbix::params::server_dbuser,
	                     $dbpassword,
	                     $dbrootpassword = undef,
	                     $managedb = $zabbix::params::frontend_managedb,
	                     $autoupgrade = $zabbix::params::frontend_autoupgrade,
	                     $softmanage_apache = false) inherits zabbix::params {

    include zabbix::params

    exec { 'soft-reload-apache':
        path => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
        command => $zabbix::params::frontend_apacheservice_reload_cmd,
        refreshonly => true
    }

    case $autoupgrade {
      true: {
        Package['zabbix/frontend/package'] { ensure => latest }
      }
      /[0-9]+[0-9\.\-\_\:a-zA-Z]/: {
        Package['zabbix/frontend/package'] { ensure => $autoupgrade }
      }
      false: {
        # Do nothing
      }
      default: {
        warning('Parameter autoupgrade only supports values: true, false or version-number')
      }
    }

    File['zabbix/frontend/config/file'] {
      content => template('zabbix/server/zabbix_server.conf.erb'),
      notify => $softmanage_apache ? {
          true      => Exec['soft-reload-apache'],
          default   => undef
      }
    }

    if $managedb == true {
      if $dbrootpassword == undef {
        fail('You must set dbrootpassword when managedb is set to true')
      }
      File['mysql/preseed'] { ensure => present, content => template('zabbix/mysql/preseed.erb'), before  => Package['mysql/packages'] }
      File['zabbix/frontend/preseed'] { ensure => present, content => template('zabbix/frontend/preseed.erb') }
      Package['mysql/packages'] { before +> Package['zabbix/frontend/package'] }
      Package['zabbix/frontend/package'] { responsefile => $zabbix::params::frontend_preseed_file }
      realize(Package['mysql/packages'])
    }

    File <| tag == frontend |>
    Package <| title == 'zabbix/frontend/package' |>

}