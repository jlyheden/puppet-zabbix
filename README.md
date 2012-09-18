# Puppet-zabbix

Puppet module for managing zabbix agent/frontend/server/proxy

## Install

Git clone this repo into your modules folder or download the tar ball under the downloads tab.

## Limitations

Declares virtual packages of mysql-server, will probably collide with other puppet modules that manages
mysql but didnt want to add mysql dependencies to any particular mysql module. Might try to fix that eventually.
Only tested on Ubuntu and Lucid, with version 1.8.6 backported. Proxy is not tested at all.
All DB depending roles are limited to mysql.

## Sample usage

Example that installs agent, frontend and server on a single box.
Mysql is pulled from repo as well and mysql + zabbix server install is
preseeded (creates database users, schemas, permissions).

<pre>
  class { 'zabbix::agent':
    nodename   => 'Zabbix server',
    server_host => '127.0.0.1',
    active_mode => false,
  }

  class { 'zabbix::server':
    dbhost => 'localhost',
    dbpassword => 'zabbix',
    dbrootpassword => 'rootpw',
    managedb => true,
  }

  class { 'zabbix::frontend':
    server_host => '127.0.0.1',
    dbhost => 'localhost',
    dbpassword => 'zabbix',
    softmanage_apache => true,
  }
</pre>
