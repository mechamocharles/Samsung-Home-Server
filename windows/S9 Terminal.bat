@echo off
title Terminal S9+
REM Abre o terminal do celular (Termux) via SSH.
REM Edite a linha abaixo com o IP do seu celular (comando "status" no Termux).
set S9=IP-DO-CELULAR
ssh -p 8022 %S9%
echo.
echo Conexao encerrada.
pause
