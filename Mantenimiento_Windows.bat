@echo Off
setlocal EnableExtensions
setlocal EnableDelayedExpansion
chcp 65001
set ver=0.20.2.0A
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

echo. & echo ───── [45mNO ME HAGO RESPONSABLE DE PÉRDIDA DE DATOS Y/O PROBLEMAS CAUSADOS[0m[97m

echo. & echo ───── [41mREQUISITOS[0m[97m

echo. & echo ───── No usar si hay actualizaciones en curso

echo. & echo ───── Tener Windows completamente actualizado

echo. & echo ───── [93mRECOMENDACIONES[97m

echo. & echo ───── Cerrar todos los programas

echo. & echo ───── Desactivar el antivirus para mejorar la velocidad de trabajo

echo. & echo ───── Esperar a que se complete la operación antes de cerrar el script

echo. & echo ───── [94mINFORMACIÓN[97m

echo. & echo ───── Algunas funciones pueden tardar minutos e incluso horas en completarse

echo. & echo [41m────────────────────────────────────IMPORTANTE────────────────────────────────────[0m[97m

echo. & echo ───── Pulse INTRO si ha leído, entiende y acepta todo lo anterior

echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul

:UPDATE
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [94mBuscando actualizaciones...[97m
	curl -o %tempmant% %url% -s
		if errorlevel 1 (
			echo.
			echo ───── [91mError al conectarse a internet
				timeout 5 >nul
					goto MENU
		)
	
	findstr /C:"set ver=" %tempmant% > %tempmant%.new
		set /p ver_new=<"%tempmant%.new"
			for /f "tokens=2 delims==" %%A in ("!ver_new!") do set "ver_new=%%A"
				del "%tempmant%.new"
				
	if %ver% neq %ver_new% (
		echo. & echo ───── [93mVersión actual:[97m     %ver%
		echo. & echo ───── [92mVersión disponible:[97m %ver_new%
		echo. & echo ───── [91mAl actualizar, el script se reiniciará[97m
		echo.
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
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [94mMENÚ PRINCIPAL[97m
	echo. & echo ───── 0   =   Salir
	echo. & echo ───── 1   =   Mantenimiento completo
	echo. & echo ───── 1a  =   Verificar estado de Windows
	echo. & echo ───── 1b  =   Limpieza de archivos temporales básicos
	echo. & echo ───── 2   =   Comprobar y reparar discos
	echo. & echo ───── 3   =   Ajustes de hibernación
	echo. & echo ───── 4   =   Reestablecer ajustes de red
	echo. & echo ───── 5   =   Análisis de memoria
	echo.
	echo. & echo ───── [93mU   =   Comprobar actualizaciones del script[97m
	echo.
	echo. & echo ───── [95mADV =   Menú avanzado[97m
	
echo. & echo.
set /p MENU=───── Ejecutar... 
	if /i "%MENU%" == "" goto MENU
	if /i %MENU% == 0 exit
	if /i %MENU% == 1 goto COMPLETO
	if /i %MENU% == 1a goto ESTADO
	if /i %MENU% == 1b goto TEMP
	if /i %MENU% == 2 goto DISCOS
	if /i %MENU% == 3 goto HIBERNAR
	if /i %MENU% == 4 goto RED
	if /i %MENU% == 5 goto MEMORIA
	if /i %MENU% == U goto UPDATE
	if /i %MENU% == ADV goto MENU.ADV
		goto MENU
	
:MENU.ADV
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [95mMENÚ AVANZADO[97m
	echo. & echo ───── 0   =   Volver al menú principal
	echo. & echo ───── 1   =   Limpieza de archivos temporales en profundidad
	echo. & echo ───── 1a  =   Limpieza de archivos temporales avanzada [95m[EN DESARROLLO][97m
	echo. & echo ───── 2   =   Análisis automático Windows Defender [95m[EN DESARROLLO][97m
	echo. & echo ───── 3   =   Acceso a "WindowsApps" [95m[EN DESARROLLO][97m
			echo "C:\Program Files\WindowsApps" > nul 2>&1
				
echo. & echo.
set /p MENU.ADV=───── Ejecutar... 
	if /i "%MENU.ADV%" == "" goto MENU.ADV
	if /i %MENU.ADV% == 0 goto MENU
	if /i %MENU.ADV% == 1 goto TEMP.PRO
	if /i %MENU.ADV% == 1a goto TEMP.ADV
	if /i %MENU.ADV% == 2 goto DEFENDER
	if /i %MENU.ADV% == 3 goto WINDOWSAPPS
		goto MENU.ADV
	
:COMPLETO
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [94mVerificando estado de Windows...[97m

	echo. & echo ───── Verificando estado de imágen...
		DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
			echo. & echo ───── [91mError detectado, ejecutando reparaciones...[97m
				echo. & DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Restorehealth >nul	
					echo ───── Reverificando estado...
						echo.
						DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
							echo ───── [91mNo se pudo reparar[97m
							echo. & echo ───── Vuelva al menú y ejecute "VERIFICAR ESTADO DE WINDOWS"
							echo. & echo ───── Se recomienda hacer una copia de seguridad
									echo ───── de todos los archivos importantes
							echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul
								goto MENU
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
					echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul
						goto MENU
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
							echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul
								goto MENU
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
					echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul
						goto MENU
				)
		)
			echo ───── [92mCompletado[97m
		
	goto COMPLETADO.REINICIO
	
:TEMP
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

:TEMP.COMPLETO

echo. & echo ───── [94mLimpiando archivos temporales básicos...[97m

	echo. & chcp 437 >nul 2>& 1
		for /f "delims=" %%a in ('powershell -command "(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq 'C:\' }).Free/1GB"') do (
			set "Disk.B=%%a"
		)
			chcp 65001 >nul 2>& 1
			
	echo. & echo ───── Limpiando archivos temporales del usuario...
		cd %temp% & rd . /s /q > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo. & echo ───── Limpiando archivos temporales disco local...
		cd C:\Temp > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo. & echo ───── Limpiando archivos temporales de Windows...
		cd C:\Windows\Temp & rd . /s /q > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo. & echo ───── Limpiando papelera...
		chcp 437 >nul 2>& 1
			PowerShell Clear-RecycleBin -Force -ErrorAction SilentlyContinue
				chcp 65001 >nul 2>& 1
					echo ───── [92mCompletado[97m
					
	chcp 437 >nul 2>& 1
		for /f "delims=" %%a in ('powershell -command "(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq 'C:\' }).Free/1GB"') do (
			set "Disk.A=%%a"
		)
			chcp 65001 >nul 2>& 1
			
	set /a "Disk.D=(Disk.A - Disk.B)"
	
	echo. & echo.
	echo ───── [94mAproximadamente [92m%Disk.D% GB [94mliberados (libera más desactivando la hibernación)
		goto COMPLETADO.REINICIO
			
:TEMP.PRO
echo. & echo ───── [94mLimpiando archivos temporales en profundidad...[97m
	echo. & chcp 437 >nul 2>& 1
		for /f "delims=" %%a in ('powershell -command "(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq 'C:\' }).Free/1GB"') do (
			set "Disk.B=%%a"
		)
			chcp 65001 >nul 2>& 1
			
	echo. & echo ───── Limpiando WinSxS...
		DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /StartComponentCleanup /ResetBase > nul 2>&1
			echo ───── [92mCompletado[97m
			
	echo. & echo ───── Limpiando actualizaciones descargadas...
		cd C:\Windows\SoftwareDistribution\Download > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo. & echo ───── Limpiando archivos temporales de Chrome...
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
			
	echo. & echo ───── Limpiando caché DirectX de NVIDIA...
		cd %localappdata%\NVIDIA\DXCache > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	chcp 437 >nul 2>& 1
		for /f "delims=" %%a in ('powershell -command "(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq 'C:\' }).Free/1GB"') do (
			set "Disk.A=%%a"
		)
			chcp 65001 >nul 2>& 1
			
	set /a "Disk.D=(Disk.A - Disk.B)"
	
	echo. & echo.
	echo ───── [94mAproximadamente [92m%Disk.D% GB [94mliberados (libera más desactivando la hibernación)
		goto COMPLETADO.REINICIO
		
:TEMP.ADV
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [97;41mESTA FUNCIÓN PUEDE AFECTAR A LA INTEGRIDAD DEL EQUIPO[0m[97m
		echo ───── [97;41mO CAUSAR PÉRDIDA DE DATOS[0m[97m

echo. & echo ───── [41m SE REQUIERE CERRAR TODOS LOS PROGRAMAS[0m[97m

	echo. & echo ───── M = Volver al menú
	echo. & echo ───── CONFIRMAR = Continuar
	echo. & echo.
		set /p T.A=───── Ejecutar... 
			if /i "%T.A%" == "" goto TEMP.ADV
			if /i %T.A% == M goto MENU
			if /i %T.A% == CONFIRMAR goto TEMP.ADV.CHECK
				goto TEMP.ADV
				
	:TEMP.ADV.CHECK
echo. & echo ───── [94mLimpiando archivos temporales... [95m[AVANZADO][97m
	echo. & chcp 437 >nul 2>& 1
		for /f "delims=" %%a in ('powershell -command "(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq 'C:\' }).Free/1GB"') do (
			set "Disk.B=%%a"
		)
			chcp 65001 >nul 2>& 1
			
	echo. & echo ───── Limpiando archivos precargados...
		cd C:\Windows\Prefetch > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo. & echo ───── Limpiando actualizaciones acumulativas...
		cd C:\Windows\servicing\LCU > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	echo. & echo ───── Limpiando servicios de red temporales...
		cd C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp > nul 2>&1
			if errorlevel 1 (
				echo ───── [91mCancelado, ruta no encontrada[97m
			) else (
				echo ───── [92mCompletado[97m & rd . /s /q > nul 2>&1
			)
			
	chcp 437 >nul 2>& 1
		for /f "delims=" %%a in ('powershell -command "(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq 'C:\' }).Free/1GB"') do (
			set "Disk.A=%%a"
		)
			chcp 65001 >nul 2>& 1
			
	set /a "Disk.D=(Disk.A - Disk.B)"
	
	echo. & echo.
	echo ───── [94mAproximadamente [92m%Disk.D% GB [94mliberados (libera más desactivando la hibernación)
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
			echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul
				goto MENU
			)
				goto COMPLETADO
				
:HIBERNAR
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo.
echo ───── [94mObteniendo ajustes de hibernación...[97m

	for /f "tokens=3" %%a in ('reg query HKLM\SYSTEM\ControlSet001\Control\Power\ ^|find /i "HibernateEnabled "') do if %%a==0x1 (
		echo. & echo.
		echo ───── [93mHibernación activada[97m
		echo. & echo ───── 0 = Volver al menú
		echo. & echo ───── 1 = Desactivar
		
		echo. & echo.
		choice /C 01 /N /M "─────  Ejecutar... "
		if errorlevel 2 (
			powercfg.exe /h off > nul 2>&1 & echo.
				goto HIBERNAR
		)
			goto MENU
	)
	
		echo. & echo.
		echo ───── [93mHibernación desactivada[97m
		echo. & echo ───── 0 = Volver al menú
		echo. & echo ───── 1 = Activar
		
		echo. & echo.
		choice /C 01 /N /M "─────  Ejecutar... "
		if errorlevel 2 (
			powercfg.exe /h on > nul 2>&1 & echo.
				goto HIBERNAR
		)
			goto MENU
:RED
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [94mReestableciendo red...[97m

		echo. & echo.
		echo ───── [93mSeguro que quiere continuar?[97m
		echo. & echo ───── 0 = Volver al menú
		echo. & echo ───── 1 = Continuar
		
		echo. & echo.
		choice /C 01 /N /M "─────  Ejecutar... "
		if errorlevel 2 (
			netsh winsock reset
			netsh int ip reset
			ipconfig /release
			ipconfig /renew
			ipconfig /flushdns
			ipconfig /registerdns
				goto COMPLETADO.REINICIO
		)
			goto MENU
		
:MEMORIA
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [91mEjecutando programandor de análisis...[97m

	mdsched.exe
		echo. & echo [93m───── La duración del análisis puede tardar varias horas[97m
			goto COMPLETADO.REINICIO
			
:DEFENDER
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [97;41mESTA FUNCIÓN PUEDE AFECTAR A LA INTEGRIDAD DEL EQUIPO[0m[97m
		echo ───── [97;41mO CAUSAR PÉRDIDA DE DATOS[0m[97m
		
	echo.
	echo. & echo ───── 0 = Volver al menú
	echo. & echo ───── CONFIRMAR = Continuar
	echo. & echo.
		set /p DEF=───── Ejecutar...  
			if /i "%DEF%" == "" goto DEFENDER
			if /i %DEF% == 0 goto MENU
			if /i %DEF% == CONFIRMAR goto DEFENDER.CHECK
				goto DEFENDER
			
	:DEFENDER.CHECK
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [94mObteniendo ajustes de análisis automático...[97m

	for /f "tokens=2 delims=:" %%a in ('schtasks /query /tn "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /fo list ^| find "Estado"') do set "status=%%a"
		set "status=%status: =%"
		if /i "%status%"=="Deshabilitado" goto DEFENDER.OFF
			echo. & echo.
			echo ───── [93mEstado actual: Activado[97m
				echo. & echo ───── 0 = Volver al menú
				echo. & echo ───── 1 = Desactivar
				echo. & echo.
					set /p DEF.C=───── Ejecutar... 
					if /i "%DEF.C%" == "" goto DEFENDER.CHECK
					if /i %DEF.C% == 0 goto MENU
					if /i %DEF.C% == 1 (
						schtasks /Change /Disable /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" >nul
							echo. & echo.
							echo ───── [92mAnálisis automático desactivado[97m
								goto COMPLETADO
					)
						goto DEFENDER.CHECK
	:DEFENDER.OFF
			echo. & echo.		
			echo ───── [93mEstado actual: Desactivado[97m
				echo. & echo ───── 0 = Volver al menú
				echo. & echo ───── 1 = Activar
				echo. & echo.	
					set /p DEF.O=───── Ejecutar... 
					if /i "%DEF.O%" == "" goto DEFENDER.CHECK
					if /i %DEF.O% == 0 goto MENU
					if /i %DEF.O% == 1 (
						schtasks /Change /Enable /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" >nul
							echo. & echo.
							echo ───── [92mAnálisis automático activado[97m
								goto COMPLETADO
					)
						goto DEFENDER.CHECK
:WINDOWSAPPS
CLS
echo [97m──────────────────────────────────────────────────────────────────────────────────

echo. & echo ───── [97;41mESTA FUNCIÓN PUEDE AFECTAR A LA INTEGRIDAD DEL EQUIPO[0m[97m
		echo ───── [97;41mO CAUSAR PÉRDIDA DE DATOS[0m[97m
		
	echo.
	echo. & echo ───── 0 = Volver al menú
	echo. & echo ───── CONFIRMAR = Continuar
		echo. & echo.
		set /p WA=───── Ejecutar... 
		if /i "%WA%" == "" goto WINDOWSAPPS
		if /i %WA% == 0 goto MENU
		if /i %WA% == CONFIRMAR goto WINDOWSAPPS.CHECK
			goto WINDOWSAPPS
			
	:WINDOWSAPPS.CHECK
echo.
echo. & echo ───── Otorgando permisos en C:\Program Files\WindowsApps...

	takeown /f "C:\Program Files\WindowsApps" /r >nul
		icacls "C:\Program Files\WindowsApps" /reset /t >nul
			start explorer.exe "C:\Program Files\WindowsApps" >nul
				goto COMPLETADO
				
:COMPLETADO
echo [97m
echo. & echo ───── [92mCompletado[97m
echo. & echo ───── [94mPulse INTRO para volver al menú[97m
echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul & goto MENU

:COMPLETADO.REINICIO
echo [97m
echo. & echo ───── [92mCompletado[97m (se recomienda reiniciar)
echo. & echo ───── [94mPulse INTRO para volver al menú[97m
echo. & echo ────────────────────────────────────────────────────────────────────────────────── & pause >nul & goto MENU
