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

  def zbxapi_get_ids_from_name(name,token)
    host = token.host.get( { 'output' => 'shorten', 'filter' => { 'host' => name } } )
    return nil if host.length == 0
    return host
  end
end
