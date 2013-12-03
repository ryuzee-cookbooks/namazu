require 'serverspec'
include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.os = backend(Serverspec::Commands::Base).check_os
  end
  c.path = "/sbin:/usr/sbin"
end

describe package('nkf') do
  it { should be_installed }
end

describe file('/usr/local/bin/kakasi') do
  it { should be_file }
  it { should be_mode 755 }
end

describe file('/usr/local/bin/mknmz') do
  it { should be_file }
  it { should be_mode 755 }
end
