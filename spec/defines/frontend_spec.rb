require 'spec_helper'

describe 'haproxy::frontend' do
  let(:title) { 'tyler' }
  let(:facts) {{ :ipaddress => '1.1.1.1' }}
  context "when only one port is provided" do
    let(:params) do
      {
        :name  => 'croy',
        :ports => '18140'
      }
    end

    it { should contain_concat__fragment('croy_frontend_block').with(
      'order'   => '15-croy-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend croy\n  bind 1.1.1.1:18140\n  option  tcplog\n"
    ) }
  end
  context "when only one port is provided with ssl cert" do
    let(:params) do
      {
        :name  => 'croy',
        :ports => '18140',
        :ssl_off_load => true,
        :ssl_certs     => {'1.1.1.1:18140' => '/path/to/my/cert'},
      }
    end

    it { should contain_concat__fragment('croy_frontend_block').with(
      'order'   => '15-croy-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend croy\n  bind 1.1.1.1:18140 ssl crt /path/to/my/cert\n  option  tcplog\n"
    ) }
  end
  context "when an array of ports is provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => [
          '80',
          '443'
        ]
      }
    end

    it { should contain_concat__fragment('apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 23.23.23.23:80\n  bind 23.23.23.23:443\n  option  tcplog\n"
    ) }
  end
  context "when array of ports is provided with ssl cert" do
    let(:params) do
      {
        :name  => 'croy',
        :ipaddress => '23.23.23.23',
        :ports     => [
          '443',
          '8443'
        ],
        :ssl_off_load => true,
        :ssl_certs     => {
          '23.23.23.23:443' => '/path/to/my/cert1',
          '23.23.23.23:8443' => '/path/to/my/cert2'
        },
      }
    end

    it { should contain_concat__fragment('croy_frontend_block').with(
      'order'   => '15-croy-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend croy\n  bind 23.23.23.23:443 ssl crt /path/to/my/cert1\n  bind 23.23.23.23:8443 ssl crt /path/to/my/cert2\n  option  tcplog\n"
    ) }
  end
  context "when a comma-separated list of ports is provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => '80,443'
      }
    end

    it { should contain_concat__fragment('apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 23.23.23.23:80\n  bind 23.23.23.23:443\n  option  tcplog\n"
    ) }
  end
  context "when array of ports is provided with ssl cert and a reqadd" do
    let(:params) do
      {
        :name  => 'croy',
        :ipaddress    => '23.23.23.23',
        :ports        => [
          '80',
          '443'
        ],
        :ssl_off_load => true,
        :ssl_certs     => {'23.23.23.23:443' => '/path/to/my/cert'},
        :reqadds       => ['X-Forwarded-Proto:\ https if { is_ssl }']
      }
    end

    it { should contain_concat__fragment('croy_frontend_block').with(
      'order'   => '15-croy-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend croy\n  bind 23.23.23.23:80\n  bind 23.23.23.23:443 ssl crt /path/to/my/cert\n  option  tcplog\n"
    ) }
  end
end
