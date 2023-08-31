@REM Name: auto-nodev
@REM Version: 1.0.0
@REM Author: AnsChaser
@REM Email: anschaser.163.com

@echo off

setlocal EnableDelayedExpansion

set $tmpdir=.\node_modules
set $local_nodever_fname=.node-version
if not exist !$local_nodever_fname! (goto:end)

call:validate_tmpdir
set $nodes_root=
set $local_nodever=
call:load_nodes_root
call:load_local_nodever
set $required_nodedir=!$nodes_root!\!$local_nodever!
call:restore_tmpdir

if exist !$required_nodedir! (
    call:set_local_nodever
    echo [32mauto-nodev: local node version is !$local_nodever! now.[0m
) else (
    echo [31mauto-nodev: required node version !$local_nodever! not found.[0m
    echo [33mauto-nodev: using global node version now.[0m
)

endlocal & set PATH=%PATH%


rem -------------------------------------------------------------
goto :eof

:validate_tmpdir
    if not exist !$tmpdir! (
        mkdir !$tmpdir!
        set $rmtmpdir=true)
goto :eof

:restore_tmpdir
    if !$rmtmpdir! equ true (
        rmdir !$tmpdir!)
goto :eof

:load_local_nodever
    set $local_nodever_tmpfpath=!$tmpdir!\!$local_nodever_fname!
    type !$local_nodever_fname! > !$local_nodever_tmpfpath!
    for /f "delims=*" %%i in (!$local_nodever_tmpfpath!) do (
        set $local_nodever=%%i)
    del !$local_nodever_tmpfpath!
goto :eof

:load_nodes_root
    if "%AUTO_NODEV_NODES_ROOT%" neq "" (
        set $nodes_root=%AUTO_NODEV_NODES_ROOT%
    ) else (
        set $echo_tmpfpath=!$tmpdir!\.nvm-root
        nvm root > !$echo_tmpfpath!
        for /f "delims=*" %%i in (!$echo_tmpfpath!) do (
            set $nodes_root=%%i)
        for /f "tokens=1* delims=:" %%a in ("!$nodes_root!") do (
            set $nodes_root=%%b)
        :loop-lstrip
        if "!$nodes_root:~0,1!" equ " " (
            set $nodes_root=!$nodes_root:~1!
            goto :loop-lstrip)
        :loop-rstrip
        if "!$nodes_root:~-1!" equ " " (
            set $nodes_root=!$nodes_root:~0,-1!
            goto :loop-rstrip)
        del !$echo_tmpfpath!
    )
goto :eof

:set_local_nodever
    set $unchecked_paths=%PATH%
    set $newpaths=!$required_nodedir!
    :loop-filter
    for /f "tokens=1* delims=;" %%a in ("!$unchecked_paths!") do (
        set $unchecked_paths=%%b
        set $path=%%a
        set $path_escaped=
        call:escape_path "!$path!"
        if not exist !$path!\node.exe if not exist !$path_escaped!\node.exe (
            set $newpaths=!$newpaths!;!$path!)
        if "%%b" neq "" goto:loop-filter
    )
    set PATH=!$newpaths!
goto :eof

:escape_path
    rem the first param must be wrapped by ""
    set $path_escaped=%1
    set $path_escaped=!$path_escaped:~1,-1!
goto :eof

:end
@rem -------------------------------------------------------------