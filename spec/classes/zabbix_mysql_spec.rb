require 'spec_helper'

describe 'zabbix::mysql' do

  # set depending facts
  let (:facts) { {
    :operatingsystem  => 'Ubuntu',
  } } 

  context 'with root_password => mypw' do
    let (:params) { {
      :root_password => 'mypw'
    } }
    it do should contain_package('zabbix::mysql').with(
      'ensure'  => 'present',
      'name'    => [ 'mysql-client-5.1', 'mysql-common', 'mysql-server-5.1', 'mysql-server', 'dbconfig-common' ]
    ) end
    it do should contain_service('zabbix::mysql').with(
      'ensure'  => 'running',
      'enable'  => true,
      'name'    => 'mysql',
      'require' => 'Package[zabbix::mysql]'
    ) end
    it do should contain_file('zabbix::mysql/responsefile').with(
      'ensure'  => 'present',
      'path'    => '/var/local/mysql.preseed',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0400'
    ).with_content("# MANAGED BY PUPPET
mysql-server-5.1 mysql-server/root_password_again password mypw
mysql-server-5.1 mysql-server/root_password password mypw
mysql-server-5.1 mysql-server/start_on_boot boolean true
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
