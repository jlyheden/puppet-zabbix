require File.join(File.dirname(__FILE__), '..', 'zabbixprovider')

Puppet::Type.type(:zabbixagenttemplate).provide :zabbixprovider, :parent => Puppet::Provider::Zabbixprovider do

  desc "Manages Zabbix agent template linking"

  def exists?
    token = zbxapi_login(@resource)
    return true if zbxapi_get_host_templates_from_name(@resource[:nodename], 'extend', token).any? { |h| h['host'] == @resource[:template] }
    return false
  end

  def create
    host_template_ids = []
    token = zbxapi_login(@resource)
    host = zbxapi_get_host_from_name(@resource[:nodename], 'shorten', token)[0]
    templates = zbxapi_get_host_templates_from_name(@resource[:nodename], 'refer', token)
    templates.each { |g| host_template_ids << g['templateid'] }
    host_template_ids << zbxapi_get_template_from_name(@resource[:template], 'shorten', token)
    token.host.update( { 'hostid' => host['hostid'], 'templates' => host_template_ids } )
  end

  def destroy
    host_template_ids = []
    token = zbxapi_login(@resource)
    host = zbxapi_get_host_from_name(@resource[:nodename], 'shorten', token)[0]
    template_to_remove = zbxapi_get_template_from_name(@resource[:template], 'shorten', token)
    templates = zbxapi_get_host_templates_from_name(@resource[:nodename], 'refer', token)
    templates.each { |g| host_template_ids << g['templateid'] unless g['templateid'] == template_to_remove['templateid'] }
    token.host.update( { 'hostid' => host['hostid'], 'templates' => host_template_ids } )
  end

  def purge
    token = zbxapi_login(@resource)
    host = zbxapi_get_host_from_name(@resource[:nodename], 'shorten', token)[0]
    template_to_remove = zbxapi_get_template_from_name(@resource[:template], 'shorten', token)
    token.host.update( { 'hostid' => host['hostid'], 'templates_clear' => template_to_remove } )
  end

end
