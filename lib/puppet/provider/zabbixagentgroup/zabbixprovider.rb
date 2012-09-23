require File.join(File.dirname(__FILE__), '..', 'zabbixprovider')

Puppet::Type.type(:zabbixagentgroup).provide :zabbixprovider, :parent => Puppet::Provider::Zabbixprovider do
  desc "Manages a Zabbix agent group membership"

  def exists?
    token = zbxapi_login(@resource)
    return true if zbxapi_get_host_groups_from_name(@resource[:nodename], 'extend', token).any? { |h| h['name'] == @resource[:group] }
    return false
  end

  def create
    host_group_ids = []
    token = zbxapi_login(@resource)
    host = zbxapi_get_host_from_name(@resource[:nodename], 'shorten', token)[0]
    groups = zbxapi_get_host_groups_from_name(@resource[:nodename], 'refer', token)
    groups.each { |g| host_group_ids << g['groupid'] }
    host_group_ids << zbxapi_get_group_from_name(@resource[:group], 'shorten', token)
    token.host.update( { 'hostid' => host['hostid'], 'groups' => host_group_ids } )
  end

  def destroy
    host_group_ids = []
    token = zbxapi_login(@resource)
    host = zbxapi_get_host_from_name(@resource[:nodename], 'shorten', token)[0]
    group_to_remove = zbxapi_get_group_from_name(@resource[:group], 'shorten', token)
    groups = zbxapi_get_host_groups_from_name(@resource[:nodename], 'refer', token)
    groups.each { |g| host_group_ids << g['groupid'] unless g['groupid'] == group_to_remove['groupid'] }
    token.host.update( { 'hostid' => host['hostid'], 'groups' => host_group_ids } )
  end

end
