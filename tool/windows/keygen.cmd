::
:: SSHキーファイル作成スクリプト
::
:: 履歴
::  v1.0 2018/4/15 新規作成
::
@echo off
:: カレントディレクトリの設定
cd /d %~dp0

:: パラメータチェック
if "%1"=="" (
	echo フォーマット: 引数1^(サーバID^) 引数2^(IPアドレス^)
	exit
)
if "%2"=="" (
	echo フォーマット: 引数1^(サーバID^) 引数2^(IPアドレス^)
	exit
)

echo キー作成開始...

:: 要定義パラメータ
set SERVICE_NAME=さくらVPS
set SERVICE_NAME_HEAD=sakura_vps_
set TERATERM_DIRNAME=サーバ接続
set DEVELOP_DIR=E:\develop
set KEY_DIR=%DEVELOP_DIR%\key\keys

:: その他パラメータ
set SERVER_ID=%1%
set IP=%2%
set USER=root
set KEY_FILENAME=%SERVICE_NAME_HEAD%%SERVER_ID%_%IP%
set KEYFILE=%KEY_DIR%\%KEY_FILENAME%
set SSH_CONFIG=%USERPROFILE%\.ssh\config
set TERATERM_DIR=%DEVELOP_DIR%\%TERATERM_DIRNAME%
set TERATERM_FILE=%TERATERM_DIR%\%SERVICE_NAME%_%SERVER_ID%^(%IP%^).ttl

:: キーファイルが存在する場合は終了
if exist %KEYFILE% (
	echo エラー: キーファイル^(%KEYFILE%^)が存在します
	exit
)

:: キーファイル作成
mkdir %KEY_DIR%
echo %KEYFILE%
ssh-keygen -f %KEYFILE% -t rsa -N "" -C %USER%@%IP%

:: SSH定義追加
(
echo Host server-%SERVER_ID%
echo   HostName %IP%
echo   User root
echo   Port 22
echo   UserKnownHostsFile /dev/null
echo   StrictHostKeyChecking no
echo   PasswordAuthentication no
echo   IdentityFile "%KEY_DIR%\%KEY_FILENAME%"
echo   IdentitiesOnly yes
echo   LogLevel FATAL
) >> %SSH_CONFIG%
echo SSH定義ファイル^(%SSH_CONFIG%^)を更新しました

:: TeraTerm用設定ファイル追加
mkdir %TERATERM_DIR%
(
echo ;============================================ 
echo ; サーバ接続用スクリプト
echo ; 機能：秘密鍵を使用してSSH接続する
echo ;============================================ 
echo username = 'root'
echo hostname = '%IP%'
echo keyfile = '"%KEY_DIR%\%KEY_FILENAME%"'
echo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
echo msg = hostname
echo strconcat msg ':22 /ssh /2 /auth=publickey /user='
echo strconcat msg username
echo strconcat msg ' /keyfile='
echo strconcat msg keyfile
echo connect msg
) > %TERATERM_FILE%
echo Tera Term用サーバ接続用スクリプト^(%TERATERM_FILE%^)を作成しました

echo 終了
