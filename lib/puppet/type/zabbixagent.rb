Puppet::Type.newtype(:zabbixagent) do
  @doc = 'Manage a Zabbix agent'
  
  ensurable
  
  newparam(:name) do
    desc 'The name of the Zabbix agent as referenced in the Zabbix Server'
    isnamevar
  end
  
  newparam(:apiurl) do
    desc 'URL to the Zabbix API'
    validate do |value|
      unless value.lower =~ /^(http|https):\/\/.*/
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
  
  newparam(:ip) do
    desc 'IP address of agent'
    defaultto Facter.value('ipaddress')
  end

  newparam(:dns) do
    desc 'DNS name of agent'
  end

  newparam(:ipmi) do
    desc 'If IPMI should be used'
    defaultto false
  end

  newparam(:snmp) do
    desc 'If SNMP should be used'
    defaultto false
  end

  newparam(:port) do
    desc 'Passive agent port'
    defaultto 10050
  end

end