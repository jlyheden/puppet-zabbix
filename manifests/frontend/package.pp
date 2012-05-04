/*
 * ==:Class zabbix::frontend::package
 * 
 * Manages the Zabbix frontend package 
 */
class zabbix::frontend::package {

	if $zabbix::frontend::manage_db == true {
		case $::lsbdistid {
			/Debian|Ubuntu/: {
				file { "/var/local/zabbix_frontend.preseed":
					ensure	=> $zabbix::proxy::ensure,
					mode	=> 600,
					content	=> template("zabbix/frontend/${zabbix::frontend::version}/preseed.erb"),
					backup	=> false
				}
				Package {
					responsefile => "/var/local/zabbix_frontend.preseed",
					require => File["/var/local/zabbix_frontend.preseed"]
				}
			}
			default: {
				fail("$::lsbdistid is not supported for preseeded installations")
			}
		}
	}

	package { $zabbix::params::frontend_package:
		ensure	=> $zabbix::frontend::ensure
	}
}