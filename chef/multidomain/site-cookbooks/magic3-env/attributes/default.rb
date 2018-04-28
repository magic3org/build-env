#
# Cookbook Name:: magic3-env
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#******************************************************
#
# Magic3構築環境
#
#******************************************************
# 管理用ログインアカウント、パスワード
default['magic3-env']['mailto']     = 'root'  # デフォルトメール送信先
# 管理用ドメイン情報
default['magic3-env']['server_name']                  = '---'   # サーバ名
# Magic3の情報
default['magic3-env']['magic3_arc_ver']               = '2.30.9'    # 最新ソースバージョン
# その他
default['magic3-env']['phpmyadmin_version']           = '4.8.0.1'	# PHP5.5以上
default['magic3-env']['awstats_version']              = '7.7'
default['magic3-env']['awstats_cron_conf']            = '/etc/cron.d/awstatsreport'
default['magic3-env']['magic3_arc_dir']               = '/root/magic3_new'
default['magic3-env']['magic3_tools_dir']             = '/root/tools'
default['magic3-env']['magic3_var_dir']               = '/var/magic3'
default['magic3-env']['ssl_server_key_filename']      = 'server.key'
default['magic3-env']['ssl_crt_filename']             = 'server.crt'
default['magic3-env']['ssl_error_log']                = 'ssl_error.log'
default['magic3-env']['ssl_access_log']               = 'ssl_access.log'
default['magic3-env']['local_error_log']              = 'private_error.log'
default['magic3-env']['local_access_log']             = 'private_access.log'
default['magic3-env']['vhost_error_log']              = 'error_log'
default['magic3-env']['vhost_access_log']             = 'access_log'

#******************************************************
#
# phpMyAdminの設定
#
#******************************************************
default['magic3-env']['phpmyadmin_dir'] = '/var/www/magic3/stools/phpmyadmin'
default['magic3-env']['awstats_dir'] = '/var/www/awstats'
default['magic3-env']['awstats_doc'] = '/usr/share/doc'
default['magic3-env']['awstats_prog'] = 'awstats.pl'
