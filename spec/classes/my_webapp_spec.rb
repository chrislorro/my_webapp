# frozen_string_literal: true

require 'spec_helper'

describe 'my_webapp' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'with defauls' do
        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_class('my_webapp::install')
          is_expected.to contain_class('my_webapp::config').that_requires('Class[my_webapp::install]')
          is_expected.to contain_class('my_webapp::service').that_subscribes_to('Class[my_webapp::config]')
        end
      
        context 'class default settings' do
          it { is_expected.to compile }
          it { is_expected.to contain_class('Settings')}

          case os_facts[:kernel]
          when 'Linux'
            it do
              is_expected.to contain_class('My_webapp').with(
                'pkg_version'  => 'installed',
                'app_user'     => 'root',
                'servicename'  => 'example',
                'web_package'  => 'httpd',
                'web_service'  => 'httpd',
                'svc_owner'    => 'root',
                'http_config'  => 'httpd.conf',
                'websvc_port'  => '8080',
                'http_enable'  => 'true',
                'websvc_user'  => '{"httpd"=>{"home"=>"/home", "groups"=>"linx_webapps", "managehome"=>true}}',
                'listen_ip'    => '192.168.254.2',
                'config_path'  => '/etc/httpd/conf',
                'http_ensure'  => 'running',
                'ensure_vhost' => 'true',
              )
            end
          when 'windows'
            it do
              is_expected.to contain_class('My_webapp').with(
                'pkg_version'  => 'installed',
                'app_user'     => 'Administrator',
                'servicename'  => 'example',
                'web_package'  => 'apache-httpd',
                'web_service'  => 'apache',
                'svc_owner'    => 'Administrator',
                'http_config'  => 'httpd.conf',
                'websvc_port'  => '8080',
                'http_enable'  => 'true',
                'websvc_user'  => '{"apache"=>{"home"=>"C:/Users"}}',
                'listen_ip'    => '192.168.254.2',
                'config_path'  => 'C:/Users/Administrator/AppData/Roaming/Apache24/conf',
                'http_ensure'  => 'running',
                'ensure_vhost' => 'true',
              )
            end
          else
            it {
              expect { catalogue }.to raise_error(
                %r{The my_webapp module is not supported on an unsupported based system..}, 
              )
            } # are we adding guardrails or just making it complicated?
          end
        end
      end

      describe 'Base configuration' do

        context 'my_webapp::install' do
          let(:facts) { os_facts }
          
          it { is_expected.to compile }
          it { is_expected.to contain_package('httpd').with('ensure' => 'installed') unless %r{windows}.match?(os)}
          it { is_expected.not_to contain_class('chocolatey') unless %r{windows}.match?(os)}
          
          it { is_expected.to contain_package('apache-httpd').with('ensure' => 'installed') if %r{windows}.match?(os)}
          it { is_expected.to contain_class('chocolatey') if %r{windows}.match?(os)}
        end

        context 'when ensure is set to true my_webapp::config' do
          let(:facts) { os_facts }

          let(:params) do
            {
              ensure_vhost: true,
            }
          end

          let(:http_conf) do
            if os.include?('windows')
              'C:/Users/Administrator/AppData/Roaming/Apache24/conf/httpd.conf'
            else
              '/etc/httpd/conf/httpd.conf'
            end
          end

          it { is_expected.to compile }
          case os_facts[:kernel]
          when 'Linux'
            it do   
              is_expected.to contain_file(http_conf).with(
                'ensure'  => 'present',
                'mode'    => '0644',
                'owner'   => 'root',
              ).that_requires('Class[My_webapp::Install]')
            end
          when 'windows'
            it do   
              is_expected.to contain_file(http_conf).with(
                'ensure'  => 'present',
                'mode'    => '0644',
                'owner'   => 'Administrator',
              ).that_requires('Class[My_webapp::Install]')
            end
          end
          
          it { is_expected.to compile }
          it do 
            is_expected.to contain_my_webapp__virtual_svc('example.conf').with(
              'vhost_path' => '/etc/httpd/conf/example.conf',
            ) unless %r{windows}.match?(os)
          end
        end

        # context 'when ensure is set to false my_webapp::config' do
        #   let(:params) do
        #     {
        #       ensure_vhost: false,
        #     }
        #   end

        #   it do
        #     is_expected.not_to contain_my_webapp__virtual_svc('example.conf')
        #   end
        # end

        context 'mywebapp::service' do

          let(:http_config) {'undef'}
          let(:params) do
              {
                :http_conf => 'undef',
              }
            if os.include?('windows')
              {
                :web_service => 'apache',
              }
            else
              {
                :web_service => 'httpd',
              }
            end
          end
      
          # let(:params) do
          #   super().merge({ 'http_conf' => 'httpd.conf' })
          # end
      
          if os_facts[:osfamily] == 'RedHat'
            it { is_expected.to contain_service('httpd').with_ensure('running') }
            it { is_expected.to contain_service('httpd').with_enable('true') }
            it { is_expected.to contain_service('httpd') }
          end
  
          if os_facts[:osfamily] == 'windows'
            it { is_expected.to contain_service('apache').with_ensure('running') }
            it { is_expected.to contain_service('apache').with_enable('true') }
            it { is_expected.to contain_service('apache') }
          end
        end

      end

      # context 'with ensure => whoopsiedoo' do
      #   let(:params) { {'ensure' => 'whoopsiedoo'} }
    
      #   it { is_expected.to compile.and_raise_error(/the expected error message/) }
      # end

    end
  end
end
