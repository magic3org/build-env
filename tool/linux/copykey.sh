#!/bin/bash

# コマンドが0以外で終了した場合、即座にスクリプトを終了
set -e

# 引数なかったらエラー
if [ -z "$1" ] ; then
    echo "エラー: SSHキーファイル名を入力してください。[書式] copykey SSHキーファイル名"
    
    exit 1
fi

### SSH public key
mkdir -p /root/.ssh

mv $1 /root/.ssh/authorized_keys

chmod 600 /root/.ssh/authorized_keys
