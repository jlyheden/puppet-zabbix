Puppet::Type.newtype(:zabbixagentgroup) do
  @doc = 'Manage a Zabbix agent group membership'
  
  ensurable

  newparam(:name) do
    desc 'The unique name of the zabbix agent group membership definition in puppet'
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

  newparam(:node) do
    desc 'Name of the Zabbix agent node to manage'
  end
  
  newparam(:group) do
    desc 'Name of the group to manage for the Zabbix agent'
  end

end