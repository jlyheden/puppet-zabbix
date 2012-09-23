require 'zbxapi'

class Puppet::Provider::Zabbixprovider < Puppet::Provider

  def zabbix_boolean(b)
    return 1 if b == true
    return 0 if b == false
  end

  def zbxapi_login(arguments)
    token = ZabbixAPI.new(arguments[:apiurl])
    token.login(arguments[:apiuser],arguments[:apipassword])
    return token
  end

  def zbxapi_get_host_from_name(name,output,token)
    host = token.host.get( { 'output' => output, 'filter' => { 'host' => [ name ] } } )
    return host if host.length > 0
    return []
  end

  def zbxapi_get_host_groups_from_name(name,output,token)
    host = token.host.get( { 'select_groups' => output, 'filter' => { 'host' => [ name ] } } )
    return host[0]['groups'] if host.length > 0 and host[0].has_key? 'groups'
    return []
  end

  def zbxapi_get_group_from_name(name,output,token)
    group = token.hostgroup.get( { 'output' => output, 'filter' => { 'name' => [ name ] } } )
    return group[0] if group.length > 0
    return []
  end

end
