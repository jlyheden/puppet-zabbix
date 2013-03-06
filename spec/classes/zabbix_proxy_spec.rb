require 'spec_helper'

describe 'zabbix::proxy' do

  # set depending facts
  let (:facts) { {
    :operatingsystem  => 'Ubuntu',
  } } 

  context 'with default params' do
    it do should contain_package('zabbix::proxy').with(
      'ensure'  => 'present',
      'name'    => 'zabbix-proxy-mysql'
    ) end
    it do should contain_service('zabbix::proxy').with(
      'ensure'  => 'running',
      'enable'  => true,
      'name'    => 'zabbix-proxy'
    ) end
    it do should contain_file_line('set_proxy_init_script_run_dir').with(
      'ensure'  => 'present',
      'path'    => '/etc/init.d/zabbix-proxy',
      'line'    => 'DIR=/var/run/zabbix',
      'require' => 'Package[zabbix::proxy]',
      'notify'  => 'Service[zabbix::proxy]'
    ) end
    it do should contain_file('zabbix/proxy/conf').with(
      'ensure'  => 'present',
      'path'    => '/etc/zabbix/zabbix_proxy.conf',
      'owner'   => 'root',
      'group'   => 'zabbix',
      'mode'    => '0640',
      'notify'  => 'Service[zabbix::proxy]'
    ).with_content("# MANAGED BY PUPPET

Server=localhost
DBHost=localhost
DBName=zabbix
DBUser=zabbix
LogFile=/var/log/zabbix/zabbix_proxy.log
PidFile=/var/run/zabbix/zabbix_proxy.pid
") end
    it do should contain_file('zabbix/run_d').with(
      'ensure'  => 'directory',
      'path'    => '/var/run/zabbix',
      'owner'   => 'zabbix',
      'group'   => 'zabbix',
      'mode'    => '0644'
    ) end
    it do should contain_file('zabbix/log_d').with(
      'ensure'  => 'directory',
      'path'    => '/var/log/zabbix',
      'owner'   => 'zabbix',
      'group'   => 'zabbix',
      'mode'    => '0640'
    ) end
    it do
      should_not contain_file('zabbix/proxy/run_d')
      should_not contain_file('zabbix/proxy/log_d')
    end
  end

  context 'with log_d => /logdir, run_d => /rundir' do
    let (:params) { {
      :log_d  => '/logdir',
      :run_d  => '/rundir'
    } }
    it do should contain_file('zabbix/proxy/conf').with_content("# MANAGED BY PUPPET

Server=localhost
DBHost=localhost
DBName=zabbix
DBUser=zabbix
LogFile=/logdir/zabbix_proxy.log
PidFile=/rundir/zabbix_proxy.pid
") end
    it do should contain_file('zabbix/proxy/run_d').with(
      'ensure'  => 'directory',
      'path'    => '/rundir',
      'owner'   => 'zabbix',
      'group'   => 'zabbix',
      'mode'    => '0644'
    ) end
    it do should contain_file('zabbix/proxy/log_d').with(
      'ensure'  => 'directory',
      'path'    => '/logdir',
      'owner'   => 'zabbix',
      'group'   => 'zabbix',
      'mode'    => '0640'
    ) end
    it do
      should_not contain_file('zabbix/run_d')
      should_not contain_file('zabbix/log_d')
    end
    it do should contain_file_line('set_proxy_init_script_run_dir').with(
      'line'    => 'DIR=/rundir'
    ) end
  end

  context 'with autoupgrade => true' do
    let (:params) { {
      :autoupgrade  => true
    } }
    it do should contain_package('zabbix::proxy').with(
      'ensure'  => 'latest',
      'name'    => 'zabbix-proxy-mysql'
    ) end
  end

  context 'with ensure => absent, autoupgrade => true' do
    let (:params) { {
      :ensure       => 'absent',
      :autoupgrade  => true
    } }
    it do should contain_package('zabbix::proxy').with(
      'ensure'  => 'absent',
      'name'    => 'zabbix-proxy-mysql'
    ) end
  end

  context 'with managedb => true, dbpassword => zabbixpw, dbrootpassword => mypw' do
    let (:params) { {
      :managedb       => true,
      :dbpassword     => 'zabbixpw',
      :dbrootpassword => 'mypw'
    } }
    it do should contain_class('zabbix::mysql').with(
      'root_password' => 'mypw'
    ) end
    it do should contain_file('zabbix::proxy/responsefile').with(
      'ensure'  => 'present',
      'path'    => '/var/local/zabbix-proxy.preseed',
      'mode'    => '0400',
      'owner'   => 'root',
      'group'   => 'root',
      'before'  => 'Package[zabbix::proxy]'
    ).with_content("# MANAGED BY PUPPET
zabbix-proxy-mysql zabbix-proxy-mysql/dbconfig-install boolean true
zabbix-proxy-mysql zabbix-proxy-mysql/database-type select mysql
zabbix-proxy-mysql zabbix-proxy-mysql/mysql/app-pass password zabbixpw
zabbix-proxy-mysql zabbix-proxy-mysql/mysql/admin-pass password mypw
zabbix-proxy-mysql zabbix-proxy-mysql/app-password-confirm password zabbixpw
zabbix-proxy-mysql zabbix-proxy-mysql/password-confirm password mypw
") end
  end

  context 'with invalid operatingsystem' do
    let (:facts) { {
      :operatingsystem => 'beos'
    } }
    it do
      expect {
        should contain_class('zabbix::params')
      }.to raise_error(Puppet::Error, /Unsupported operatingsystem beos/)
    end
  end

end
