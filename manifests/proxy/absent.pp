# == Class zabbix::proxy::absent
#
# Removes the zabbix proxy
#
# === Sample usage
#
# include zabbix::proxy::absent
#
class zabbix::proxy::absent inherits zabbix {
    Package['zabbix/proxy/package'] {
      ensure => absent,
      responsefile => undef,
    }
    File<| tag == proxy and tag != global |> { ensure => absent, notify => undef }

    realize(Package['zabbix/proxy/package'])
}
