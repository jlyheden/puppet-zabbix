# == Class: zabbix::params
#
class zabbix::params {

  # Standard service settings
  $ensure = 'present'
  $service_enable = true
  $service_status = 'running'
  $autoupgrade = false
  $autorestart = true

  # Valid standard values
  $valid_ensure_values = [ 'present', 'absent', 'purged' ]
  $valid_service_statuses = [ 'running', 'stopped', 'unmanaged' ]

  # Zabbix All components
  $user = 'zabbix'
  $group = 'zabbix'
  $uid = undef
  $gid = undef
  $config_dir = '/etc/zabbix'
  $run_dir = '/var/run/zabbix'
  $log_dir = '/var/log/zabbix'
  $dbhost = 'localhost'
  $dbname = 'zabbix'
  $dbuser = 'zabbix'
  $dbpassword = ''
  $dbrootpassword = ''
  $dbport = ''
  $managedb = false
  $alertd_dir = "${config_dir}/alert.d"
  $externalscripts_dir = "${config_dir}/externalscripts"

  # Zabbix Proxy settings
  $proxy_source = ''
  $proxy_server = 'localhost'
  $proxy_parameters = {}
  $proxy_conf = "${config_dir}/zabbix_proxy.conf"
  $proxy_init = '/etc/init.d/zabbix-proxy'
  $proxy_template = 'zabbix/proxy/zabbix_proxy.conf.erb'

  # Zabbix Agent settings
  $agent_server = 'localhost'
  $agent_source = ''
  $agent_init = '/etc/init.d/zabbix-agent'
  $agent_conf = "${config_dir}/zabbix_agentd.conf"
  $agent_conf_d = "${config_dir}/zabbix_agentd.d"
  $agent_conf_d_purge = true
  $agent_parameters = {}
  $agent_template = 'zabbix/agent/zabbix_agentd.conf.erb'

  # OS dependent settings
  case $::operatingsystem {
    'Ubuntu', 'Debian': {
      $mysql_packages = $::lsbdistcodename ? {
        precise => [ 'mysql-client-5.5', 'mysql-common', 'mysql-server-5.5', 'mysql-server', 'dbconfig-common' ],
        lucid   => [ 'mysql-client-5.1', 'mysql-common', 'mysql-server-5.1', 'mysql-server', 'dbconfig-common' ],
        default => [ 'mysql-client-5.1', 'mysql-common', 'mysql-server-5.1', 'mysql-server', 'dbconfig-common' ]
      }
      $mysql_preseed_file = '/var/local/mysql.preseed'
      $mysql_service = 'mysql'
      $bug_5610 = $::puppetversion ? {
        /2\.6\.[0-6]/ => true,
        default => false,
      }
      # Agent settings
      $agent_package = 'zabbix-agent'
      $agent_service = 'zabbix-agent'
      $agent_pattern = 'zabbix_agentd'
      $agent_hasstatus = $bug_5610 ? {
        true    => false,
        default => true
      }
      # Server settings
      $server_package = 'zabbix-server-mysql'
      $server_php_package = 'zabbix-frontend-php'
      $server_config_file = "${config_dir}/zabbix_server.conf"
      $server_php_config_file = "${config_dir}/dbconfig.php"
      $server_log_dir = '/var/log/zabbix-server'
      $server_service = 'zabbix-server'
      $server_pattern = 'zabbix_server'
      $server_managedb = false
      $server_preseed_file = '/var/local/zabbix-server.preseed'
      $server_hasstatus = $bug_5610 ? {
        true    => false,
        default => true
      }
      # Proxy settings
      $proxy_package = 'zabbix-proxy-mysql'
      $proxy_service = 'zabbix-proxy'
      $proxy_pattern = 'zabbix_proxy'
      $proxy_preseed_file = '/var/local/zabbix-proxy.preseed'
      $proxy_hasstatus = $bug_5610 ? {
        true    => false,
        default => true
      }
      # Frontend settings
      $frontend_config_file = "${config_dir}/dbconfig.php"
      $frontend_package = 'zabbix-frontend-php'
      $frontend_preseed_file = '/var/local/zabbix-frontend.preseed'
      $frontend_managedb = false
      $frontend_apacheservice_reload_cmd = 'service apache2 reload'
    }
    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}")
    }
  }

  # Defaults
  $nodename = $::hostname

  # Zabbix frontend defaults
  $frontend_dbport = 0
  $frontend_autoupgrade = false

  # Zabbix agent defaults
  $agent_port = 10050
  $agent_active_mode = true
  $agent_remote_commands = true
  $agent_auto_register = true
  $agent_startagents = 5
  $agent_debuglevel = 3
  $agent_timeout = 3

  # Zabbix server defaults
  $server_nodeid = 0
  $server_host = "zabbix.${::domain}"
  $server_port = 10051
  $server_dbname = 'zabbix'
  $server_dbuser = 'zabbix'
  $server_startpollers = 5
  $server_startipmipollers = 0
  $server_startpollersunreachable = 1
  $server_starttrappers = 5
  $server_startpingers = 1
  $server_startdiscoverers = 1
  $server_starthttppollers = 1
  $server_housekeepingfrequency = 1
  $server_senderfrequency = 30
  $server_housekeeping = true
  $server_debuglevel = 3
  $server_timeout = 5
  $server_trappertimeout = 5
  $server_unreachableperiod = 45
  $server_unavailabledelay = 60
  $server_logfilesize = 10
  $server_tmpdir = '/tmp'
  $server_cachesize = '8M'
  $server_autoupgrade = false

  # Zabbix proxy defaults
  $proxy_port = 10051
  $proxy_dbuser = 'zabbix_proxy'
  $proxy_dbname = 'zabbix_proxy'
  $proxy_startpollers = 5
  $proxy_startipmipollers = 0
  $proxy_startpollersunreachable = 1
  $proxy_starttrappers = 5
  $proxy_startpingers = 1
  $proxy_startdiscoverers = 1
  $proxy_starthttppollers = 1
  $proxy_heartbeatfrequency = 60
  $proxy_housekeepingfrequency = 1
  $proxy_configfrequency = 3600
  $proxy_senderfrequency = 30
  $proxy_proxylocalbuffer = 0
  $proxy_proxyofflinebuffer = 1
  $proxy_debuglevel = 3
  $proxy_timeout = 5
  $proxy_trappertimeout = 5
  $proxy_unreachableperiod = 45
  $proxy_unavailabledelay = 60
  $proxy_logfilesize = 10
  $proxy_tmpdir = '/tmp'
  $proxy_pingerfrequency = 60

}
