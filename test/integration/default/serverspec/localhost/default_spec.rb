require 'spec_helper'

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
