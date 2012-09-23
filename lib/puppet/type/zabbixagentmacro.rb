Puppet::Type.newtype(:zabbixagentmacro) do
  @doc = 'Manage a Zabbix agent macro'
  
  ensurable

  newparam(:name) do
    desc 'The unique name of the zabbix agent macro definition in puppet'
    isnamevar
  end

  newparam(:apiurl) do
    desc 'URL to the Zabbix API'
    validate do |value|
      unless value.downcase =~ /^(http|https):\/\/.*/
        raise ArgumentError, "%s doesn't look like a valid http url for parameter apiurl" % value
      end
    end
  end
  
  newparam(:apiuser) do
    desc 'User connecting to the Zabbix API'
    defaultto 'zabbixapi'
  end
  
  newparam(:apipassword) do
    desc 'User password connecting to the Zabbix API'
  end

  newparam(:nodename) do
    desc 'Name of the Zabbix agent node to manage'
  end
  
  newparam(:macro) do
    desc 'Name of the macro to manage for the Zabbix agent'
  end

  newparam(:value) do
    desc 'Value of the macro to manage for the Zabbix agent'
  end

end
