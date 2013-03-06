# == Definition zabbix::agent::userparameter
#
# Add custom UserParameters to Zabbix Agent
#
# === Parameters
#
# === Sample Usage
#
# TBD
#
define zabbix::agent::userparameter (
  $ensure     = 'present',
  $command    = 'UNDEF',
  $parameters = false,
  $source     = 'UNDEF',
  $content    = 'UNDEF'
) {

  include zabbix::params

  # Input validation
  validate_re($ensure,$zabbix::params::valid_ensure_values)

  $filename = regsubst($name, '\W', '','G')
  $resourcename = "zabbix/agent/conf_d/${name}"

  # Param checking
  # This is quite ugly, is it possible to make it less so?
  if $command == 'UNDEF' and $source == 'UNDEF' and $content == 'UNDEF' {
    fail('One of the following parameters must be set: command, source, content')
  }
  if $command != 'UNDEF' and ($source != 'UNDEF' or $content != 'UNDEF') {
    fail('Parameter command, source or content cannot be set at the same time.')
  }
  if $source != 'UNDEF' and ($command != 'UNDEF' or $content != 'UNDEF') {
    fail('Parameter command, source or content cannot be set at the same time.')
  }
  if $content != 'UNDEF' and ($command != 'UNDEF' or $source != 'UNDEF') {
    fail('Parameter command, source or content cannot be set at the same time.')
  }

  # Provides the proper params to the file resource
  if $command != 'UNDEF' {
    $content_real = template('zabbix/agent/userparameter.erb')
    File[$resourcename] { content => $content_real }
  }
  if $content != 'UNDEF' {
    File[$resourcename] { content => $content }
  }
  if $source != 'UNDEF' {
    File[$resourcename] { source => $source }
  }
  if $zabbix::agent::autorestart {
    File[$resourcename] { notify => Service['zabbix::agent'] }
  }

 	@file { "zabbix/agent/conf_d/${name}":
 		ensure	=> $ensure,
    tag     => 'userparameter',
    path    => "${zabbix::params::agent_conf_d}/${filename}",
 		owner	  => $zabbix::params::user,
 		group	  => $zabbix::params::group,
 		mode	  => '0640',
    require => File['zabbix/agent/conf_d'],
 	}

}
