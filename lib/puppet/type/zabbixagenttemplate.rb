Puppet::Type.newtype(:zabbixagenttemplate) do
  @doc = 'Manage a Zabbix agent template membership'
  
  feature :purgeable, :methods => [:purge]

  ensurable do
    "Supported ensure parameters are present, absent, purge. Purge will remove all history and items from a template."
    
    newvalue(:present, :event => :template_linked) do
       provider.create
    end

    newvalue(:absent, :event => :template_removed) do
       provider.destroy
    end

    newvalue(:purged, :event => :template_purged) do
       provider.purge
    end

    def insync?(is)
      @should ||= []
      @should.each { |should|
         case should
         when :present
            return true unless [:absent, :purged].include?(is)
         when :absent
            return true if is == :absent or is == :purged
         when :purged
            return true if is == :purged or is == :absent
         when is
            return true
         end
      }
      false
    end

  end

  newparam(:name) do
    desc 'The unique name of the zabbix agent template membership definition in puppet'
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
  
  newparam(:template) do
    desc 'Name of the template to manage for the Zabbix agent'
  end

end
