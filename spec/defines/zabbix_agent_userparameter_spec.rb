require 'spec_helper'

describe 'zabbix::agent::userparameter' do

  # set depending facts
  let (:facts) { {
    :operatingsystem  => 'Ubuntu'
  } } 

  let (:pre_condition) do [
    'class { "zabbix::agent": }'
  ]
  end

  context 'with command => "ps aux"' do
    let (:name) { 'process_list' }
    let (:title) { 'process_list' }
    let (:params) { {
      :command => 'ps aux'
    } } 
    it do
      should contain_file('zabbix::agent/conf_d/process_list').with(
        'ensure'  => 'present',
        'path'    => '/etc/zabbix/zabbix_agentd.d/process_list',
        'owner'   => 'zabbix',
        'group'   => 'zabbix',
        'mode'    => '0640',
        'notify'  => 'Service[zabbix::agent]'
      ).with_content(/\nUserParameter=process_list,ps aux\n/).without(['source'])
    end
  end

  context 'with source => puppet:///modules/module/file' do
    let (:name) { 'process_list' }
    let (:title) { 'process_list' }
    let (:params) { {
      :source => 'puppet:///modules/module/file'
    } }
    it do
      should contain_file('zabbix::agent/conf_d/process_list').with(
        'ensure'  => 'present',
        'path'    => '/etc/zabbix/zabbix_agentd.d/process_list',
        'owner'   => 'zabbix',
        'group'   => 'zabbix',
        'mode'    => '0640',
        'source'  => 'puppet:///modules/module/file',
        'notify'  => 'Service[zabbix::agent]'
      ).without(['content'])
    end
  end

  context 'with source => puppet:///modules/module/file, content => bla' do
    let (:name) { 'process_list' }
    let (:title) { 'process_list' }
    let (:params) { {
      :source   => 'puppet:///modules/module/file',
      :content  => 'bla'
    } }
    it do
      expect {
        should include_class('zabbix::params')
      }.to raise_error(Puppet::Error, /cannot be set at the same time/)
    end
  end

  # disabled until https://github.com/rodjek/rspec-puppet/pull/73 is distributed
  # via gem
  #
  #context 'with command => "ps aux| grep $1", parameters => true' do
  #  let (:name) { 'process_list' }
  #  let (:title) { 'process_list' }
  #  let (:params) { {
  #    :command    => 'ps aux| grep $1',
  #    :parameters => true
  #  } }
  #  it do
  #    should contain_file('zabbix/agent/conf_d/process_list').with(
  #      'ensure'  => 'present',
  #      'path'    => '/etc/zabbix/zabbix_agentd.d/process_list',
  #      'owner'   => 'zabbix',
  #      'group'   => 'zabbix',
  #      'mode'    => '0640',
  #      'notify'  => 'Service[zabbix::agent]'
  #    ).with_content(/\nUserParameter=process_list[*],ps aux\| grep \$1\n/).without(['source'])
  #  end
  #end

end
