@ECHO ON

:: set pkg-config path so that host deps can be found
:: (set as env var so it's used by both meson and during build with g-ir-scanner)
set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig"

:: get mixed path (forward slash) form of prefix so host prefix replacement works
set "LIBRARY_PREFIX_M=%LIBRARY_PREFIX:\=/%"

rem Requires.private and Libs.private
rem Are not meaningful in the context of shared libraries for conda-forge
rem We thus "remove them" outright to avoid
rem burdening the recipe
rem https://github.com/conda-forge/harfbuzz-feedstock/pull/146
rem https://github.com/conda-forge/conda-forge.github.io/issues/1880

rem Remove Requires.private and Libs.private from all .pc files
for %%D in ("%LIBRARY_PREFIX%\lib\pkgconfig") do (
    if exist "%%~D" (
        for /r "%%~D" %%F in (*.pc) do (
            findstr /V /R /C:"^Requires\.private" /C:"^Libs\.private" "%%F" > "%%F.tmp"
            move /Y "%%F.tmp" "%%F" >nul
        )
    )
)


meson setup builddir ^
    %MESON_ARGS% ^
    --wrap-mode=nofallback ^
    --prefix=%LIBRARY_PREFIX_M% ^
    --backend=ninja ^
    -Dexamples=disabled ^
    -Dintrospection=enabled ^
    -Dtests=disabled ^
    -Dc_link_args=intl.dll.lib
if errorlevel 1 exit 1

ninja -v -C builddir -j %CPU_COUNT%
if errorlevel 1 exit 1

ninja -C builddir install -j %CPU_COUNT%
if errorlevel 1 exit 1

del %LIBRARY_PREFIX%\bin\*.pdb
