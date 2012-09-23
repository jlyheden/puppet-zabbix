require File.join(File.dirname(__FILE__), '..', 'zabbixprovider')

Puppet::Type.type(:zabbixagentmacro).provide :zabbixprovider, :parent => Puppet::Provider::Zabbixprovider do
  desc "Manages a Zabbix agent macro"

  def exists?
    token = zbxapi_login(@resource)
    zbxapi_get_host_macros_from_name(@resource[:nodename], 'extend', token).any? { |h| h['macro'] == '{$' + @resource[:macro] + '}' and h['value'] == @resource[:value] }
  end

  def create
    macros_to_add = []
    token = zbxapi_login(@resource)
    host = zbxapi_get_host_from_name(@resource[:nodename], 'shorten', token)[0]
    macros = zbxapi_get_host_macros_from_name(@resource[:nodename], 'extend', token)
    macros.each { |m| macros_to_add << { 'macro' => m['macro'], 'value' => m['value'] } unless m['macro'] == '{$' + @resource[:macro] + '}' }
    macros_to_add << { 'macro' => '{$' + @resource[:macro] + '}', 'value' => @resource[:value] }
    token.host.update( { 'hostid' => host['hostid'], 'macros' => macros_to_add } )
  end

  def destroy
    macros_to_add = []
    token = zbxapi_login(@resource)
    host = zbxapi_get_host_from_name(@resource[:nodename], 'shorten', token)[0]
    macros = zbxapi_get_host_macros_from_name(@resource[:nodename], 'extend', token)
    macros.each { |m| macros_to_add << { 'macro' => m['macro'], 'value' => m['value'] } unless m['macro'] == '{$' + @resource[:macro] + '}' }
    token.host.update( { 'hostid' => host['hostid'], 'macros' => macros_to_add } )
  end

end
