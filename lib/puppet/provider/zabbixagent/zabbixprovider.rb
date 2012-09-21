require 'zbxapi'
require File.join(File.dirname(__FILE__), '..', 'zabbixprovider')

Puppet::Type.type(:zabbixagent).provide :zabbixprovider, :parent => Puppet::Provider::Zabbixprovider do
  desc "Manages a Zabbix agent"

  def exists?
    token = zbxapi_login(@resource)
    return true if token.host.get( { 'output' => 'shorten', 'filter' => { 'host' => @resource[:name] } } ).length > 0
    return false
  end

  def create
    token = zbxapi_login(@resource)
    create_hash = {}
    create_hash['host'] = @resource[:name]
    create_hash['ip'] = @resource[:ip]
    create_hash['dns'] = @resource[:dns] unless @resource == false
    create_hash['useip'] = 1
    create_hash['port'] = @resource[:port]
    create_hash['ipmi_privilege'] = 2 # not sure why this is needed
    create_hash['useipmi'] = zabbix_boolean(@resource[:ipmi])
    create_hash['snmp'] = zabbix_boolean(@resource[:snmp])
    create_hash['groups'] = [ { 'groupid' => 2 } ]
    token.host.create(create_hash)
  end

  def destroy
    token = zbxapi_login(@resource)
    nodeids = zbxapi_get_id_from_name(@resource[:name],token)
    token.host.delete(nodeids)
  end

end
