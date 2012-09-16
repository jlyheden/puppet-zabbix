# == Class zabbix::server::disable
#
# Disables the zabbix server
#
# === Sample usage
#
# include zabbix::server::disable
#
class zabbix::server::disable inherits zabbix {
    Service['zabbix/server/service'] {
        ensure => stopped,
        enable => false
    }
}
