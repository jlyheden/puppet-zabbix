class zabbix::agent::disable inherits zabbix::agent {
    Service["zabbix/agent/service"] {
        ensure => undef,
        enable => false
    }
}