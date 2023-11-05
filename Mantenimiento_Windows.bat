@echo Off
setlocal EnableExtensions
setlocal EnableDelayedExpansion
chcp 65001
set ver=0.18.9.0E
set url=https://raw.githubusercontent.com/Cantejito/WinMant/main/Mantenimiento_Windows.bat
set temp=C:\Windows\Temp\Mantenimiento_Windows.bat
title Versión %ver%
NET SESSION >nul 2>& 1
if %ERRORLEVEL% == 0 goto AVISO
MODE CON: COLS=82 LINES=11
COLOR 4F
echo ----------------------------------------------------------------------------------
echo. & echo ----- ESTA HERRAMIENTA REQUIERE SER EJECUTADA COMO ADMINISTRADOR.
echo. & echo ----- HAGA CLIC DERECHO EN EL ARCHIVO Y SELECCIONE "EJECUTAR COMO ADMINISTRADOR".
echo.
echo. & echo ----- Pulse INTRO para salir.
echo. & echo ---------------------------------------------------------------------------------- & pause >nul & exit
:AVISO
MODE CON: COLS=82 LINES=37
CLS
echo [97m----------------------------------------------------------------------------------
echo. & echo [41m--------------------------¡IMPORTANTE! ¡LEA ATENTAMENTE!--------------------------[0m
echo. & echo ----- [7mPUEDE CAMBIAR LA ESCALA MANTENIENDO LA TECLA CTRL + RUEDA DEL RATÓN.[0m
echo. & echo [93m----- LEA ATENTAMENTE TODO LO QUE REPORTE LA HERRAMIENTA.
echo. & echo ----- PRESTE ATENCIÓN A LAS RECOMENDACIONES.
echo. & echo ----- NO USE LA HERRAMIENTA SI HAY ACTUALIZACIONES EN CURSO.
echo. & echo ----- ESPERE A QUE SE COMPLETE LA OPERACIÓN ANTES DE CERRAR LA HERRAMIENTA.
echo. & echo ----- ALGUNAS FUNCIONES PUEDEN TARDAR VARIOS MINUTOS EN COMPLETARSE.
echo. & echo ----- SE RECOMIENDA TENER WINDOWS COMPLETAMENTE ACTUALIZADO.
echo. & echo ----- SE RECOMIENDA CERRAR TODOS LOS PROGRAMAS ANTES DE EJECUTAR LA HERRAMIENTA.
echo. & echo ----- SE RECOMIENDA DESACTIVAR EL ANTIVIRUS PARA MEJORAR LA VELOCIDAD DE TRABAJO.
echo. & echo ----- NO ME HAGO RESPONSABLE DEL MAL USO DE LA HERRAMIENTA, PÉRDIDA DE DATOS Y
		echo       PROBLEMAS CAUSADOS AL SOFTWARE O HARDWARE.[0m
echo. & echo [41m--------------------------¡IMPORTANTE! ¡LEA ATENTAMENTE!--------------------------[0m
echo. & echo [97m----- Pulse INTRO si ha leído, entiende y acepta todo lo anterior.
echo. & echo ----------------------------------------------------------------------------------[0m& pause >nul & CLS
:UPDATE
echo ----------------------------------------------------------------------------------
echo. & echo [92m----- Versión actual: %ver%
echo. & echo [94m----- Buscando actualizaciones...
curl -o %temp% %url% -s
if errorlevel 1 (
	echo.
	echo [93m----- Error al conectarse a internet.
	timeout 5 >nul
	goto MENU
)
findstr /C:"set ver=" %temp% > %temp%.new
set /p ver_new=<"%temp%.new"
for /f "tokens=2 delims==" %%A in ("!ver_new!") do set "ver_new=%%A"
del "%temp%.new"
if %ver% neq %ver_new% (
	echo. & echo [93m----- Nueva versión disponible: %ver_new%
	echo. & echo [91m----- Al actualizar, la herramienta se reiniciará.
	echo [97m & choice /C SN /N /M "----- ¿Actualizar? (Recomendado) [S/N]: "
	if errorlevel 2 (
		goto MENU
	)
	move /y "%temp%" "%~dp0" > nul 2>&1
	start "" "%~dpnx0"
	exit
)
:MENU
DEL %temp%
CLS
COLOR 0F
echo ----------------------------------------------------------------------------------
echo. & echo [92m----- MENÚ PRINCIPAL
	echo. [97m
	echo. & echo ----- 0 para SALIR.
	echo. & echo ----- 1 para MANTENIMIENTO COMPLETO.
	echo. & echo ----- 2 para VERIFICAR ESTADO DE WINDOWS.
	echo. & echo ----- 3 para LIMPIEZA DE ARCHIVOS TEMPORALES.
	echo. & echo ----- 4 para COMPROBACIÓN Y REPARACIÓN DE DISCOS.
	echo. & echo ----- 5 para ACTIVAR/DESACTIVAR HIBERNACIÓN.
	echo. & echo ----- 6 para REESTABLECIMIENTO DE RED.
	echo. & echo ----- 7 para ANÁLISIS DE MEMORIA.
	echo. & echo ----- 8 para ANÁLISIS AUTOMÁTICO WINDOWS DEFENDER. [91m[AVANZADO]
	echo. & echo [97m----- 9 para PERMISOS LIMPIEZA "WindowsApps". [91m[AVANZADO]
			echo "C:\Program Files\WindowsApps" >nul
echo.
echo.
set /p Q=[97m----- Ejecutar...[0m 
	if "%Q%" == "" goto MENU
	if /I %Q% == M goto MENU
	if /I %Q% == 0 exit
	if /I %Q% == 1 goto COMPLETO
	if /I %Q% == 2 goto ESTADO
	if /I %Q% == 3 goto TEMP
	if /I %Q% == 4 goto DISCOS
	if /I %Q% == 5 goto HIBERNAR
	if /I %Q% == 6 goto RED
	if /I %Q% == 7 goto MEMORIA
	if /I %Q% == 8 goto DEFENDER
	if /I %Q% == 9 goto WINDOWSAPPS
		goto MENU
:COMPLETO
CLS
echo ----------------------------------------------------------------------------------
echo. & echo ----- Verificando estado de Windows... & color 09 & echo.
	echo ----- Paso 1 de 12...
	DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
		echo. & PowerShell Write-Host -Fore Red ----- Error detectado. Ejecutando reparaciones...
		echo. & DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Restorehealth >nul	
		echo ----- Reverificando estado de Windows... & echo.
			DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
				color 4F & echo ----- SE HAN ENCONTRADO DAÑOS EN LA IMAGEN DEL SISTEMA
				echo. & echo ----- Vuelva al menú y ejecute "VERIFICAR ESTADO DE WINDOWS"
				echo. & echo ----- Si vuelve a ver este mensaje, haga copia de seguridad de todos los archivos
				echo ----- importantes y pongase en contacto con un técnico para recibir asesoramiento
				echo. & echo ---------------------------------------------------------------------------------- & pause >nul & goto MENU
				)
	)
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
	echo [93m----- ATENCIÓN: En la fase final del siguiente paso se ejecutarán dos ventanas.
	echo ----- Un bug de Windows evita su cierre automático al finalizar.
	echo ----- Para completar el paso es necesario que el usuario actualice su estado
	echo ----- pasando el ratón por encima de dichas ventanas.
	echo ----- Si pasa el ratón y no se cierran, espere un minuto e intentelo de nuevo.[0m
	echo.
	echo [94m----- Paso 12 de 12...
		cleanmgr /verylowdisk /sagerun /f
			echo. & echo ----- Puede liberar mas espacio desactivando la hibernación.[0m
				goto COMPLETADO.REINICIO
:ESTADO
CLS
echo ----------------------------------------------------------------------------------
echo. & echo ----- Verificando estado de Windows... & COLOR 09 & echo.
	echo ----- Paso 1 de 2...
	DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
		echo. & PowerShell Write-Host -Fore Red ----- Error detectado. Ejecutando reparaciones...
		echo. & DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Restorehealth >nul	
		echo ----- Reverificando estado de Windows... & echo.
			DISM.exe /Quiet /NoRestart /Online /Cleanup-Image /Scanhealth >nul || (
				color 4F & echo ----- SE HAN ENCONTRADO DAÑOS EN LA IMAGEN DEL SISTEMA
				echo. & echo ----- Vuelva al menú y ejecute "VERIFICAR ESTADO DE WINDOWS"
				echo. & echo ----- Si vuelve a ver este mensaje, haga copia de seguridad de todos los archivos
				echo ----- importantes y pongase en contacto con un técnico para recibir asesoramiento
				echo. & echo ---------------------------------------------------------------------------------- & pause >nul & goto MENU
				)
	)
	echo ----- Paso 2 de 2...
	SFC /scannow >nul
		goto COMPLETADO.REINICIO
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
	echo [93m----- ATENCION: En la fase final del siguiente paso se ejecutarán dos ventanas.
	echo ----- Un bug de Windows evita su cierre automático al finalizar.
	echo ----- Para completar el paso es necesario que el usuario actualice su estado
	echo ----- pasando el ratón por encima de dichas ventanas.
	echo ----- Si pasa el ratón y no se cierran, espere un minuto e intentelo de nuevo.[0m
	echo.
	echo [94m----- Paso 10 de 10...
		cleanmgr /verylowdisk /sagerun /f
			echo. & echo ----- Puede liberar mas espacio desactivando la hibernación[0m
				goto COMPLETADO.REINICIO
:DISCOS
CLS
echo ----------------------------------------------------------------------------------
echo. & echo ----- Comprobando discos... & COLOR 09
	echo.
	wmic diskdrive get status || (
		PowerShell Write-Host -Fore Red ----- Error detectado. Ejecutando reparaciones...
			chkdsk /r /scan /perf >nul
			echo.
			echo ----- Reinicie la herramienta y ejecute "COMPROBACIÓN Y REPARACION DE DISCOS".
			echo.
			echo ----- Si vuelve a ver este mensaje, haga copia de seguridad de todos los archivos
			echo ----- importantes y pongase en contacto con un técnico para recibir asesoramiento.
			echo.
			echo ---------------------------------------------------------------------------------- & pause >nul & goto MENU)
				goto COMPLETADO
:HIBERNAR
CLS
echo ----------------------------------------------------------------------------------
echo.
echo ----- Obteniendo ajustes de hibernación... & COLOR 09
REG QUERY "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabled >nul 2>&1
if errorlevel == 0 goto HIBN
	echo.
	echo.
	echo [93m----- Estado actual: Activado.[0m & echo [94m
	echo. & echo ----- 1 para Desactivar.
	echo. & echo ----- 2 para Volver al menú.
	echo. & echo.
	set /P HIB=----- Ejecutar... & echo [0m
		if /I %HIB% == 1 (powercfg.exe /hibernate off > nul 2>&1 & echo
		echo. & echo ----- Hibernación desactivada. & goto COMPLETADO)
		if /I %HIB% == 2 goto MENU
		goto HIBERNAR
:HIBN
	echo.
	echo.
	echo [93m----- Estado actual: Desactivado.[0m & echo [94m		
	echo. & echo ----- 1 para Activar.
	echo. & echo ----- 2 para Volver al menú.
	echo. & echo.	
	set /P HIB=----- Ejecutar... & echo [0m
		if /I %HIB% == 1 (powercfg.exe /hibernate on > nul 2>&1 & echo.
		echo. & echo ----- Hibernación activada. & goto COMPLETADO)
		if /I %HIB% == 2 goto MENU
		goto HIBERNAR
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
		goto COMPLETADO.REINICIO
:MEMORIA
CLS
echo ----------------------------------------------------------------------------------
echo. & echo ----- Ejecutando programandor de análisis... & COLOR 09
	mdsched.exe
		echo. & echo [93m----- La duracion del análisis puede tardar varias horas.[0m
		echo. & echo [97m----- Pulse INTRO para continuar[0m & pause >nul
			goto COMPLETADO.REINICIO
:DEFENDER
CLS
echo ----------------------------------------------------------------------------------
echo. & echo ----- [91m¡ATENCIÓN! EL USO INADECUADO DE ESTA FUNCIÓN PUEDE COMPROMETER SU SISTEMA.[0m
echo.
	echo. & echo [97m----- M para MENU.
	echo. & echo ----- CONFIRMAR para EJECUTAR COMANDO.
	echo.
	echo.
		SET /P WA=----- Ejecutar... [0m 
			if "%WA%" == "" goto DEFENDER
			if /I %WA% == M goto MENU
			if /I %WA% == CONFIRMAR goto DEFENDER.CONFIRM
				goto DEFENDER
:DEFENDER.CONFIRM
CLS
echo ----------------------------------------------------------------------------------
echo. & echo ----- Obteniendo ajustes de análisis automático... & COLOR 09
	schtasks /query /tn "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /fo list > C:\Windows\Temp\WDSSTemp.txt 2>nul
	find "Deshabilitado" C:\Windows\Temp\WDSSTemp.txt >nul && goto DEF.CHECK
		echo.
		echo.
		echo [93m----- Estado actual: Activado.[0m & echo [94m
		echo. & echo ----- 1 para Desactivar.
		echo. & echo ----- 2 para Volver al menú.
		echo. & echo.
			set /P DEF=----- Ejecutar... & echo [0m
			if /I %DEF% == 1 (schtasks /Change /Disable /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" >nul & echo.
			echo. & echo ----- Análisis automático desactivado.
			del C:\Windows\Temp\WDSSTemp.txt 2>nul & goto COMPLETADO)
			if /I %DEF% == 2 goto MENU
				goto DEFENDER.CONFIRM
:DEF.CHECK
echo.
echo.		
echo [93m----- Estado actual: Desactivado.[0m & echo [94m		
echo. & echo ----- 1 para Activar.
echo. & echo ----- 2 para Volver al menú.
echo. & echo.	
set /P DEF=----- Ejecutar... & echo [0m
	if /I %DEF% == 1 (schtasks /Change /Enable /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" >nul & echo.
	echo. & echo ----- Análisis automático desactivado.
	del C:\Windows\Temp\WDSSTemp.txt 2>nul & goto COMPLETADO)
	if /I %DEF% == 2 goto MENU
	goto DEFENDER.CONFIRM
:WINDOWSAPPS
CLS
echo [97m----------------------------------------------------------------------------------
echo. & echo ----- [91m¡ATENCIÓN! EL USO INADECUADO DE ESTA FUNCION PUEDE COMPROMETER SU SISTEMA.[0m
echo.
	echo. & echo [97m----- M para MENU.
	echo. & echo ----- CONFIRMAR para EJECUTAR COMANDO.
	echo.
	echo.
		SET /P WA=----- Ejecutar... [0m
		if "%WA%" == "" goto WINDOWSAPPS
		if /I %WA% == M goto MENU
		if /I %WA% == CONFIRMAR goto WINDOWSAPPS.CONFIRM
			goto WINDOWSAPPS
:WINDOWSAPPS.CONFIRM
echo. & echo ----------------------------------------------------------------------------------
echo. & echo ----- Otorgando permisos en C:\Program Files\WindowsApps... & COLOR 09
	takeown /f "C:\Program Files\WindowsApps" /r >nul
	icacls "C:\Program Files\WindowsApps" /reset /t >nul
	start %windir%\explorer.exe "C:\Program Files\WindowsApps" >nul
		goto COMPLETADO
:COMPLETADO
echo.
echo. & echo ----- Completado. & COLOR 0A
echo. & echo ----- Pulse INTRO para volver al menú.
echo. & echo ---------------------------------------------------------------------------------- & pause >nul & goto MENU
:COMPLETADO.REINICIO
echo.
echo. & echo ----- Completado. Se recomienda reiniciar. & COLOR 0A
echo. & echo ----- Pulse INTRO para volver al menú.
echo. & echo ---------------------------------------------------------------------------------- & pause >nul & goto MENU
==================================================
# \# Versión actual: 0.18.9.0
# \# Cambios
- **0.18.0.0**
  ○ Relanzamiento a 0.XX.XX.XX
  ○ Actualizaciones automáticas mediante repositorio en GitHub
  ○ Eliminado registro de cambios oculto
  ○ Directorio de archivos temporales cambiado
- **0.18.1.0**
  ○ El usuario podrá elegir si quiere actualizar
- **0.18.2.0**
  ○ Al actualizar, se cerrará automáticamente para evitar posibles errores
  ○ Código para verificar la versión optimizado
- **0.18.3.0**
  ○ Cambios menores en la estructura
- **0.18.4.0**
  ○ Se redirigirá automáticamente al menú cuando no haya actualizaciones
  ○ Soporte de caracteres con tilde y "ñ"
- **0.18.5.0**
  ○ Código optimizado y reestructurado
- **0.18.6.0**
  ○ Código reestructurado y adaptado a cambios de 0.18.4.0
- **0.18.7.0**
  ○ Aviso inicial actualizado y reestructurado
- **0.18.8.0**
  ○ Notas de versión añadidas (no accesibles desde la herramienta)
- **0.18.9.0**
  ○ Menú de actualizaciones actualizado y código optimizado
# \# Errores
- **0.18.4.0**
  ○ Llamadas a PowerShell cambian la tipografía
# \# Errores corregidos
- **Corregido en GitHub**
  ○ Versiones inferiores a 0.18.2.0 no se actualizan automáticamente
  ○ Versiones inferiores a 0.18.6.0 pueden tener problemas para actualizarse
- **0.18.2.1**
  ○ Cierre inesperado al actualizarse a una nueva versión
  ○ No se elimina archivo temporal generado
- **0.18.3.1**
  ○ Nueva versión disponible" en bucle
- **0.18.6.1**
  ○ Errores menores en la estructura
- **0.18.7.0**
  ○ Errores ortográficos
- **0.18.8.0**
  ○ Errores ortográficos
- **0.18.8.1**
  ○ Actualizar sin conexión a internet genera un bucle, dejando inservible la herramienta
- **0.18.8.1**
  ○ Actualizar sin conexión a internet genera un bucle. Se puede evitar denegando la actualización
==================================================
# \# Cambios
- **1.17.0**
  ○ Código optimizado y reestructurado`
  ○ Nueva ruta de limpieza de archivos temporales
  ○ Visibilidad mejorada
  ○ Tamaño de ventana ajustado
  ○ Aviso inicial actualizado
- **Añadido en 1.17.1**
  ○ Capacidad de habilitar/deshabilitar análisis automáticos de Windows Defender **AVANZADO**
  ○ Redundancia añadida para prevenir ejecución inintencionada
  ○ Código reestructurado
- **Añadido en 1.17.2**
  ○ Código optimizado
- **Añadido en 1.17.3**
  ○ Limpieza de archivos temporales mejorada y optimizada
- **Añadido en 1.17.4**
  ○ Código optimizado y reestructurado
  ○ Tamaño de ventana reajustado
- **Añadido en 1.17.5**
  ○ Código optimizado y reestructurado
# \# Errores
- **1.17.0**
  ○ 
# \# Errores corregidos
- **1.17.0**
  ○ Error de redirección el cual provoca que se seleccione el disco local como objetivo de limpieza
==================================================
# \# Cambios
- **1.16.0**
  ○ Feedback de la herramienta
  ○ Selector de hibernación
  ○ Notificación por bug de Windows
  ○ Lectura de error mejorada
  ○ Función experimental
# \# Errores
- **1.16.0**
  ○ Error de redirección el cual provoca que se seleccione el disco local como objetivo de limpieza
# \# Errores corregidos
- **1.16.0**
  ○ 
==================================================
# \# 1.15 - AGREGADO PERMISO DE LIMPIEZA DE "C:\Program Files\WindowsApps"
# \# 1.14 - ELIMINADO ACCESO A FUNCIONES OBSOLETAS
# \# 1.13 - AGREGADA OPCIÓN EN LIMPIEZA DE ARCHIVOS TEMPORALES Y CÓDIGO OPTIMIZADO
# \# 1.12 - LIMPIEZA DE ARCHIVOS TEMPORALES MEJORADA Y CÓDIGO OPTIMIZADO
# \# 1.11 - CAMBIOS EN CÓDIGO, ESTRUCTURA, TEXTO Y CÓDIGO OPTIMIZADO
# \# 1.10 - AGREGADO CÓDIGO DE COLORES Y CÓDIGO OPTIMIZADO
# \# 1.9 - CAMBIOS EN CÓDIGO, ESTRUCTURA, MENÚ Y TEXTO
# \# 1.8 - CAMBIOS EN LA DETECCIÓN DE COMANDOS
# \# 1.7 - CAMBIOS EN EL AVISO INICIAL Y SU CÓDIGO
# \# 1.6 - CREACIÓN DEL APARTADO "VERSIÓN" Y CAMBIOS MENORES
# \# 1.5 - MEJORA EN COMANDOS DE ARCHIVOS TEMPORALES
# \# 1.4 - OPTIMIZACIÓN DEL CÓDIGO Y CAMBIOS EN LA INTERFAZ
# \# 1.3 - AGREGADOS COMANDOS INDEPENDIENTES PARA MANTENIMIENTO Y LIMPIEZA
# \# 1.2 - CAMBIO EN COMANDO DE REDIRECCIÓN
# \# 1.1 - CAMBIO EN ESTRUCTURA DEL MENÚ
# \# 1.0 - UNIFICACIÓN
# \# FASE 2 - CREACIÓN DE MENU
# \# FASE 1 - COMANDOS INDEPENDIENTES