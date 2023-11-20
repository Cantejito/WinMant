@echo Off
setlocal EnableExtensions
setlocal EnableDelayedExpansion
chcp 65001
set ver=0.19.1.0A
set url=https://raw.githubusercontent.com/Cantejito/WinMant/main/Mantenimiento_Windows.bat
set tempmant=C:\Windows\Temp\Mantenimiento_Windows.bat
title Versión %ver%
NET SESSION >nul 2>& 1
if %ERRORLEVEL% == 0 goto AVISO
MODE CON: COLS=82 LINES=11
COLOR 4F
echo ──────────────────────────────────────────────────────────────────────────────────
echo. & echo ───── ESTE SCRIPT REQUIERE SER EJECUTADA COMO ADMINISTRADOR.
echo. & echo ───── HAGA CLIC DERECHO EN EL ARCHIVO Y SELECCIONE "EJECUTAR COMO ADMINISTRADOR".
echo.
echo. & echo ───── Pulse INTRO para salir.
echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul & exit

:AVISO
MODE CON: COLS=82 LINES=37
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo [41m────────────────────────────────────IMPORTANTE────────────────────────────────────[0m[97m

echo. & echo ───── [7;95mNO ME HAGO RESPONSABLE DE PÉRDIDA DE DATOS Y/O PROBLEMAS CAUSADOS[0m[97m

echo. & echo ───── [41mREQUISITOS[0m[97m

echo. & echo ───── NO USAR SI HAY ACTUALIZACIONES EN CURSO

echo. & echo ───── TENER WINDOWS COMPLETAMENTE ACTUALIZADO

echo. & echo ───── [43mRECOMENDACIONES[0m[97m

echo. & echo ───── CERRAR TODOS LOS PROGRAMAS

echo. & echo ───── DESACTIVAR EL ANTIVIRUS PARA MEJORAR LA VELOCIDAD DE TRABAJO

echo. & echo ───── ESPERE A QUE SE COMPLETE LA OPERACIÓN ANTES DE CERRAR EL SCRIPT

echo. & echo ───── [44mINFORMACIÓN[0m[97m

echo. & echo ───── ALGUNAS FUNCIONES PUEDEN TARDAR VARIOS MINUTOS EN COMPLETARSE

echo. & echo [41m────────────────────────────────────IMPORTANTE────────────────────────────────────[0m[97m

echo. & echo ───── Pulse INTRO si ha leído, entiende y acepta todo lo anterior
echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul & CLS

:UPDATE
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [44mVersión actual: %ver%[0m

echo. & echo ───── [94mBuscando actualizaciones...[97m

	curl -o %tempmant% %url% -s
		if errorlevel 1 (
			echo.
			echo ───── [93mError al conectarse a internet
				timeout 5 >nul
					goto MENU
		)
	
	findstr /C:"set ver=" %tempmant% > %tempmant%.new
		set /p ver_new=<"%tempmant%.new"
			for /f "tokens=2 delims==" %%A in ("!ver_new!") do set "ver_new=%%A"
				del "%tempmant%.new"
				
	if %ver% neq %ver_new% (
		echo. & echo ───── [92mNueva versión disponible: %ver_new%[97m
		echo. & echo ───── [93mAl actualizar, el script se reiniciará[97m
		echo. & choice /C SN /N /M "───── ¿Actualizar? (Recomendado) [S/N]: "
			if errorlevel 2 (
				del %tempmant%
					goto MENU
			)
			move /y "%tempmant%" "%~dp0" > nul 2>&1
				start "" "%~dpnx0"
					exit
	)
	
:MENU
CLS
COLOR 0F
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [44mMENÚ PRINCIPAL[0m[97m
	echo. & echo ───── 0  para SALIR.
	echo. & echo ───── 1  para MANTENIMIENTO COMPLETO
	echo. & echo ───── 2  para VERIFICAR ESTADO DE WINDOWS
	echo. & echo ───── 3  para LIMPIEZA DE ARCHIVOS TEMPORALES
	echo. & echo ───── 3a para LIMPIEZA DE ARCHIVOS TEMPORALES PROFUNDA [91m[AVANZADO][97m
	echo. & echo ───── 4  para COMPROBACIÓN Y REPARACIÓN DE DISCOS
	echo. & echo ───── 5  para ACTIVAR/DESACTIVAR HIBERNACIÓN
	echo. & echo ───── 6  para REESTABLECIMIENTO DE RED
	echo. & echo ───── 7  para ANÁLISIS DE MEMORIA
	echo. & echo ───── 8  para ANÁLISIS AUTOMÁTICO WINDOWS DEFENDER [95m[EN DESARROLLO][97m
	echo. & echo ───── 9  para PERMISOS LIMPIEZA "WindowsApps" [95m[EN DESARROLLO][97m
			echo "C:\Program Files\WindowsApps" >nul
			
echo. & echo.

set /p Q=───── Ejecutar... 
	if "%Q%" == "" goto MENU
	if /I %Q% == M goto MENU
	if /I %Q% == 0 exit
	if /I %Q% == 1 goto COMPLETO
	if /I %Q% == 2 goto ESTADO
	if /I %Q% == 3 goto TEMP
	if /I %Q% == 3A goto TEMP.ADV
	if /I %Q% == 4 goto DISCOS
	if /I %Q% == 5 goto HIBERNAR
	if /I %Q% == 6 goto RED
	if /I %Q% == 7 goto MEMORIA
	if /I %Q% == 8 goto DEFENDER
	if /I %Q% == 9 goto WINDOWSAPPS
		goto MENU
		
:COMPLETO
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [94mVerificando estado de Windows...[97m

	echo. & echo ───── Verificando estado de imágen...
		DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
			echo. & echo ───── [91mError detectado, ejecutando reparaciones...[97m
				echo. & DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Restorehealth >nul	
					echo ───── Reverificando estado... & echo.
						DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
							echo ───── [91mNo se pudo reparar[97m
							echo. & echo ───── Vuelva al menú y ejecute "VERIFICAR ESTADO DE WINDOWS"
							echo. & echo ───── Se recomienda hacer una copia de seguridad
							echo ───── de todos los archivos importantes
							echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul & goto MENU
						)
		)
			echo ───── [92mCompletado[97m
	
	echo ───── Verificando estado de archivos...
		SFC /scannow >nul || (
			echo ───── [91mError detectado, ejecutando reparaciones...[97m
				SFC /scannow >nul || (
					echo ───── [91mNo se pudo reparar[97m
					echo. & echo ───── Se recomienda hacer una copia de seguridad
					echo ───── de todos los archivos importantes
					echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul & goto MENU
				)
		)
			echo ───── [92mCompletado[97m
		
	goto TEMP.COMPLETO
	
:ESTADO
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [94mVerificando estado de Windows...[97m

	echo. & echo ───── Verificando estado de imágen...
		DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
			echo. & echo ───── [91mError detectado, ejecutando reparaciones...[97m
				echo. & DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Restorehealth >nul	
					echo ───── Reverificando estado... & echo.
						DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
							echo ───── [91mNo se pudo reparar[97m
							echo. & echo ───── Vuelva al menú y ejecute "VERIFICAR ESTADO DE WINDOWS"
							echo. & echo ───── Se recomienda hacer una copia de seguridad
							echo ───── de todos los archivos importantes
							echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul & goto MENU
						)
		)
			echo ───── [92mCompletado[97m
	
	echo ───── Verificando estado de archivos...
		SFC /scannow >nul || (
			echo ───── [91mError detectado, ejecutando reparaciones...[97m
				SFC /scannow >nul || (
					echo ───── [91mNo se pudo reparar[97m
					echo. & echo ───── Se recomienda hacer una copia de seguridad
					echo ───── de todos los archivos importantes
					echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul & goto MENU
				)
		)
			echo ───── [92mCompletado[97m
		
	goto COMPLETADO.REINICIO
	
:TEMP
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

:TEMP.COMPLETO
echo. & echo ───── [94mLimpiando archivos temporales...[97m

	echo. & chcp 437 >nul 2>& 1
		for /f "delims=" %%a in ('powershell -command "(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq 'C:\' }).Free/1GB"') do (
			set "disk_before=%%a"
		)
			chcp 65001 >nul 2>& 1
			
	echo ───── Limpiando WinSxS...
		DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /StartComponentCleanup /ResetBase > nul 2>&1
			echo ───── [92mCompletado[97m
			
	echo ───── Limpiando local temp...
		cd %temp% & rd . /s /q > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo ───── Limpiando C:\Temp...
		cd C:\Temp > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo ───── Limpiando Windows temp...
		cd C:\Windows\Temp & rd . /s /q > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo ───── Limpiando actualizaciones descargadas...
		cd C:\Windows\SoftwareDistribution\Download > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo ───── Limpiando papelera...
		chcp 437 >nul 2>& 1
			PowerShell Clear-RecycleBin -Force -ErrorAction SilentlyContinue
				chcp 65001 >nul 2>& 1
					echo ───── [92mCompletado[97m
					
	chcp 437 >nul 2>& 1
		for /f "delims=" %%a in ('powershell -command "(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq 'C:\' }).Free/1GB"') do (
			set "disk_after=%%a"
		)
			chcp 65001 >nul 2>& 1
			
	set /a "disk_diff=(disk_after - disk_before)"
	
	echo.
	echo ───── [94mAproximadamente %disk_diff%GB liberados (libera más desactivando la hibernación)
			goto COMPLETADO.REINICIO
			
:TEMP.ADV
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [93mLa limpieza de estos archivos puede causar problemas[97m
echo ───── [93msi no se han seguido las recomendaciones[97m

echo. & echo ───── [41m SE REQUIERE CERRAR TODOS LOS PROGRAMAS[0m[97m

	echo. & echo ───── M para Volver al menú
	echo. & echo ───── CONFIRMAR para Continuar
	echo.
	echo.
		SET /P WA=───── Ejecutar... 
			if "%WA%" == "" goto TEMP.ADV
			if /I %WA% == M goto MENU
			if /I %WA% == CONFIRMAR goto TEMP.ADV.CONFIRM
				goto TEMP.ADV
				
:TEMP.ADV.CONFIRM
echo. & echo ───── [94mLimpiando archivos temporales avanzados...[97m
	echo. & chcp 437 >nul 2>& 1
		for /f "delims=" %%a in ('powershell -command "(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq 'C:\' }).Free/1GB"') do (
			set "disk_before=%%a"
		)
			chcp 65001 >nul 2>& 1
			
	echo ───── Limpiando archivos precargados...
		cd C:\Windows\Prefetch > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo ───── Limpiando actualizaciones acumulativas...
		cd C:\Windows\servicing\LCU > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo ───── Limpiando servicios de red temporales...
		cd C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo ───── Limpiando Google local temp...
		cd %localappdata%\Google\Chrome\User Data\Default\Service Worker > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				rd . /s /q > nul 2>&1
				cd %localappdata%\Google\Chrome\User Data\Default\Cache > nul 2>&1
				rd . /s /q > nul 2>&1
				cd %localappdata%\Google\Chrome\User Data\Default\Code Cache > nul 2>&1
				rd . /s /q > nul 2>&1
				echo ───── [92mCompletado[97m
			)
			
	echo ───── Limpiando caché DirectX de NVIDIA...
		cd %localappdata%\NVIDIA\DXCache > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	chcp 437 >nul 2>& 1
		for /f "delims=" %%a in ('powershell -command "(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq 'C:\' }).Free/1GB"') do (
			set "disk_after=%%a"
		)
			chcp 65001 >nul 2>& 1
			
	set /a "disk_diff=(disk_after - disk_before)"
	
	echo. & echo.
	echo ───── Aproximadamente %disk_diff%GB liberados (libera más desactivando la hibernación)
			goto COMPLETADO.REINICIO

:DISCOS
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [94mComprobando discos...[97m

	echo.
	wmic diskdrive get status || (
		PowerShell Write-Host -Fore Red ───── Error detectado. Ejecutando reparaciones...
			chkdsk /r /scan /perf >nul
			echo.
			echo ───── Vuelva al menú y ejecute "COMPROBACIÓN Y REPARACION DE DISCOS"
			echo.
			echo ───── Si vuelve a ver este mensaje, haga copia de seguridad de todos los archivos
			echo ───── importantes y póngase en contacto con un técnico para recibir asesoramiento
			echo.
			echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul & goto MENU)
				goto COMPLETADO
				
:HIBERNAR
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo.
echo ───── [94mObteniendo ajustes de hibernación...[97m
	for /f "tokens=3" %%a in ('reg query HKLM\SYSTEM\ControlSet001\Control\Power\ ^|find /i "HibernateEnabled "') do if %%a==0x1 (
		echo.
		echo.
		echo ───── [93mHibernación activada[97m
		echo. & echo ───── 1 para Desactivar
		echo. & echo ───── 2 para Volver al menú
		
		echo.
		choice /C 21 /N /M "─────  Ejecutar... "
		if errorlevel 2 (
			powercfg.exe /h off > nul 2>&1 & echo.
			echo. & echo ───── Hibernación desactivada & goto COMPLETADO
		)
			goto MENU
	)
	
		echo.
		echo.
		echo ───── [93mHibernación desactivada[97m
		echo. & echo ───── 1 para Activar
		echo. & echo ───── 2 para Volver al menú
		
		echo.
		choice /C 21 /N /M "─────  Ejecutar... "
		if errorlevel 2 (
			powercfg.exe /h on > nul 2>&1 & echo.
			echo. & echo ───── Hibernación activada & goto COMPLETADO
		)
			goto MENU
:RED
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── Reestableciendo red... & COLOR 09

	netsh winsock reset
	netsh int ip reset
	ipconfig /release
	ipconfig /renew
	ipconfig /flushdns
	ipconfig /registerdns
		goto COMPLETADO.REINICIO
		
:MEMORIA
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── Ejecutando programandor de análisis... & COLOR 09
	mdsched.exe
		echo. & echo [93m───── La duración del análisis puede tardar varias horas[97m
		echo. & echo ───── Pulse INTRO para continuar & pause >nul
			goto COMPLETADO.REINICIO
			
:DEFENDER
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [91m¡ATENCIÓN! ESTA FUNCIÓN PUEDE COMPROMETER EL SISTEMA[97m
echo.
	echo. & echo ───── M para Volver al menú
	echo. & echo ───── CONFIRMAR para Continuar
	echo.
	echo.
		SET /P WA=───── Ejecutar...  
			if "%WA%" == "" goto DEFENDER
			if /I %WA% == M goto MENU
			if /I %WA% == CONFIRMAR goto DEFENDER.CONFIRM
				goto DEFENDER
				
:DEFENDER.CONFIRM
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── Obteniendo ajustes de análisis automático... & COLOR 09
	schtasks /query /tn "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /fo list > C:\Windows\Temp\WDSSTemp.txt 2>nul
	find "Deshabilitado" C:\Windows\Temp\WDSSTemp.txt >nul && goto DEF.CHECK
		echo.
		echo.
		echo ───── [93mEstado actual: Activado[97m
		echo. & echo ───── 1 para Desactivar
		echo. & echo ───── 2 para Volver al menú
		echo. & echo.
			set /P DEF=───── Ejecutar... 
			if /I %DEF% == 1 (schtasks /Change /Disable /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" >nul & echo.
				echo. & echo ───── Análisis automático desactivado
				del C:\Windows\Temp\WDSSTemp.txt 2>nul & goto COMPLETADO)
			if /I %DEF% == 2 goto MENU
				goto DEFENDER.CONFIRM
				
:DEF.CHECK
		echo.
		echo.		
		echo ───── [93mEstado actual: Desactivado[97m		
		echo. & echo ───── 1 para Activar
		echo. & echo ───── 2 para Volver al menú
		echo. & echo.	
			set /P DEF=───── Ejecutar... 
			if /I %DEF% == 1 (schtasks /Change /Enable /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" >nul & echo.
				echo. & echo ───── Análisis automático desactivado.
				del C:\Windows\Temp\WDSSTemp.txt 2>nul & goto COMPLETADO)
			if /I %DEF% == 2 goto MENU
				goto DEFENDER.CONFIRM
				
:WINDOWSAPPS
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [91m¡ATENCIÓN! ESTA FUNCIÓN PUEDE COMPROMETER EL SISTEMA[97m
	echo.
	echo. & echo ───── M para Volver al menú
	echo. & echo ───── CONFIRMAR para Continuar
		echo.
		echo.
		SET /P WA=───── Ejecutar... 
		if "%WA%" == "" goto WINDOWSAPPS
		if /I %WA% == M goto MENU
		if /I %WA% == CONFIRMAR goto WINDOWSAPPS.CONFIRM
			goto WINDOWSAPPS
			
:WINDOWSAPPS.CONFIRM
echo. & echo ───── Otorgando permisos en C:\Program Files\WindowsApps... & COLOR 09
	takeown /f "C:\Program Files\WindowsApps" /r >nul
	icacls "C:\Program Files\WindowsApps" /reset /t >nul
	start %windir%\explorer.exe "C:\Program Files\WindowsApps" >nul
		goto COMPLETADO
		
:COMPLETADO
echo [92m
echo. & echo ───── Completado
echo. & echo ───── Pulse INTRO para volver al menú
echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul & goto MENU

:COMPLETADO.REINICIO
echo [92m
echo. & echo ───── Completado (se recomienda reiniciar)
echo. & echo ───── Pulse INTRO para volver al menú
echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul & goto MENU
