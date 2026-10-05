@echo off
title Painel Homeserver S9+
REM Edite a linha abaixo com o IP do seu celular (comando "status" no Termux).
set S9=IP-DO-CELULAR
set PORTA=8022
set SSH=ssh -p %PORTA% %S9%

:menu
cls
echo ==========================================
echo         HOMESERVER S9+  (%S9%)
echo ==========================================
echo  1. Abrir terminal do celular
echo  2. Ver status dos servicos
echo  3. Ver logs de um servico (Ctrl+C para sair)
echo  4. Reiniciar um servico
echo  5. Abrir no navegador um servico web (porta)
echo  6. Enviar arquivo para o servidor (~/files)
echo  7. Baixar arquivos de ~/files/backups para o PC
echo  8. Configurar login sem senha (uma vez so)
echo  0. Sair
echo ==========================================
set OP=
set /p OP=Escolha uma opcao:

if "%OP%"=="1" ( %SSH% & goto fim )
if "%OP%"=="2" ( %SSH% "bash -lc status" & goto fim )
if "%OP%"=="3" goto logs
if "%OP%"=="4" goto reiniciar
if "%OP%"=="5" goto navegador
if "%OP%"=="6" goto enviar
if "%OP%"=="7" goto baixar
if "%OP%"=="8" goto chave
if "%OP%"=="0" exit /b
goto menu

:logs
set SVC=
set /p SVC=Nome do servico (ex.: sshd, crond, meu-site):
if not defined SVC goto menu
ssh -t -p %PORTA% %S9% "tail -n 60 -f $PREFIX/var/log/sv/%SVC%/current"
goto fim

:reiniciar
set SVC=
set /p SVC=Nome do servico (ex.: sshd, crond, meu-site):
if not defined SVC goto menu
%SSH% "bash -lc 'sv restart %SVC%; sleep 3; sv status %SVC%'"
goto fim

:navegador
set PT=
set /p PT=Porta do servico web (ex.: 8080):
if not defined PT goto menu
start "" http://%S9%:%PT%
goto menu

:enviar
echo Arraste o arquivo para esta janela e aperte Enter:
set ARQ=
set /p ARQ=
if not defined ARQ goto menu
scp -P %PORTA% %ARQ% %S9%:files/
goto fim

:baixar
if not exist "%~dp0backups" mkdir "%~dp0backups"
scp -P %PORTA% "%S9%:files/backups/*" "%~dp0backups"
echo Arquivos salvos em: %~dp0backups
goto fim

:chave
if not exist "%USERPROFILE%\.ssh\id_ed25519" ssh-keygen -t ed25519 -N "" -f "%USERPROFILE%\.ssh\id_ed25519"
type "%USERPROFILE%\.ssh\id_ed25519.pub" | %SSH% "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
echo.
echo Pronto! A partir de agora o SSH nao pede mais senha neste PC.
goto fim

:fim
echo.
pause
goto menu
