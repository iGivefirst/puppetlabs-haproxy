require 'spec_helper'

describe 'haproxy::stats' do
  let(:title) {'stats'}
  let(:facts) {{ :ipaddress => '1.1.1.1' }}

  context "when default setup" do
    let (:params) do
      {
        :username => 'foo',
        :password => 'bar',
        :port     => 8080
      }
    end
    it { should contain_concat__fragment('1.1.1.1_stats_block').with(
      'order'   => '20-1.1.1.1-stats-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nlisten stats 1.1.1.1:8080\n  stats enable\n  stats hide-version\n  stats realm Haproxy\\ Statistics\n  stats uri /\n  stats auth foo:bar\n"
    ) }
  end

end
