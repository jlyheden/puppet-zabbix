/*
 * ==:Definition zabbix::agent::userparameter
 * 
 * Installs a custom Zabbix agent userparameter
 * 
 * @params
 * @name		String value name of userparameter
 * @ensure		String value present or absent
 * @command		String value command to execute
 * @parameters	Boolean value if userparameter item contains variables set on Zabbix server
 */
 define zabbix::agent::userparameter ( $ensure = "present", $command, $parameters = false ) {

 	file { "${zabbix::params::agent_config_include}/${name}":
 		ensure	=> $ensure,
 		owner	=> $zabbix::params::user,
 		group	=> $zabbix::params::group,
 		mode	=> 640,
 		content	=> template("zabbix/agent/$::lsbdistcodename/userparameter.erb"),
 		require	=> Class["zabbix::agent::config"],
 		notify	=> Class["zabbix::agent::service"]
 	}

 }