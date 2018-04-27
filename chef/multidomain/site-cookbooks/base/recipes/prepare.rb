#
# Cookbook Name:: base
# Recipe:: prepare
#
# Copyright 2018, Magic3 Project.
#
# All rights reserved - Do Not Redistribute
#
#******************************************************
#
# 既存パッケージ更新
#
#******************************************************
execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end
#******************************************************
#
# パッケージレポジトリ追加
#
# ・EPELリポジトリ
# ・Remiリポジトリ
#
#******************************************************
yum_package "epel-release" do
  action :install
end
remote_file "#{Chef::Config[:file_cache_path]}/#{node['base']['remi-release']}" do
  source "http://rpms.famillecollet.com/enterprise/#{node['base']['remi-release']}"
  notifies :install, "rpm_package[remi-release_package]", :immediately
  not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/#{node['base']['remi-release']}") }
end
rpm_package "remi-release_package" do
  source "#{Chef::Config[:file_cache_path]}/#{node['base']['remi-release']}"
  action :nothing
end
#******************************************************
#
# 追加パッケージインストール
#
# ・wget
# ・mailコマンド
# ・expectパッケージ(mkpasswd等)
# ・zip,unzipコマンド
# ・nmapコマンド(ポートスキャン)
#
#******************************************************
package "wget" do
  action :install
end
package "mailx" do
  action :install
end
package "expect" do
  action :install
end
package "zip" do
  action :install
end
package "unzip" do
  action :install
end
package "nmap" do
  action :install
end
