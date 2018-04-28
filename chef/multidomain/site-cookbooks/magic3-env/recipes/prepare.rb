#
# Cookbook Name:: magic3-env
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"

#******************************************************
#
# PHPモジュールインストール
#
#******************************************************
node['php']['packages'].each do |pkg|
  package pkg do
    action :install
    options "#{node['php']['options']}"
  end
end
