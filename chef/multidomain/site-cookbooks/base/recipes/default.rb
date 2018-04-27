#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2018, Magic3 Project.
#
# All rights reserved - Do Not Redistribute
#

#******************************************************
#
# ファイアウォールの設定
#
#******************************************************
service 'firewalld' do
  supports [ :restart, :reload ]
  action [ :enable, :start ]
end
execute 'firewalld_http' do
  command 'firewall-cmd --permanent --zone=public --add-service=http'
  notifies :restart, 'service[firewalld]'
end
execute 'firewalld_https' do
  command 'firewall-cmd --permanent --zone=public --add-service=https'
  notifies :restart, 'service[firewalld]'
end
