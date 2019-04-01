#!/bin/bash

# Comprobamos si el usuario es root
# En el texto entre `` tienes que añadir un comando que comprueba cuál es el usuario logueado actuamente

#USAREMOS EL COMANDO WHOAMI PARA QUE COMPRUEBE EL USUARIO LOGUEADO

# En esta validación se ejecutará un comando que busca si existe el segundo disco duro
# Se redirige la salida estándar y de error 
# Lo que tienes que añadir es un comando delante de > que busque el segundo disco duro
# En caso de que no lo encuentre, la validación de debajo comprueba si ha habido un error y en caso afirmativo termina el script


#PARA COMPROBAR QUE EL SEGUNDO DISCO DURO EXISTE, LANZAREMOS UN FDISK -L DEL DISCO 2, ES DEICR, DE /DEV/SDB. SI EXISTE, LA SALIDA DE $? SERÁ 0 Y POR LO TANTO SERÁ CORRECTO.

discos_proceso(){

echo "¿Desea comenzar el script? [s/N]"
read decision
if [ "$decision" = "s" ]
then
	echo "Ha seleccionado continuar"
	echo "El script va a ejecutarse..."
	sleep 1 
	discos_proceso_1
fi
	clear
	echo "Pulse intro para volver al menú principal"
}

discos_proceso_1(){
clear
echo "Comprobando la existencia del segundo disco"
fdisk /dev/sdb -l > /dev/null 2>&1
if [ $? -gt 0 ]; then
   echo No existe el dispositivo a montar
   exit 2
fi
sleep 1
echo "El disco 2 existe"

echo "***Presione cualquier tecla para continuar***"
read stop
echo "--------------------------------------------"

# Ejecuta un comando que devuelva el tamaño en GB del segundo disco duro
# El comando deberás incluirlo entre `` dentro de la variable denominada size

#PARA ESTO USAREMOS FDISK -L PARA QUE LISTE LOS DISCOS Y CON GREP, FILTRAMOS LA SALIDA PARA QUE NOS MUESTRE EL SEGUNDO DISCO. POR ÚLTIMO, CON CUT COGEMOS LA TERCERA Y CUARTA FILA DE LO QUE NOS HA FILTRADO QUE CORRESPONDE AL TAMAÑO DEL DISCO.
echo "Comprobando que el tamaño del disco sea correcto"
sleep 1

size=`fdisk -l | grep /dev/sdb | cut -d ' ' -f3`
if [ $size -le 5 ]; then
   echo El disco debe ser mayor que 5
   exit 3
fi

echo "El tamaño de disco es de : $size GB"


echo "El tamaño de disco es mayor de 5GB"
echo "***Presione cualquier tecla para continuar***"
read stop

echo "----------------------------------------------"

# Desmontamos la primera y segunda partición por si previamente existen
# Redirigimos la salida de error a /dev/null para que no nos muestre un error en el caso de que no existan
#VALIDAMOS QUE ESTEN MONTADAS ANTES DE INTENTAR DESMONTARLAS

#VALIDAREMOS USANDO UNA VARIABLE PARA CADA PARTICIÓN. SI LA SALIDA DEL COMANDO COINCIDE CON LA PARTICIÓN, LA DESMONTARÁ.
#PARA DESMONTAR, USAREMOS EL COMANDO UMOUNT Y REDIGIMOS LA SALIDA A /DEV/NULL CON >>

echo "Se van a desmontar las particiones del disco 2 en caso de existir"

echo "¿Desea continuar? [s/N]"
read eleccion
if [ "$eleccion" != "s" ]
then
	echo 'ha seleccionado no continar'
	echo 'Forzando salida del script'
	exit 2
fi

part1=`df -h | grep /dev/sdb1 | cut -d ' ' -f1`
part2=`df -h | grep /dev/sdb2 | cut -d ' ' -f1`

if [ "$part1" = "/dev/sdb1" ]
then
	umount /dev/sdb1 >> /dev/null 2>&1
	echo "Se ha desmontado la primera partición"
fi 

if [ "$part2" = "/dev/sdb2" ]
then
	umount /dev/sdb2 >> /dev/null 2>&1
	echo "Se ha desmontado la segunda partición"
fi 


sleep 1

echo "***Presione cualquier tecla para continuar***"
read stop

echo "-------------------------------------------------"

# Ahora en las líneas entre los dos EOF debes incluir todas las opciones necesarias para crear dos particiones
# La primera es de 5 GB y la segunda con la opción por defecto
# Puedes probar antes ejecutando el comando de forma interactiva 

echo "A continuación nuestro script va a crear las particiones necesarias"
echo "¿Desea continuar? [s/N]"
read eleccion
if [ "$eleccion" != "s" ]
then
	echo 'ha seleccionado no continar'
	echo 'Forzando salida del script'
	exit 2
fi

#VAMOS A USAR LOS PARÁMETROS N PARA CREAR LAS PARTICIONES, P PARA INDICAR QUE ES PRIMARIA Y EL TAMAÑO DEL PRIMER DISCO SE INDICA CON +5120M.
fdisk /dev/sdb <<EOF
n
p
1

+5120M
n
p
2


w
EOF

sleep 1

echo "Particiones creadas"
echo "***Presione cualquier tecla para continuar***"
read stop
echo "-------------------------------------------------"

# Ahora formateamos los discos duros y los montamos

#FORMATEAMOS CON EL COMANDO MKFS EN FORMATO EXT4 Y MONTAMOS CON EL COMANDO MOUNT. REDIRIGIMOS LA SALIDA DE ERROR DE MOUNT Y MKDIR A /DEV/NULL
echo "Se van a formatear las particiones"
echo "¿Desea continuar? [s/N]"
read eleccion
if [ "$eleccion" != "s" ]
then
	echo 'ha seleccionado no continar'
	echo 'Forzando salida del script'
	exit 2
fi
echo "Dando formato EXT4..."
echo "0%"
sleep 1
mkfs.ext4 /dev/sdb1
sleep 1
echo "50%"
mkfs.ext4 /dev/sdb2
sleep 1
echo "100%"
echo "formato completo"
echo "***Presione cualquier tecla para continuar***"
read stop
echo "-------------------------------------------------"


echo "Se van a montar los discos"
echo "¿Desea continuar? [s/N]"
read eleccion
if [ "$eleccion" != "s" ]
then
	echo 'ha seleccionado no continar'
	echo 'Forzando salida del script'
	exit 2
fi

mkdir /mnt/disco_1 >> /dev/null 2>&1
mkdir /mnt/disco_2 >> /dev/null 2>&1
mount /dev/sdb1 /mnt/disco_1 >> /dev/null 2>&1
mount /dev/sdb2 /mnt/disco_2 >> /dev/null 2>&1
sleep 1
echo "Se han montado los discos"

echo "***Presione cualquier tecla para continuar***"
read stop
echo "-------------------------------------------------"
# Cuando creamos la carpeta de montaje es recomendable redirigir la salida de error a /dev/null
# Esto se hace porque si se ejecuta el script varias veces y las carpetas existen, así ocultamos el error



# Añadimos los nuevos discos duros a /etc/fstab, aunque antes borramos la información que pueda haber antes en este fichero
# Para ello redirigimos a un fichero temporal todo el contenido de /etc/fstab excepto aquellas líneas que contienen sdb
# Sobreescribimos /etc/fstab con el contenido del fichero temporal y después borramos el temporal


echo "Se va a configurar el archivo de configuración fstab"
echo "¿Desea continuar? [s/N]"
read eleccion
if [ "$eleccion" != "s" ]
then
	echo 'ha seleccionado no continar'
	echo 'Forzando salida del script'
	exit 2
fi
#REDIRIGIMOS EL CONTENIDO DE FSTAB EXCEPTO LAS LINEAS DE SDB AL ARCHIVO TEMPORAL
cat /etc/fstab | grep -v sdb > /etc/fstabtemp

#SOBREESCRIBIMOS EL FSTAB CON EL CONTENIDO DE NUESTRO ARCHIVO TEMPORAL Y BORRAMOS EL ARCHIVO TEMPORAL
cp /etc/fstabtemp /etc/fstab
rm -rf /etc/fstabtemp

#AÑADIMOS LOS DISCOS DUROS EN EL FSTAB CON EL COMANDO ECHO Y >>
echo /dev/sdb1 /mnt/disco_1 ext4 defaults  >> /etc/fstab
echo /dev/sdb2 /mnt/disco_2 ext4 defaults  >> /etc/fstab

sleep 1
echo "Se añadieron los discos correctamente"

echo "***Presione cualquier tecla para continuar***"
read stop
echo "---------------------------------------------------"



# La variable $actual almacena el primer usuario logueado en el sistema. Debes ejecutar un comando que devuelva solo el nombre de este usuario

#CON EL COMANDO WHO SACAMOS LOS USUARIOS DEL SISTEMA Y ESA SALIDA LA FILTRAMOS CON HEAD Y CUT PARA QUE NOS SAQUE SOLO EL PRIMER CAMPO DE LA PRIMERA FILA (EL USUARIO LOGUEDAO) Y LO GUARDE EN LA VARIABLE ACTUAL
actual=`who | head -1 | cut -d ' ' -f1`


# Ahora quedaría copiar el directorio personal del usuario a la carpeta donde está montada la primera partición del disco
# Para acceder a una carpeta utilizando una variable, se puede reemplazar en la ruta el texto de las carpetas por la variable
# Por ejemplo /home/$nombre_variable (o /home/$1 en caso de que fuera un parámetro)

#COPIAMOS LA CARPETA DEL USUARIO DE FORMA RECURSIVA CON CP -R 

echo "Copiando contenido del home del usuario a su nueva ruta..."
cp -r /home/$actual/* /mnt/disco_1
sleep 1
echo "Copiado con éxito"
echo "-----------------------------------------------------"
echo "El script se ha ejecutado con éxito"
}
