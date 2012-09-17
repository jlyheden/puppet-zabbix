# == Class zabbix::proxy::disable
#
# Disables the zabbix proxy
#
# === Sample usage
#
# include zabbix::proxy::disable
#
class zabbix::proxy::disable inherits zabbix {
    Service['zabbix/proxy/service'] {
        ensure => stopped,
        enable => false
    }
}
