/*
 * ==:Class zabbix::proxy::package
 * 
 * Manages the Zabbix proxy package 
 */
class zabbix::proxy::package {
	
	if $zabbix::proxy::manage_db == true {
		case $::lsbdistid {
			/Debian|Ubuntu/: {
				file { "/var/local/zabbix_proxy.preseed":
					ensure	=> $zabbix::proxy::ensure,
					mode	=> 600,
					content	=> template("zabbix/proxy/${zabbix::proxy::version}/preseed.erb"),
					backup	=> false
				}
				Package {
					responsefile => "/var/local/zabbix_proxy.preseed",
					require => File["/var/local/zabbix_proxy.preseed"]
				}
			}
			default: {
				fail("$::lsbdistid is not supported for preseeded installations")
			}
		}
	}

	package { $zabbix::params::proxy_package:
		ensure	=> $zabbix::proxy::ensure
	}
}