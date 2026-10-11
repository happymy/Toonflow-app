@echo off
chcp 65001 >nul
title Toonflow 本地调试
cd /d "%~dp0"

echo ============================================
echo   Toonflow 本地调试启动器
echo ============================================

if not exist node_modules (
    echo [1/3] 首次运行，正在安装依赖（国内镜像 npmmirror）...
    call bun install
    if errorlevel 1 goto :fail
) else (
    echo [1/3] 依赖已就绪
)

echo [2/3] 启动后端服务（端口 3000，热重载）...
start "Toonflow Server" cmd /k "cd /d %~dp0 && bun run --filter @toonflow/server dev"
timeout /t 3 /nobreak >nul

echo [3/3] 启动前端 Vite（端口 5173，热更新）...
start "Toonflow Web" cmd /k "cd /d %~dp0 && bun run --filter @toonflow/web dev"

echo.
echo ============================================
echo   启动完成！
echo   前端:  http://localhost:5173
echo   后端:  http://localhost:3000
echo   关闭对应窗口即可停止服务
echo ============================================
pause
goto :eof

:fail
echo.
echo [错误] 依赖安装失败，请检查网络后重试。
echo 手动执行: bun install
pause
goto :eof