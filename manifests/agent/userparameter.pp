# ==: Definition zabbix::agent::userparameter
#
# Add custom UserParameters to Zabbix Agent
#
# ==: Parameters
#
#   [*name*]
#     Name of this puppet resource, UserParameter and filename in include dir.
#
#   [*command*]
#     Command to execute in UserParameter. Needs to be set if *content* is not set.
#
#   [*parameters*]
#     Boolean if a [*] entry should be added to the UserParameter, allowing Zabbix to pass arguments
#     to the command. Default false.
#     Optional
#
#   [*content*]
#     Custom template data. Needs to be set if *command* is not set.
#     
# ==: Sample Usage
#
#   zabbix::agent::userparameter { "process.list": command => 'pgrep $1 |wc -l', parameters => true }
# 
define zabbix::agent::userparameter ( $command = undef,
                                      $parameters = false,
                                      $content = undef ) {

  $filename = regsubst($name, '\W', '','G')
  if $command == undef and $content == undef {
    fail("One of the following parameters are required: command, source, content")
  }

 	file { "zabbix/agent/config/include/${name}":
 		ensure	=> present,
    path    => "${zabbix::params::agent_config_include}/${filename}.conf",
 		owner	  => $zabbix::params::user,
 		group	  => $zabbix::params::group,
 		mode	  => 644,
 		content	=> $content ? {
      undef   => template("zabbix/agent/userparameter.erb"),
      default => $content,
    },
    notify  => Service["zabbix/agent/service"],
    require => File["zabbix/agent/config/include/dir"],
 	}

}
