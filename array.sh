array_1(){
clear

array=()

echo "Valores del array"

for ((i=0;i<20; i++))
   do
	num=$(($RANDOM%199))
	array[$i]=$num
   done

echo ${array[@]}


for ((i=0;i<20;i++))
   do
	num=$((array[$i]))

	resto=$((num%2))
	if [ "$resto" = "0" ]
	then
		par=$(($par+1))

	else
		impar=$((impar+1))
	fi


   done
	echo ""
	echo "Números pares: $par" 
	echo "Números impares: $impar"
}
