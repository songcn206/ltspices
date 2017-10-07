rem forfilesコマンド -- http://www.atmarkit.co.jp/ait/articles/0902/27/news132.html
rem コマンドの実行結果を変数に代入する -- http://hanjyuku.info/mt/memo/2011/04/cmd20110407-2155.html
echo off

del *.asc *.asy
rem カレントディレクトリ取得
for /f "usebackq tokens=*" %%a in (`cd`) do @set TARGET=%%a

rem ファイルをコピーする
forfiles /p ..\lib /s /m *.asc /c "cmd /c @copy /Y @path %TARGET%"
forfiles /p ..\lib /s /m *.asy /c "cmd /c @copy /Y @path %TARGET%"
forfiles /p ..\lib /s /m *.sub /c "cmd /c @copy /Y @path %TARGET%"

rem テスト用ファイルは除外
del *.test.asc

pause -1