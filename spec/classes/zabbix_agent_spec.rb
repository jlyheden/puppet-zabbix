require 'spec_helper'

describe 'zabbix::agent' do

  # set depending facts
  let (:facts) { {
    :operatingsystem  => 'Ubuntu',
    :concat_basedir   => '/var/lib/puppet/concat'
  } } 

  context 'with default params' do
    it do should contain_package('zabbix::agent').with(
      'ensure'  => 'present',
      'name'    => 'zabbix-agent'
    ) end
    it do should contain_service('zabbix::agent').with(
      'ensure'  => 'running',
      'enable'  => true,
      'name'    => 'zabbix-agent'
    ) end
    it do should contain_file_line('set_init_script_run_dir').with(
      'ensure'  => 'present',
      'path'    => '/etc/init.d/zabbix-agent',
      'line'    => 'DIR=/var/run/zabbix',
      'require' => 'Package[zabbix::agent]',
      'notify'  => 'Service[zabbix::agent]'
    ) end
    it do should contain_file('zabbix::agent/conf').with(
      'ensure'  => 'present',
      'path'    => '/etc/zabbix/zabbix_agentd.conf',
      'owner'   => 'root',
      'group'   => 'zabbix',
      'mode'    => '0640',
      'notify'  => 'Service[zabbix::agent]'
    ).with_content("# MANAGED BY PUPPET
Server=localhost
LogFile=/var/log/zabbix/zabbix_agentd.log
PidFile=/var/run/zabbix/zabbix_agentd.pid
Include=/etc/zabbix/zabbix_agentd.d/
") end
    it do should contain_file('zabbix::agent/conf_d').with(
      'ensure'  => 'directory',
      'path'    => '/etc/zabbix/zabbix_agentd.d',
      'owner'   => 'root',
      'group'   => 'zabbix',
      'mode'    => '0640',
      'purge'   => true,
      'force'   => true,
      'recurse' => true,
      'notify'  => 'Service[zabbix::agent]'
    ) end
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
      should_not contain_file('zabbix::agent/run_d')
      should_not contain_file('zabbix::agent/log_d')
    end
  end

  context 'with log_d => /logdir, run_d => /rundir' do
    let (:params) { {
      :log_d  => '/logdir',
      :run_d  => '/rundir'
    } }
    it do should contain_file('zabbix::agent/conf').with_content("# MANAGED BY PUPPET
Server=localhost
LogFile=/logdir/zabbix_agentd.log
PidFile=/rundir/zabbix_agentd.pid
Include=/etc/zabbix/zabbix_agentd.d/
") end
    it do should contain_file('zabbix::agent/run_d').with(
      'ensure'  => 'directory',
      'path'    => '/rundir',
      'owner'   => 'zabbix',
      'group'   => 'zabbix',
      'mode'    => '0644'
    ) end
    it do should contain_file('zabbix::agent/log_d').with(
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
    it do should contain_file_line('set_init_script_run_dir').with(
      'line'    => 'DIR=/rundir'
    ) end
  end

  context 'with autoupgrade => true' do
    let (:params) { {
      :autoupgrade  => true
    } }
    it do should contain_package('zabbix::agent').with(
      'ensure'  => 'latest',
      'name'    => 'zabbix-agent'
    ) end
  end

  context 'with ensure => absent, autoupgrade => true' do
    let (:params) { {
      :ensure       => 'absent',
      :autoupgrade  => true
    } }
    it do should contain_package('zabbix::agent').with(
      'ensure'  => 'absent',
      'name'    => 'zabbix-agent'
    ) end
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
