echo "************ %~n0 ******************"
@ECHO ON

mkdir %LIBRARY_PREFIX%/tmp

mkdir forgebuild
cd forgebuild

@REM pkg-config setup
FOR /F "delims=" %%i IN ('cygpath.exe -m "%LIBRARY_PREFIX%"') DO set "LIBRARY_PREFIX_M=%%i"
set PKG_CONFIG_PATH=%LIBRARY_PREFIX_M%/lib/pkgconfig

@REM Work around a Windows build failure in Python 3.6. This is unneeded in 3.7.
@REM See https://www.python.org/dev/peps/pep-0528/ and https://github.com/mesonbuild/meson/issues/4827 .
set "PYTHONLEGACYWINDOWSSTDIO=1"
set "PYTHONIOENCODING=UTF-8"

%PYTHON% %PREFIX%\Scripts\meson --buildtype=release --prefix=%LIBRARY_PREFIX% --backend=ninja  ..
if errorlevel 1 exit 1

ninja -v
if errorlevel 1 exit 1

@rem ninja test
@rem if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1

del %LIBRARY_PREFIX%\bin\*.pdb

@REM For some reason conda-build decides that the meson files in Scripts are new?
del %PREFIX%\Scripts\meson* %PREFIX%\Scripts\wraptool*
