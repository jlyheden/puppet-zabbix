# == Class zabbix::server::absent
#
# Removes the zabbix server
#
# === Sample usage
#
# include zabbix::server::absent
#
class zabbix::server::absent inherits zabbix {
    Package['zabbix/server/package'] {
      ensure => absent,
      responsefile => undef,
    }
    File<| tag == agent and tag != global |> { ensure => absent, notify => undef }

    realize(Package['zabbix/server/package'])
}
