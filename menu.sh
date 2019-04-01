#!/bin/bash
#ESTE SERÁ MI MENÚ QUE ME LLEVARÁ A LOS SCRIPTS QUE VAYA REALIZANDO EN LAS PRÁCTICAS
source discob.sh
source dosusuarios.sh
source procesos.sh
source array.sh


# Validación del usuario root
usuario=`whoami` 
if [ $usuario != "root" ]
then
	echo El script tiene que ejecutarse con usuario root
	exit 1
fi


#ESTO SERÁ LO QUE SE NOS MOSTRARÁ POR PANTALLA PARA VISUALIZAR LAS DIFERENTES OPCCIONES.
menu(){
	clear
echo "+++++Scripts:+++++"
echo "1]--> Script usuarios"
echo "2]--> Script discos"
echo "3]--> Script procesos"
echo "4]--> Script array"
echo "5]--> Salir del script"
echo "++++++++++++++++++++"
echo ""
echo "Seleccione un script"
	read eleccion 
}


#CON ESTE BUCLE WHILE PODREMOS EJECUTAR EL SCRIPT QUE SELECCIONEMOS Y VOLVER AL MENÚ AL TERMINAR SU EJECUCIÓN. UNA VEZ ESTEMOS DE NUEVO EN EL MENÚ, PODREMOS VOLER A SELECCIONAR OTRO SCRIPT Y ASÍ DE FORMA SUCESIVA HASTA QUE ELIJAMOS SALIR.


while [ "$eleccion" != "5" ];
do
	menu

	case $eleccion in
	1) clear;
		echo "Se ha seleccionado el script de usuarios."
		sleep 1
		usuarios_pregunta
		read stop
	;;

	2) clear;
		echo "Se ha seleccionado el script de discos."
		sleep 1
		discos_proceso
		read stop

	;;

	3) clear;
		echo "Se ha seleccionado el script de procesos"
		sleep 1
		procesos_proceso
		read stop
	;;
	

	4) clear;
		echo "Ha seleccionado el script de array"
		sleep 1
		array_1
		read stop
	;;
	5) clear;
		echo "Saliendo del script..."
		exit 0 
	;;


	esac
done




