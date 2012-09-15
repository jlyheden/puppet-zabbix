# == Class zabbix::agent::absent
#
# Removes the zabbix agent
#
# === Sample usage
#
# include zabbix::agent::absent
#
class zabbix::agent::absent inherits zabbix {
    Package['zabbix/agent/package'] {
      ensure => absent,
    }
    File<| tag == agent and tag != global |> { ensure => absent, notify => undef }

    realize(Package['zabbix/agent/package'])
}
