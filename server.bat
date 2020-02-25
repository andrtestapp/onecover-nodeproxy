cd C:\node\onecover-nodeproxy-develop
call env.bat

SC stop "1C:Enterprise 8.3 Server Agent (x86-64)"
timeout 10
start /min "" "C:/Program Files/1cv8/8.3.14.1751/bin/dbgs.exe" -a %DEBUG_ADR% -p %DEBUG_PORT%
start /min npm start
SC start "1C:Enterprise 8.3 Server Agent (x86-64)"
timeout 10
start /min "" "C:/Program Files/1cv8/8.3.14.1751/bin/1cv8.exe" DESIGNER /S%IBConnectionString% /debug -http -attach /debuggerURL%PROXY_URL% /AppAutoCheckMode /N "CI" /P "8HRUYXL2UC"
