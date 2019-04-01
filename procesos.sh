#!/bin/bash

#INICIAR MODO MONITOR PARA LOS COMANDOS FG Y BG
set -m

menu_procesos(){
	clear
	echo "++++++++SCRIPT PROCESOS+++++++"
	echo "1]--> PROCESOS"
	echo "2]--> PRIORIDADES"
	echo "3]--> VOLVER AL MENÚ PRINCIPAL"
	echo "++++++++++++++++++++++++++++++"
	echo ""
	echo "Selecciona una opción"
	read opcion
}


procesos_proceso(){

while [ "$opcion" != "3" ]
do
	menu_procesos
	
	case $opcion in 

	1)
		clear
		echo "Ha seleccionado procesos"
		sleep 1
		procesos2
		
	;;

	2)
		clear
		echo "Ha seleccionado prioridades"
		sleep 1
		prioridades
		
	;;

	esac

done
	opcion="0"
	echo ""
 	echo "Pulse intro para volver al menú principal"
}

#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



menu_procesos2(){
clear
echo "+++++++++++ Opciones procesos: +++++++++++"
echo "1]--> Consulta de procesos"
echo "2]--> Enviar señal a proceso"
echo "3]--> Cambiar un proceso a primer plano o segundo plano"
echo "4]--> Salir"
echo "++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo "Seleccione una opción"
	read eleccion_proceso 
}



procesos2(){
clear
while [ "$eleccion_proceso" != "4" ]
do
	menu_procesos2
	
	case $eleccion_proceso  in 

	1)
		clear
		echo "Ha seleccionado cosultar procesos"
		sleep 1
		
		ps -aux || grep 
		read stop
	;;

	2)
		clear
		echo "Ha seleccionado mandar señal a proceso"
		sleep 1
		senal
	;;

	3)
		clear
		echo "Ha seleccionado cambiar un proceso a primer plano o segundo plano"
		sleep 2
		fg_bg

		
	;;

	esac

done
 	eleccion_proceso="0"
	echo ""
 	echo "Pulse intro para volver"
}


senal(){
	clear
	echo "1- Introduce el PID del proceso"
	read pid
	
	se="99"
	while [ "$se" -gt "64" ]
	   do
		kill -l
		echo ""
		echo "2- Selecciona la señal a mandar"
		read se
	   done


	kill $pid $se
	sleep 1

	if [ "$?" -eq "0" ]
	   then
		echo "Error, no se pudo enviar la señal"

	fi
}


fg_bg_menu(){
	clear
	echo "+++++ Cambiar un proceso a primer plano o segundo plano +++++"
	echo " 1]--> Lazar comando sleep en segundo plano"
	echo " 2]--> Listar procesos en segundo plano"
	echo " 3]--> Pasar a primer plano"
	echo " 4]--> Pasar a segundo plano"
	echo " 5]--> Volver"
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo ""
	echo "Selecciona una opción"
	read opcionbg

}

fg_bg(){

while [ "$opcionbg" != "5" ]
do
	fg_bg_menu

	case $opcionbg in

	1)
		clear

		echo "Introduce los segundos"
		read segundos
		sleep $segundos & 
		
	;;

	2) 
		clear
		jobs 
		read stop
	;;

	3)
		clear
		
		jobs
		echo ""
		echo "Introduce el número del proceso"
		read num
		fg $num
		read stop
	;;

	4)
		clear
		echo "Introduce el número del proceso"
		read num
		bg $num
		read stop
	;;


	esac
done
	
	opcionbg="0"
	echo ""
 	echo "Pulse intro para volver"
	
	}


#//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

menu_prioridad(){
clear
echo "+++++ Opciones prioridades: +++++"
echo "1]--> Mostrar procesos"
echo "2]--> Lanzar comando con una prioridad determinada"
echo "3]--> Cambiar prioridad en tiempo real"
echo "4]--> Salir"
echo "++++++++++++++++++++"
echo ""
echo "Seleccione una opción"
	read eleccion_prioridad 
}


prioridades(){
clear
while [ "$eleccion_prioridad" != "4" ]
do
	menu_prioridad
	
	case $eleccion_prioridad in 

	1)
		clear
		echo "Ha seleccionado mostrar procesos"
		sleep 1
		clear
		ps -aux
		read stop
	;;

	2)
		clear
		echo "Ha seleccionado lanzar comando con una determinada prioridad"
		sleep 3
		clear
		echo "Introduce el comando"
		read comand
		echo ""
		echo "Introduce la prioridad"
		read prioridad
	
		nice -n $prioridad $comand
		read stop
	;;

	3)
		clear
		echo "Ha seleccionado cambiar prioridad en tiempo real"
		sleep 3
		clear
		echo "Introduce el pid del proceso"
		read pidd
		echo ""
		echo "Introduce la prioridad"
		read prioridad
	
		nice $prioridad -p $pidd
		read stop
	;;

	esac

done
 	 eleccion_prioridad="0"
	echo ""
 	echo "Pulse intro para volver"
}

	

