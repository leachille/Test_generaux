source color.sh

for i in Makefile Libft.h
do
	nb=$(wc -l fichier_c.txt | cut -f1 -d "f" | rev | cut -f2 -d " " | rev)
	nberror=0

	while true; do
		nom_c=$(sed -n "${nb} p" fichier_c.txt)
		if [ $(grep "${nom_c}" $1/${i} | wc -l | bc) = 0 ]
		then
			{
				echo "${yel}${nom_c} ${red}n'est pas present dans le ${i}${nul}"
				((nberror++))
			}
		fi
		if [ $nb = 1 ]
		then
			{
				if [ $nberror != 0 ]
				then
					{
						echo "Nombre fichier manquant : ${red}$nberror${nul}"
					}
				else
					{
						echo "${green}Aucun fichier manquant dans ${blu}${i}${nul}"
					}
				fi
				break
			}
		fi
		((nb--))
	done
	sleep 2
done
