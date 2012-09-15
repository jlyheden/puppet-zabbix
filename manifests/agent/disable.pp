# == Class zabbix::agent::disable
#
# Disables the zabbix agent
#
# === Sample usage
#
# include zabbix::agent::disable
#
class zabbix::agent::disable inherits zabbix {
    Service['zabbix/agent/service'] {
        ensure => stopped,
        enable => false
    }
}
