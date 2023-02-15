@echo Off

NET SESSION >nul 2>& 1
IF %ERRORLEVEL% == 0 GOTO AVISO

MODE CON: COLS=82 LINES=11

COLOR 4F

echo ----------------------------------------------------------------------------------

echo. & echo ----- ESTA HERRAMIENTA REQUIERE SER EJECUTADA COMO ADMINISTRADOR.

echo. & echo ----- HAGA CLIC DERECHO EN EL ARCHIVO Y SELECCIONE "EJECUTAR COMO ADMINISTRADOR".

echo.
echo. & echo ----- Pulse INTRO para salir.

echo. & echo ----------------------------------------------------------------------------------& Pause >nul & Exit

echo ----------------------------------------------------------------------------------

:AVISO

MODE CON: COLS=82 LINES=37

CLS

echo [97m----------------------------------------------------------------------------------[0m

echo. & echo [92m----- VERSION 1.18[0m

echo. & echo [41m---------------------------IMPORTANTE! LEA ATENTAMENTE!---------------------------[0m

echo. & echo ----- [7mPUEDE CAMBIAR LA ESCALA MANTENIENDO LA TECLA CTRL + RUEDA DEL RATON.[0m

echo. & echo [93m----- LEA ATENTAMENTE TODO LO QUE REPORTE LA HERRAMIENTA.

echo. & echo ----- SI ESTA POR CUENTA PROPIA, PRESTE ESPECIAL ATENCION A LAS RECOMENDACIONES.

echo. & echo ----- NO USE LA HERRAMIENTA SI HAY ACTUALIZACIONES EN CURSO.

echo. & echo ----- NO ME HAGO RESPONSABLE DE: MAL USO DE LA HERRAMIENTA, PROBLEMAS CAUSADOS
		echo       AL SOFTWARE/HARDWARE O PERDIDA DE DATOS.

echo. & echo ----- ESPERE A QUE SE COMPLETE LA OPERACION ANTES DE CERRAR LA HERRAMIENTA.

echo. & echo ----- SE RECOMIENDA TENER WINDOWS COMPLETAMENTE ACTUALIZADO

echo. & echo ----- SE RECOMIENDA CERRAR TODOS LOS PROGRAMAS ANTES DE EJECUTAR LA HERRAMIENTA.

echo. & echo ----- SE RECOMIENDA DESACTIVAR EL ANTIVIRUS PARA MEJORAR LA VELOCIDAD DE TRABAJO.

echo. & echo ----- SEA PACIENTE, ALGUNAS FUNCIONES PUEDEN TARDAR VARIOS MINUTOS EN COMPLETARSE.[0m

echo. & echo [41m---------------------------IMPORTANTE! LEA ATENTAMENTE!---------------------------[0m

echo. & echo [97m----- Pulse INTRO si ha leido, entiende y acepta todo lo anterior.[0m

echo. & echo [97m----------------------------------------------------------------------------------[0m& Pause >nul & CLS

:UPDATE

SETLOCAL EnableExtensions

echo. & echo ------ Buscando actualizaciones...

bitsadmin /transfer Updt /download /priority high https://raw.githubusercontent.com/Cantejito/WinMant/main/Mantenimiento_Windows.bat C:\Windows\Temp\Mantenimiento_Windows.bat > nul 2>&1

SET OLD="%~dp0"
SET NEW="C:\Windows\Temp\Mantenimiento_Windows.bat"

FOR %%i IN (%OLD%) DO SET DATE1=%%~ti
FOR %%i IN (%NEW%) DO SET DATE2=%%~ti

IF "%DATE1%" LEQ "%DATE2%" (echo. & echo ----- Ya tienes la ultima version. & GOTO COMPLETADO.NOUPDATE )

	echo.
	echo ----- Actualizando...
	cd C:\Windows\Temp\ > nul 2>&1
	move "Mantenimiento_Windows.bat" "%OLD%" > nul 2>&1

GOTO COMPLETADO.UPDATE

:MENU

CLS

COLOR 0F

echo ----------------------------------------------------------------------------------

echo. & echo [92m----- MENU PRINCIPAL[0m

echo. [97m
echo. & echo ----- 0 para SALIR
echo. & echo ----- 1 para MANTENIMIENTO COMPLETO.
echo. & echo ----- 2 para VERIFICAR ESTADO DE WINDOWS.
echo. & echo ----- 3 para LIMPIEZA DE ARCHIVOS TEMPORALES.
echo. & echo ----- 4 para COMPROBACION Y REPARACION DE DISCOS.
echo. & echo ----- 5 para ACTIVAR/DESACTIVAR HIBERNACION.
echo. & echo ----- 6 para REESTABLECIMIENTO DE RED.
echo. & echo ----- 7 para ANALISIS DE MEMORIA.
echo. & echo ----- 8 para ANALISIS AUTOMATICO WINDOWS DEFENDER. [91mAVANZADO[0m
echo. & echo ----- 9 para PERMISOS LIMPIEZA "WindowsApps" [91mAVANZADO[0m
		echo "C:\Program Files\WindowsApps" >nul
		
echo.
echo.
SET /P W=[97m----- Ejecutar...[0m 
	IF "%W%" == "" GOTO MENU
	IF /I %W% == M GOTO MENU
	IF /I %W% == 0 EXIT
	IF /I %W% == 1 GOTO COMPLETO
	IF /I %W% == 2 GOTO ESTADO
	IF /I %W% == 3 GOTO TEMP
	IF /I %W% == 4 GOTO DISCOS
	IF /I %W% == 5 GOTO HIBERNAR
	IF /I %W% == 6 GOTO RED
	IF /I %W% == 7 GOTO MEMORIA
	IF /I %W% == 8 GOTO DEFENDER
	IF /I %W% == 9 GOTO WINDOWSAPPS
	GOTO MENU

:COMPLETO

CLS

echo ----------------------------------------------------------------------------------

echo. & echo ----- Verificando estado de Windows... & COLOR 09 & echo.
	
	echo ----- Paso 1 de 12...
	DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
	
		echo.
		PowerShell Write-Host -Fore Red ----- Error detectado. Ejecutando reparaciones...
	
		echo.
		DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Restorehealth >nul
	
		echo ----- Reverificando estado de Windows... & echo.

		DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
	
			Color 4F & echo ----- !!!POSIBLE CORRUPCION DEL SISTEMA OPERATIVO!!!
	
			echo.
			echo ----- Reinicie la herramienta y ejecute "VERIFICAR ESTADO DE WINDOWS".
	
			echo.
			echo ----- Si vuelve a ver este mensaje, haga copia de seguridad de todos los archivos
			echo ----- importantes y pongase en contacto con un tecnico para recibir asesoramiento.)
	
			echo.
			echo ----------------------------------------------------------------------------------& Pause >nul & GOTO MENU )
	
	echo ----- Paso 2 de 12...
	SFC /scannow >nul

echo. & echo ----- Limpiando archivos temporales... & echo.
	
	echo ----- Paso 3 de 12...
	DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /StartComponentCleanup /ResetBase
	
	echo ----- Paso 4 de 12...
	(cd %temp% && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 5 de 12...
	(cd C:\Temp && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 6 de 12...
	(cd C:\Windows\Prefetch && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 7 de 12...
	(cd C:\Windows\Temp && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 8 de 12...
	(cd C:\Windows\SoftwareDistribution\Download && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 9 de 12...
	(cd C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 10 de 12...
	(cd C:\Windows\servicing\LCU && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 11 de 12...
	PowerShell Clear-RecycleBin -Force -ErrorAction SilentlyContinue
	
	echo.
	echo [93m----- ATENCION: En la fase final del siguiente paso se ejecutaran dos ventanas.
	echo ----- Un bug de Windows evita su cierre automatico al finalizar.
	echo ----- Para completar el paso es necesario que el usuario actualice su estado
	echo ----- pasando el raton por encima de dichas ventanas.
	echo ----- Si pasa el raton y no se cierran espere un minuto e intentelo de nuevo.[0m
	echo.
	
	echo [94m----- Paso 12 de 12...
	cleanmgr /verylowdisk /sagerun /f

	echo. & echo ----- Puede liberar mas espacio desactivando la hibernacion.[0m

GOTO COMPLETADO.REINICIO

:ESTADO

CLS

echo ----------------------------------------------------------------------------------

echo. & echo ----- Verificando estado de Windows... & COLOR 09 & echo.
	
	echo ----- Paso 1 de 2...
	DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
	
		echo.
		PowerShell Write-Host -Fore Red ----- Error detectado. Ejecutando reparaciones...
	
		echo.
		DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Restorehealth >nul
	
		echo ----- Reverificando estado de Windows... & echo.

		DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
	
			Color 4F & echo ----- !!!POSIBLE CORRUPCION DEL SISTEMA OPERATIVO!!!
	
			echo.
			echo ----- Reinicie la herramienta y ejecute "VERIFICAR ESTADO DE WINDOWS".
	
			echo.
			echo ----- Si vuelve a ver este mensaje, haga copia de seguridad de todos los archivos
			echo ----- importantes y pongase en contacto con un tecnico para recibir asesoramiento.)
	
			echo.
			echo ----------------------------------------------------------------------------------& Pause >nul & GOTO MENU )
	
	echo ----- Paso 2 de 2...
	SFC /scannow >nul

GOTO COMPLETADO.REINICIO

:TEMP

CLS

echo ----------------------------------------------------------------------------------

echo. & echo ----- Limpiando archivos temporales... & COLOR 09

	echo.
	echo ----- Paso 1 de 10...
	DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /StartComponentCleanup /ResetBase
	
	echo ----- Paso 2 de 10...
	(cd %temp% && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 3 de 10...
	(cd C:\Temp && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 4 de 10...
	(cd C:\Windows\Prefetch && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 5 de 10...
	(cd C:\Windows\Temp && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 4 de 10...
	(cd C:\Windows\SoftwareDistribution\Download && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 7 de 10...
	(cd C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 8 de 10...
	(cd C:\Windows\servicing\LCU && rd . /s /q) > nul 2>&1
	
	echo ----- Paso 9 de 10...
	PowerShell Clear-RecycleBin -Force -ErrorAction SilentlyContinue
	
	echo.
	echo [93m----- ATENCION: En la fase final del siguiente paso se ejecutaran dos ventanas.
	echo ----- Un bug de Windows evita su cierre automatico al finalizar.
	echo ----- Para completar el paso es necesario que el usuario actualice su estado
	echo ----- pasando el raton por encima de dichas ventanas.
	echo ----- Si pasa el raton y no se cierran espere un minuto e intentelo de nuevo.[0m
	echo.
	
	echo [94m----- Paso 10 de 10...
	cleanmgr /verylowdisk /sagerun /f

	echo. & echo ----- Puede liberar mas espacio desactivando la hibernacion.[0m

GOTO COMPLETADO.REINICIO

:DISCOS

CLS

echo ----------------------------------------------------------------------------------

echo. & echo ----- Comprobando discos... & COLOR 09
	echo.
	
	wmic diskdrive get status || (
		PowerShell Write-Host -Fore Red ----- Error detectado. Ejecutando reparaciones...
			chkdsk /r /scan /perf >nul
			
			echo.
			echo ----- Reinicie la herramienta y ejecute "COMPROBACION Y REPARACION DE DISCOS".
			
			echo.
			echo ----- Si vuelve a ver este mensaje, haga copia de seguridad de todos los archivos
			echo ----- importantes y pongase en contacto con un tecnico para recibir asesoramiento.
	
			echo.
			echo ----------------------------------------------------------------------------------& Pause >nul & GOTO MENU )
			
GOTO COMPLETADO

:HIBERNAR

CLS

echo ----------------------------------------------------------------------------------

echo. & echo ----- Obteniendo ajustes de hibernacion... & COLOR 09
	
	PowerShell Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Power -name HibernateEnabled >$null
	IF %ERRORLEVEL% == 1 GOTO HIB.CHECK
		echo.
		echo.
		
		echo [93m----- Estado actual: Activada.[0m & echo [94m
		
		echo. & echo ----- 1 para Desactivar.
		echo. & echo ----- 2 para No modificar.
		echo. & echo.
		
		SET /P HIB=----- Ejecutar... & echo [0m
			IF /I %HIB% == 1 GOTO HIB.OFF
			IF /I %HIB% == 2 GOTO HIB.NONE
			GOTO HIBERNAR
			
				:HIB.OFF
				powercfg.exe /hibernate off >nul & echo.
				echo. & echo ----- Hibernacion desactivada. & GOTO COMPLETADO
				
				:HIB.NONE
				echo. & echo ----- La configuracion no ha sido modificada. & GOTO COMPLETADO
				
		:HIB.CHECK
		echo.
		echo.
		
		echo [93m----- Estado actual: Desactivada.[0m & echo [94m
		
		echo. & echo ----- 1 para Activar.
		echo. & echo ----- 2 para No modificar.
		echo. & echo.
		
		SET /P HIB=----- Ejecutar... & echo [0m
			IF /I %HIB% == 1 GOTO HIB.ON
			IF /I %HIB% == 2 GOTO HIB.NONE
			GOTO HIBERNAR
			
				:HIB.ON
				powercfg.exe /hibernate on >nul & echo.
				echo ----- Hibernacion activada. & GOTO COMPLETADO
				
				:HIB.NONE
				echo. & echo ----- La configuracion no ha sido modificada. & GOTO COMPLETADO
				
:RED

CLS

echo ----------------------------------------------------------------------------------

echo. & echo ----- Reestableciendo red... & COLOR 09
	
	netsh winsock reset
	
	netsh int ip reset
	
	ipconfig /release
	
	ipconfig /renew
	
	ipconfig /flushdns
	
	ipconfig /registerdns

GOTO COMPLETADO.REINICIO

:MEMORIA

CLS

echo ----------------------------------------------------------------------------------

echo. & echo ----- Ejecutando programandor de analisis... & COLOR 09
	
	mdsched.exe

echo. & echo [93m----- La duracion del analisis puede tardar varias horas.[0m
		
		echo. & echo [97m----- Pulse INTRO para continuar[0m & pause >nul
		
GOTO COMPLETADO.REINICIO

:DEFENDER

CLS

echo ----------------------------------------------------------------------------------

echo. & echo ----- [91mATENCION! EL USO INADECUADO DE ESTA FUNCION PUEDE COMPROMETER SU SISTEMA.[0m
	echo.

echo. & echo [97m----- M para MENU.

echo. & echo ----- CONFIRMAR para EJECUTAR COMANDO.

echo.
echo.
SET /P WA=----- Ejecutar... [0m 
	IF "%WA%" == "" GOTO DEFENDER
	IF /I %WA% == M GOTO MENU
	IF /I %WA% == CONFIRMAR GOTO DEFENDER.CONFIRM
	GOTO DEFENDER

:DEFENDER.CONFIRM

CLS

echo ----------------------------------------------------------------------------------

echo. & echo ----- Obteniendo ajustes de analisis automatico... & COLOR 09

	schtasks /query /tn "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /fo list >nul > C:/Temp/WDSSTemp.txt 2>nul

	find "Deshabilitado" C:\Temp\WDSSTemp.txt >nul && GOTO DEF.CHECK
	
	echo.
	echo.
	echo [93m----- Estado actual: Activado.[0m & echo [94m
		
		echo. & echo ----- 1 para Desactivar.
		echo. & echo ----- 2 para No modificar.
		echo. & echo.
		
		SET /P DEF=----- Ejecutar... & echo [0m
			IF /I %DEF% == 1 GOTO DEF.OFF
			IF /I %DEF% == 2 GOTO DEF.NONE
			GOTO DEFENDER.CONFIRM
			
				:DEF.OFF
				schtasks /Change /Disable /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" >nul & echo.
				echo. & echo ----- Analisis automatico desactivado.
				del C:\Temp\WDSSTemp.txt 2>nul & GOTO COMPLETADO
				
				:DEF.NONE
				echo. & echo ----- La configuracion no ha sido modificada.
				del C:\Temp\WDSSTemp.txt 2>nul & GOTO COMPLETADO
				
		:DEF.CHECK
		echo.
		echo.
		
		echo [93m----- Estado actual: Desactivado.[0m & echo [94m
		
		echo. & echo ----- 1 para Activar.
		echo. & echo ----- 2 para No modificar.
		echo. & echo.
		
		SET /P DEF=----- Ejecutar... & echo [0m
			IF /I %DEF% == 1 GOTO DEF.ON
			IF /I %DEF% == 2 GOTO DEF.NONE
			GOTO DEFENDER.CONFIRM
			
				:DEF.ON
				schtasks /Change /Enable /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" >nul & echo.
				echo. & echo ----- Analisis automatico desactivado.
				del C:\Temp\WDSSTemp.txt 2>nul & GOTO COMPLETADO
				
				:DEF.NONE
				echo. & echo ----- La configuracion no ha sido modificada.
				del C:\Temp\WDSSTemp.txt 2>nul & GOTO COMPLETADO
				
:WINDOWSAPPS

CLS

echo [97m----------------------------------------------------------------------------------

echo. & echo ----- [91mATENCION! EL USO INADECUADO DE ESTA FUNCION PUEDE COMPROMETER SU SISTEMA.[0m
	echo.

echo. & echo [97m----- M para MENU.

echo. & echo ----- CONFIRMAR para EJECUTAR COMANDO.

echo.
echo.
SET /P WA=----- Ejecutar... [0m
	IF "%WA%" == "" GOTO WINDOWSAPPS
	IF /I %WA% == M GOTO MENU
	IF /I %WA% == CONFIRMAR GOTO WINDOWSAPPS.CONFIRM
	GOTO WINDOWSAPPS

:WINDOWSAPPS.CONFIRM

echo. & echo ----------------------------------------------------------------------------------

echo. & echo ----- Otorgando permisos en C:\Program Files\WindowsApps... & COLOR 09
	
	takeown /f "C:\Program Files\WindowsApps" /r >nul
	
	icacls "C:\Program Files\WindowsApps" /reset /t >nul
	
	start %windir%\explorer.exe "C:\Program Files\WindowsApps" >nul
	
GOTO COMPLETADO
	
:COMPLETADO

echo.
echo. & echo ----- Completado. & COLOR 0A
echo. & echo ----- Pulse INTRO para volver al menu.

echo. & echo ----------------------------------------------------------------------------------& Pause >nul & GOTO MENU

:COMPLETADO.REINICIO

echo.
echo. & echo ----- Completado. Se recomienda reiniciar. & COLOR 0A
echo. & echo ----- Pulse INTRO para volver al menu.

echo. & echo ----------------------------------------------------------------------------------& Pause >nul & GOTO MENU

:COMPLETADO.UPDATE

echo.
echo. & echo ----- Completado. & COLOR 0A
echo. & echo ----- Pulse INTRO para volver al menu.

echo. & echo ----------------------------------------------------------------------------------& Pause >nul & GOTO MENU

:COMPLETADO.NOUPDATE

echo.
echo. & echo ----- Completado. & COLOR 0A
echo. & echo ----- Pulse INTRO para volver al menu.

echo. & echo ----------------------------------------------------------------------------------& Pause >nul & GOTO MENU