::
:: SSH�L�[�t�@�C���쐬�X�N���v�g
::
:: ����
::  v1.0 2018/4/15 �V�K�쐬
::  v1.1 2018/4/16 SSH�L�[�C���X�g�[���ǉ�
::
@echo off
:: �J�����g�f�B���N�g���̐ݒ�
cd /d %~dp0

:: �p�����[�^�`�F�b�N
if "%1"=="" (
	echo �t�H�[�}�b�g: ����1^(�T�[�oID^) ����2^(IP�A�h���X^)
	exit
)
if "%2"=="" (
	echo �t�H�[�}�b�g: ����1^(�T�[�oID^) ����2^(IP�A�h���X^)
	exit
)

echo �L�[�쐬�J�n...

:: �v��`�p�����[�^
set SERVICE_NAME=������VPS
set SERVICE_NAME_HEAD=sakura_vps_
set TERATERM_DIRNAME=�T�[�o�ڑ�
set DEVELOP_DIR=E:\develop
set KEY_DIR=%DEVELOP_DIR%\key\keys
set INIT_TOOL_DIR=%DEVELOP_DIR%\key\install

:: ���̑��p�����[�^
set SERVER_ID=%1%
set IP=%2%
set USER=root
set KEY_FILENAME=%SERVICE_NAME_HEAD%%SERVER_ID%_%IP%
set KEYFILE=%KEY_DIR%\%KEY_FILENAME%
set SSH_CONFIG=%USERPROFILE%\.ssh\config
set TERATERM_DIR=%DEVELOP_DIR%\%TERATERM_DIRNAME%
set TERATERM_FILE=%TERATERM_DIR%\%SERVICE_NAME%_%SERVER_ID%^(%IP%^).ttl
set INSTALL_TOOL_FILE=%INIT_TOOL_DIR%\%SERVICE_NAME_HEAD%%SERVER_ID%^(%IP%^)_installer.sh

:: �L�[�t�@�C�������݂���ꍇ�͏I��
if exist %KEYFILE% (
	echo �G���[: �L�[�t�@�C��^(%KEYFILE%^)�����݂��܂�
	exit
)

:: �L�[�t�@�C���쐬
mkdir %KEY_DIR%
echo %KEYFILE%
ssh-keygen -f %KEYFILE% -t rsa -N "" -C %USER%@%IP%

:: SSH��`�ǉ�
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
echo SSH��`�t�@�C��^(%SSH_CONFIG%^)���X�V���܂���

:: TeraTerm�p�ݒ�t�@�C���ǉ�
mkdir %TERATERM_DIR%
(
echo ;============================================ 
echo ; �T�[�o�ڑ��p�X�N���v�g
echo ; �@�\�F�閧�����g�p����SSH�ڑ�����
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
echo Tera Term�p�T�[�o�ڑ��p�X�N���v�g^(%TERATERM_FILE%^)���쐬���܂���

:: TeraTerm�p�ݒ�t�@�C���ǉ�
set /p PUB_KEY_DATA=<%KEYFILE%.pub
mkdir %INIT_TOOL_DIR%
(
echo #!/bin/bash
echo set -e
echo.
echo # create directory
echo mkdir -p /root/.ssh
echo.
echo # create key file
echo echo "%PUB_KEY_DATA%" ^^^> /root/.ssh/authorized_keys
echo chmod 600 /root/.ssh/authorized_keys
) | tr -d '\r' > %INSTALL_TOOL_FILE%

echo �I��
