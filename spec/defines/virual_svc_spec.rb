# frozen_string_literal: true

require 'spec_helper'

describe 'my_webapp::virtual_svc' do
  on_supported_os.each do |os, os_facts|
      let(:facts) { os_facts }
      let(:title) { 'example.conf' }

      let(:params) do
        {
          :vhost_path => '/etc/httpd/conf/example.conf',
          :listen_ip   => '192.168.254.2',
          :websvc_port => 8080,   
        }
      end

      let :pre_condition do
        'include my_webapp'
      end

    context 'virtual_svc example' do

      it { is_expected.to compile }


      it { is_expected.to contain_file('example.conf')
        .with('path'   => '/etc/httpd/conf/example.conf')
        .with('ensure' => 'present')
        .with('content' => %r{ServerName www.example.com})
      }
    end
  end
end
