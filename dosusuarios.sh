#!/bin/bash



usuarios_pregunta(){
#Se pregunta al usuario si quiere comenzar el script, en caso negativo, se vuelve al menú principal

echo "En este script vamos a crear de forma automática usuarios y grupos"
echo ""
echo "¿Desea comenzar el script? [s/N]"
read decision
if [ "$decision" = "s" ]
then
	echo "Ha seleccionado continuar"
	clear
	usuarios_proceso

fi

clear
echo "Pulse intro para volver al menú principal"

}


usuarios_proceso(){
# El usuario 1 es $1 (primer parámetro), el usuario 2 es $2 (segundo parámetro) y el grupo es $3 (tercer parámetro)
# $1, $2 y $3 son variables que se pueden utilizar en los comandos (por ejemplo /home/$1 sería el directorio del usuario 1)


# Aquí se añade el código para crear usuarios y grupos
# [COMPLETAR]
# primero creo el grupo para posteriormente poder añadir los usuarios al mismo y en la creación de usuarios añado el primero al grupo y el segundo al grupo root para que tenga permisos de administrador. Por último con usermod, añado el segundo usuario al grupo1 (como secundario).
clear
echo "Escribe el nombre del grupo al que se van a añadir los usuarios:"
read grupo
groupadd -g 2005 $grupo
echo ""

echo "¿Cuántos usuarios quiere crear?"
read cuantia

while [ "$cuantia" -gt "0" ]
do
	clear
	echo "Introduzca el nombre del usuario $cuantia :"
	read nombre
	useradd -d /home/$nombre -m -g $grupo $nombre
	echo "Usuario creado con éxito"
	echo ""

	echo "Introduce una contraseña para el usuario $cuantia :"
	read password	
	pass=$(openssl passwd -crypt $password)
	usermod -p $pass $nombre
	echo "Contraseña establecida con éxito"

	cuantia=$((cuantia - 1))
done

# Aquí se asigna una contraseña al usuario $2
# [COMPLETAR]
#----------------------------------------------------------------------------------------------------------------------------------------------




# Debajo actualizamos los paquetes sin mostrar nada por pantalla redirigiendo la salida a /dev/null

clear
echo "Se están actualizandos los paquetes..."
apt-get -y update > /dev/null 2>&1

# Control de errores por si hay algún problema al actualizar los paquetes
clear
if [ $? -gt 0 ]; then
   echo Error al actualizar los paquetes
fi

#El parámetro $paquete es el nombre del software a instalar (en este caso se ha guardado en una variable)
#Se pregunta antes si se quiere instalar un paquete.

echo ""
echo "+++++++++++++++++++++++++++++++++++++"
echo ""

echo "¿Desea instalar un paquete? [s/N]"
read decision
if [ "$decision" = "s" ]
then
	instalar_paquete
fi

instalar_paquete(){

echo "Introduce el nombre del paquete a instalar"
read paquete
clear
apt-get -y install $paquete

# Control de errores por si algún problema al instalar el paquete que se recibe por parámetro
if [ $? -gt 0 ]; then
   echo Error al instalar el paquete $paquete. Puede que no exista
fi
}

}



