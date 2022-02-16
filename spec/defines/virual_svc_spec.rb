# frozen_string_literal: true

require 'spec_helper'

describe 'my_webapp::virtual_svc' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'my_webapp::virtual_svc' }

      let(:params) do
        if os.include?('windows')
          {
            :config_path => 'C:/Users/Administrator/AppData/Roaming/Apache24/conf',
            :listen_ip   => '192.168.254.2',
            :websvc_port => 8080,
            :servicename => 'example',
          }
        else
          {
            :config_path => '/etc/httpd/conf',
            :listen_ip   => '192.168.254.2',
            :websvc_port => 8080,
            :servicename => 'example',            
          }
        end
      end

      let :pre_condition do
        'include my_webapp'
      end

      it { is_expected.to compile }
      case os_facts[:kernel]
      when 'windows'
        it { is_expected.to contain_file('example_8080.conf')
          .with('path'   => 'C:/Users/Administrator/AppData/Roaming/Apache24/conf')
          .with('ensure' => 'file')
          .with('mode'   => '0640')
        }
      when 'linux'
        it { is_expected.to contain_file('example_8080.conf')
          .with('path'   => '/etc/httpd/conf')
          .with('ensure' => 'file')
          .with('mode'   => '0640')
        }
      end
    end
  end
end
