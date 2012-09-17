# Params class for zabbix
# Put whatever hooks for extlookup / hiera here
class zabbix::params {

    # OS dependent settings
    case $::operatingsystem {
        ubuntu: {
            # Note 1: there is a bug in Puppet <2.6.7 in which named services does not support hasstatus
            #         http://projects.puppetlabs.com/issues/5610
            # Note 2: in order for non-interactive installs to not permanently fail in Lucid it is necessary to install dbconfig-common from lucid-proposed
            #         https://bugs.launchpad.net/ubuntu/+source/dbconfig-common/+bug/800543

            # Global settings
            $user = 'zabbix'
            $group = 'zabbix'
            $config_dir = '/etc/zabbix'
            $alertd_dir = "${config_dir}/alert.d"
            $externalscripts_dir = "${config_dir}/externalscripts"
            $pid_dir = '/var/run/zabbix'
            $mysql_packages = [ 'mysql-client-5.1', 'mysql-common', 'mysql-server-5.1', 'mysql-server', 'dbconfig-common' ]
            $mysql_preseed_file = '/var/local/mysql.preseed'

            # Agent settings
            $agent_package = 'zabbix-agent'
            $agent_service = 'zabbix-agent'
            $agent_config_file = "${config_dir}/zabbix_agentd.conf"
            $agent_config_include = "${config_dir}/include.d"
            $agent_log_dir = '/var/log/zabbix-agent'
            $agent_hasstatus = $::puppetversion ? {
                /2\.6\.[0-6]/ => undef,
                default   => true,
            }

            # Server settings
            $server_package = 'zabbix-server-mysql'
            $server_php_package = 'zabbix-frontend-php'
            $server_config_file = "${config_dir}/zabbix_server.conf"
            $server_php_config_file = "${config_dir}/dbconfig.php"
            $server_log_dir = '/var/log/zabbix-server'
            $server_service = 'zabbix-server'
            $server_managedb = false
            $server_preseed_file = '/var/local/zabbix-server.preseed'
            $server_hasstatus = $::puppetversion ? {
                /2\.6\.[0-6]/ => undef,
                default   => true,
            }

            # Proxy settings
            $proxy_package = 'zabbix-proxy-mysql'
            $proxy_config_file = "${config_dir}/zabbix_proxy.conf"
            $proxy_service = 'zabbix-proxy'
            $proxy_log_dir = '/var/log/zabbix-proxy'
            $proxy_manage_db = false
            $proxy_preseed_file = '/var/local/zabbix-proxy.preseed'
            $proxy_hasstatus = $::puppetversion ? {
                /2\.6\.[0-6]/ => undef,
                default   => true,
            }

            # Frontend settings
            $frontend_config_file = "${config_dir}/dbconfig.php"
            $frontend_package = 'zabbix-frontend-php'
            $frontend_preseed_file = '/var/local/zabbix-frontend.preseed'
            $frontend_managedb = false
            $frontend_apacheservice_reload_cmd = 'service apache2 reload'
        }
        default: {
            fail("Operating system $::operatingsystem not supported")
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
    $agent_autoupgrade = false

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
