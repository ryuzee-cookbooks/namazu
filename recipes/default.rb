#
# Cookbook Name:: namazu 
# Recipe:: default 
#
# Author:: Ryuzee <ryuzee@gmail.com>
#
# Copyright 2012, Ryutaro YOSHIBA 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in wrhiting, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "nkf" do
  action :install
end

package "perl-ExtUtils-MakeMaker" do
  action :install
  only_if { node['platform'] == "centos" and node['platform_version'] >= "6.0" }
end

namazu_version = node['namazu']['version']
kakasi_version = node['namazu']['kakasi_version']

remote_file "#{Chef::Config[:file_cache_path]}/kakasi-#{kakasi_version}.tar.gz" do
  source "http://kakasi.namazu.org/stable/kakasi-#{kakasi_version}.tar.gz"
  mode "0644"
  not_if { ::File.exists?("/usr/local/bin/kakasi") }
end

bash "build-and-install-kakasi" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    tar xvfz kakasi-#{kakasi_version}.tar.gz && 
    cd kakasi-#{kakasi_version} && 
    ./configure && make && make install
  EOF
  not_if { ::File.exists?("/usr/local/bin/kakasi") }
end

remote_file "#{Chef::Config[:file_cache_path]}/namazu-#{namazu_version}.tar.gz" do
  source "http://www.namazu.org/stable/namazu-#{namazu_version}.tar.gz"
  mode "0644"
  not_if { ::File.exists?("/usr/local/bin/mknmz") }
end

bash "build-and-install-namazu" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    tar xvfz namazu-#{namazu_version}.tar.gz && 
    cd namazu-#{namazu_version} && 
    cd File-MMagic && 
    perl Makefile.PL && make && make install && 
    cd .. && 
    ./configure && make && make install ;
  EOF
  not_if { ::File.exists?("/usr/local/bin/mknmz") }
end

# vim: filetype=ruby.chef
