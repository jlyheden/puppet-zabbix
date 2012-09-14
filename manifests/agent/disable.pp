class zabbix::agent::disable inherits zabbix {
    Service['zabbix/agent/service'] {
        ensure => undef,
        enable => false
    }
}