#
# Cookbook Name:: magic3-env
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"

log '##### Recipe start: magic3-env #####'

#******************************************************
#
# Magic3独自環境作成
#
# ・root用環境ファイル
#
#******************************************************
template "/root/.bash_profile" do
  source   'root_bash_profile.erb'
  owner    'root'
  group    'root'
  mode     '0755'
end
# 管理ツールディレクトリ作成
directory "/root/tools" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
directory "/root/tools/template" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
directory "/root/magic3_new" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
template "/root/tools/createdomain.sh" do
  source   'root_tools/createdomain.sh.erb'
  owner    'root'
  group    'root'
  mode     '0755'
end
template "/root/tools/removedomain.sh" do
  source   'root_tools/removedomain.sh.erb'
  owner    'root'
  group    'root'
  mode     '0755'
end
template "/root/tools/updatemagic3src.sh" do
  source   'root_tools/updatemagic3src.sh.erb'
  owner    'root'
  group    'root'
  mode     '0755'
end
template "/root/tools/awstatsinit.sh" do
  source   'root_tools/awstatsinit.sh.erb'
  owner    'root'
  group    'root'
  mode     '0755'
end
template "/root/tools/awstatsreport.sh" do
  source   'root_tools/awstatsreport.sh.erb'
  owner    'root'
  group    'root'
  mode     '0755'
end
# 運用ディレクトリ作成
directory "/var/magic3" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
# サーバ管理ツール(Web用)ディレクトリ作成
directory "/var/www/magic3" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
directory "/var/www/magic3/stools" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
directory "/var/www/magic3/member" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
#******************************************************
#
# MariaDB設定ファイル読み込み
#
#******************************************************
template "/etc/my.cnf.d/server.cnf" do
  source "mariadb_server.cnf.erb"
  mode 0644
  notifies :restart, 'service[mysql]'
end

#******************************************************
#
# PHP設定ファイル読み込み
#
#******************************************************
template "/etc/php.ini" do
  source "php.ini.erb"
  mode 0644
  notifies :restart, 'service[apache2]'
end
#******************************************************
#
# Apache設定ファイル読み込み
#
#******************************************************
#****** Apache2管理外モジュール追加 *****
# Apache-PHP連携
link '/etc/httpd/mods-enabled/php.conf' do
  to '/etc/httpd/mods-available/php.conf'
  only_if 'test -f /etc/httpd/mods-available/php.conf'
  notifies :restart, 'service[apache2]'
end
#****** 不要な設定ファイルを削除 *****
%w[welcome].each do |f|
  file "#{node['apache']['dir']}/conf.d/#{f}.conf" do
    action :delete
    backup false
  end
end

#****** 基本設定 *****
template 'apache2.conf' do
  case node['platform_family']
  when 'rhel', 'fedora', 'arch'
    path "#{node['apache']['dir']}/conf/httpd.conf"
  when 'debian'
    path "#{node['apache']['dir']}/apache2.conf"
  when 'freebsd'
    path "#{node['apache']['dir']}/httpd.conf"
  end
  source   'apache2.conf.erb'
  owner    'root'
  group    'root'
  mode     '0644'
  notifies :restart, 'service[apache2]'
end

# エラーメッセージ
directory "/var/www/error" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
directory "/var/www/error/service" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
cookbook_file "/var/www/error/service/forbidden.html" do
  source   'error/forbidden.html'
  owner    'root'
  group    'root'
  mode     '0644'
end
cookbook_file "/var/www/error/service/notfound.html" do
  source   'error/notfound.html'
  owner    'root'
  group    'root'
  mode     '0644'
end
cookbook_file "/var/www/error/service/unauthorized.html" do
  source   'error/unauthorized.html'
  owner    'root'
  group    'root'
  mode     '0644'
end
#******************************************************
#
# phpMyAdminインストール
#
#******************************************************
remote_file "#{Chef::Config[:file_cache_path]}/phpMyAdmin-#{node['magic3-env']['phpmyadmin_version']}-all-languages.tar.gz" do
  source "https://files.phpmyadmin.net/phpMyAdmin/#{node['magic3-env']['phpmyadmin_version']}/phpMyAdmin-#{node['magic3-env']['phpmyadmin_version']}-all-languages.tar.gz"
  notifies :run, "bash[install_phpmyadmin]", :immediately
  not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/phpMyAdmin-#{node['magic3-env']['phpmyadmin_version']}-all-languages.tar.gz") }
end
bash "install_phpmyadmin" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar oxzf phpMyAdmin-#{node['magic3-env']['phpmyadmin_version']}-all-languages.tar.gz
    mv phpMyAdmin-#{node['magic3-env']['phpmyadmin_version']}-all-languages #{node['magic3-env']['phpmyadmin_dir']}
  EOH
  action :nothing
end
template "#{node['magic3-env']['phpmyadmin_dir']}/config.inc.php" do
  source   'phpmyadmin_config.inc.php.erb'
  owner    'root'
  group    'root'
  mode     '0644'
end
#******************************************************
#
# AWStatsインストール
#
# ・インストールバージョンは//github.com/czbone/awstats-japaneseのdefault['magic3-env']['awstats_version']
#
#******************************************************
# ディレクトリ作成
directory "/etc/awstats" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
directory "#{node['magic3-env']['awstats_dir']}" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
directory "#{node['magic3-env']['awstats_dir']}/data" do
  owner   'root'
  group   'root'
  mode    '0755'
  action  :create
end
# 日本語バージョンインストール
remote_file "#{Chef::Config[:file_cache_path]}/awstats-master.tar.gz" do
  source "https://github.com/czbone/awstats-japanese/archive/master.tar.gz"
  notifies :run, "bash[install_awstats]", :immediately
end
bash "install_awstats" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xzf awstats-master.tar.gz
    mv awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/docs #{node['magic3-env']['awstats_doc']}/awstats-#{node['magic3-env']['awstats_version']}
    mv -f awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/tools/awstats_buildstaticpages.pl /usr/bin/
    mv -f awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/tools/awstats_exportlib.pl /usr/bin/
    mv -f awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/tools/awstats_updateall.pl /usr/bin/
    mv -f awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/tools/logresolvemerge.pl /usr/bin/
    mv -f awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/tools/maillogconvert.pl /usr/bin/
    mv -f awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/tools/urlaliasbuilder.pl /usr/bin/
    mv -f awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/tools/awstats_configure.pl /usr/bin/
    chmod 755 /usr/bin/awstats_buildstaticpages.pl
    chmod 755 /usr/bin/awstats_exportlib.pl
    chmod 755 /usr/bin/awstats_updateall.pl
    chmod 755 /usr/bin/logresolvemerge.pl
    chmod 755 /usr/bin/maillogconvert.pl
    chmod 755 /usr/bin/urlaliasbuilder.pl
    mv -f awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/wwwroot/cgi-bin/awstats.model.conf /etc/awstats/
    rm -rf #{node['magic3-env']['awstats_dir']}
    mv awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/wwwroot/cgi-bin #{node['magic3-env']['awstats_dir']}
    mv awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/wwwroot/classes #{node['magic3-env']['awstats_dir']}/
    mv awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/wwwroot/css #{node['magic3-env']['awstats_dir']}/
    mv awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/wwwroot/icon #{node['magic3-env']['awstats_dir']}/
    mv awstats-japanese-master/awstats-#{node['magic3-env']['awstats_version']}/wwwroot/js #{node['magic3-env']['awstats_dir']}/
    chmod 755 #{node['magic3-env']['awstats_dir']}/awredir.pl
    chmod 755 #{node['magic3-env']['awstats_dir']}/awstats.pl
	chmod 755 #{node['magic3-env']['awstats_dir']}/awdownloadcsv.pl
  EOH
  action :nothing
end
template "/etc/cron.hourly/00awstats" do
  source   '00awstats.erb'
  owner    'root'
  group    'root'
  mode     '0755'
end
template "/etc/logrotate.d/httpd" do
  source   'logrotate_httpd.erb'
  owner    'root'
  group    'root'
  mode     '0644'
end
# 追加ドメイン用設定ファイルのテンプレートファイル
template "/root/tools/template/awstats.model.conf" do
  source   'root_tools/awstats.model.conf.erb'
  owner    'root'
  group    'root'
  mode     '0644'
end
# 追加モジュールインストール
cpan_module 'Geo::IPfree'

#******************************************************
#
# Magic3最新ソースの取得
#
#******************************************************
remote_file "#{Chef::Config[:file_cache_path]}/magic3_#{node['magic3-env']['magic3_arc_ver']}.tar.gz" do
  source "https://api.github.com/repos/magic3org/magic3/tarball/v#{node['magic3-env']['magic3_arc_ver']}"
  notifies :run, "bash[install_magic3_archive]", :immediately
  not_if { ::File.exists?("/root/magic3_new/magic3_#{node['magic3-env']['magic3_arc_ver']}.tar.gz") }
end
bash "install_magic3_archive" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    rm -f /root/magic3_new/*
    mv magic3_#{node['magic3-env']['magic3_arc_ver']}.tar.gz /root/magic3_new
	echo #{node['magic3-env']['magic3_arc_ver']} > #{node['magic3-env']['magic3_var_dir']}/src_version
  EOH
  action :nothing
end

log '##### Recipe end: magic3-env #####'
