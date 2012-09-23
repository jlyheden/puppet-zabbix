require File.join(File.dirname(__FILE__), '..', 'zabbixprovider')

Puppet::Type.type(:zabbixagentgroup).provide :zabbixprovider, :parent => Puppet::Provider::Zabbixprovider do
  desc "Manages a Zabbix agent group membership"

  def get_group_id_from_name(n,token)
    group = token.hostgroup.get( { 'output' => 'shorten', 'filter' => { 'name' => [ n ] } } )
    if group.length == 0
      raise ArgumentError, "Zabbix group %s was not found in Zabbix server" % n
    end
    return group[0]['groupid']
  end

  def get_host_groups_from_name(n,token)
    puts n
    host = token.host.get( { 'select_groups' => 'extend', 'filter' => { 'name' => [ n ] } } )
    puts host[0]['hostid']
    return host[0]
  end

  def exists?
    token = zbxapi_login(@resource)
    return true if get_host_groups_from_name(@resource[:nodename],token)['groups'].any? { |h| h['name'] == @resource[:group] }
    return false
  end

  def create
    token = zbxapi_login(@resource)
    host_group_ids = []
    host = get_host_groups_from_name(@resource[:nodename],token)
    host['groups'].each { |g| host_group_ids << g['groupid'] }
    host_group_ids << get_group_id_from_name(@resource[:group],token)
    token.host.update( { 'hostid' => host['hostid'], 'groups' => host_group_ids } )
  end

  def destroy
    token = zbxapi_login(@resource)
    host_group_ids = []
    host = get_host_groups_from_name(@resource[:nodename],token)
    host['groups'].each { |g| host_group_ids << g['groupid'] }
    group_to_remove = get_group_id_from_name(@resource[:group],token)
    token.host.update( { 'hostid' => host['hostid'], 'groups' => host_group_ids.reject { |gid| gid == group_to_remove } } )
  end

end
