#
# Cookbook Name:: namazu 
# Recipe:: default 
#
# Author:: Ryuzee <ryuzee@gmail.com>
#
# Copyright 2012, Ryutaro YOSHIBA 
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

include_recipe "build-essential"

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
