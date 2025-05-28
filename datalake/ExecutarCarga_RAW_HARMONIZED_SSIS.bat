@echo off
setlocal

:: Cria a variável com a data e hora formatada para usar no nome do arquivo de log
set "datetime=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "datetime=%datetime: =0%"

:: Cria a variável com o caminho da pasta onde está o .bat
set "folder=%~dp0"

:: Cria a variável com o caminho da pasta dos executaveis das cargas
set "folderexec=C:\Users\mateus.lopes\source\repos\VMIS_CI_Datalake_Project\"

:: Define o nome do arquivo de log
set "logfile=%folder%Log_Carga_%datetime%.txt"

echo Início do processo em %datetime% > "%logfile%"

:: Executa carga RAW
echo ================= INICIANDO CARGA RAW ================= >> "%logfile%"
dtexec /F "%folderexec%Carga_RAW.dtsx" >> "%logfile%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERRO na carga RAW. Encerrando processo. >> "%logfile%"
    exit /b %ERRORLEVEL%
)
echo ================= FIM CARGA RAW ================= >> "%logfile%"

:: Executa carga HARMONIZED
echo ================= INICIANDO CARGA HARMONIZED ================= >> "%logfile%"
dtexec /F "%folderexec%Carga_HARMONIZED.dtsx" >> "%logfile%" 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERRO na carga HARMONIZED. >> "%logfile%"
    exit /b %ERRORLEVEL%
)
echo ================= FIM CARGA HARMONIZED ================= >> "%logfile%"

echo Processo concluído com sucesso em %datetime% >> "%logfile%"

endlocal
