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
    host = token.host.get( { 'output' => output, 'filter' => { 'host' => name } } )
    return host if host.length > 0
    return []
  end

  def zbxapi_get_host_groups_from_name(name,output,token)
    host = token.host.get( { 'select_groups' => output, 'filter' => { 'host' => name } } )
    return host[0]['groups'] if host.length > 0 and host[0].has_key? 'groups'
    return []
  end

  def zbxapi_get_host_templates_from_name(name,output,token)
    host = token.host.get( { 'selectParentTemplates' => output, 'filter' => { 'host' => name } } )
    return host[0]['parentTemplates'] if host.length > 0 and host[0].has_key? 'parentTemplates'
    return []
  end

  def zbxapi_get_template_from_name(name, output, token)
    # The host.get_template API method is working against the API docs, not returning an array but instead a hash directly
    # which each templateid as key containing the resulting data
    # This method generates a list with the data instead to be consistent with rest of API
    # NOT TRUE, seem to be fixed in 1.8.6, need to add api version checker
    template = token.host.get_template( { 'output' => output, 'filter' => { 'host' => name } } )
    return template[0] if template.length > 0
    return []
    #return_template = []
    #template.each_pair { |k,v| return_template << v }
    #return return_template[0] if return_template.length > 0
    #return []
  end

  def zbxapi_get_group_from_name(name,output,token)
    group = token.hostgroup.get( { 'output' => output, 'filter' => { 'name' => name } } )
    return group[0] if group.length > 0
    return []
  end

  def zbxapi_get_host_macros_from_name(name,output,token)
    host = token.host.get( { 'select_macros' => output, 'filter' => { 'host' => name } } )
    return host[0]['macros'] if host.length > 0 and host[0].has_key? 'macros'
    return []
  end

end
