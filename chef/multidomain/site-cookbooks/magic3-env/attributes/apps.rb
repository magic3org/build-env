#
# Cookbook Name:: magic3-env
# Recipe:: apps
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#******************************************************
#
# Magic3に直接関連しない設定を記述
#
#******************************************************
#******************************************************
#
# PHPの設定
#
#******************************************************
#
# PHP追加モジュール読み込み
#
default['php']['packages'] = ['php', 'php-mbstring', 'php-gd', 'php-mysql', 'php-xml', 'php-imap', 'php-mcrypt']

# PHP5.6用の設定
#default['php']['options'] = '--enablerepo=remi,remi-php56'

# PHP7用の設定
default['php']['options'] = '--enablerepo=remi,remi-php72'
default['apache']['mod_php']['module_name'] = 'php7'
default['apache']['mod_php']['so_filename'] = 'libphp7.so'

# デフォルト値設定
default['php']['date.timezone']       = 'Asia/Tokyo'
default['php']['post_max_size']       = '10M'
default['php']['upload_max_filesize'] = '10M'
default['php']['disable_functions']   = 'popen'

#******************************************************
#
# MySQLの設定
#
#******************************************************
default['mariadb']['use_default_repository'] = true
default['mariadb']['character-set-server']            = 'utf8'
#default['mariadb']['server_root_password']            = 'root'

#******************************************************
#
# OpenSSHの設定
#
#******************************************************
default['openssh']['server']['password_authentication'] = 'no'
default['openssh']['server']['max_auth_tries'] = '1'
default['openssh']['server']['max_sessions'] = '3'
default['openssh']['server']['max_startups'] = '2:90:4'
