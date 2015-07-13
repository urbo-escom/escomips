@echo off
setlocal EnableExtensions EnableDelayedExpansion

pushd %~dp0
pushd util
set PATH=%CD%;%PATH%
popd
popd
make.exe %*

endlocal
