red="\033[31m"
yel="\033[33m"
green="\033[32m"
vio_="\033[35;4m"
blu="\033[36m"
nul="\033[0m"

tmp=0
if [ -f ./chemin ];
then
	{
		echo "voulez vous changer le chemin d'acces ?"
		echo "0 = NON || 1 = OUI"
		read tmp
		if [ $tmp = 1 ]
		then
			{
				echo "donner chemin d'acces"
				read tmp
				echo $tmp > chemin
			}
		fi
	}
else
	{
		echo "donner chemin d'acces"
		read > chemin
	}
fi
acces=$(cat ./chemin)
clear

#Fichier auteur
#------------------------------------------------------------
echo "${vio_}TEST FICHIER AUTEUR${nul}"
if [ -f $acces/auteur ]
then
	{
		echo "${green}Fichier auteur trouve${nul}"
	}
	if [ $(logname) != $(cat $acces/auteur) ]
	then
		{
			echo "Fichier Auteur : ${red}KO!${nul}"
			echo Nom dans export : $(logname)
			echo "Nom dans fichier auteur : $(cat $acces/auteur)"
		}
	else
		{
			echo "Fichier Auteur : ${green}OK${nul}"
		}
	fi
else
	{
		echo "Fichier Auteur non trouve: ${red}KO!${nul}"
		echo "path : $acces/auteur"
	}
fi

#Makefile
#------------------------------------------------------------
echo "${vio_}TEST MAKEFILE${nul}"

name=$(cat $acces/Makefile | tr "\t" " " | grep "NAME " | cut -f3 -d " ")
make fclean -C $acces >/dev/null 2> Make_error/make_fclean.txt
make $name -C $acces >/dev/null 2> Make_error/make.txt
make all -C $acces >/dev/null 2> Make_error/make_all.txt
make re -C $acces >/dev/null 2> Make_error/make_re.txt
make clean -C $acces >/dev/null 2> Make_error/make_clean.txt
grep -w 'error' Make_error/make.txt | wc -l > test_make/error.txt
grep -w 'warning' Make_error/make.txt | wc -l > test_make/warning.txt
echo "NAME" > test_make/regle.txt
sh print_make.sh

grep -w 'error' Make_error/make_all.txt | wc -l > test_make/error.txt
grep -w 'warning' Make_error/make_all.txt | wc -l > test_make/warning.txt
echo "all" > test_make/regle.txt
sh print_make.sh

grep -w 'error' Make_error/make_clean.txt | wc -l > test_make/error.txt
grep -w 'warning' Make_error/make_clean.txt | wc -l > test_make/warning.txt
echo "clean" > test_make/regle.txt
sh print_make.sh

grep -w 'error' Make_error/make_fclean.txt | wc -l > test_make/error.txt
grep -w 'warning' Make_error/make_fclean.txt | wc -l > test_make/warning.txt
echo "fclean" > test_make/regle.txt
sh print_make.sh

grep -w 'error' Make_error/make_re.txt | wc -l > test_make/error.txt
grep -w 'warning' Make_error/make_re.txt | wc -l > test_make/warning.txt
echo "re" > test_make/regle.txt
sh print_make.sh

echo "${blu}Test Fichier Manquant dans le Makefile${nul}"

find $acces -name "*.c" | rev | cut -f1 -d "/" | rev | cut -f1 -d "." > lesSRC/fichier_c
cat $acces/Makefile | grep -e "ft_*c*" | grep -v "ft_.(" | grep -v "NAME" | cut -f1 -d '.' | rev | tr "\t" " " |cut -f1 -d " " | rev > lesSRC/Fich_c_dansMakefile

nb=$(wc -l lesSRC/fichier_c | cut -f1 -d "f" | rev | cut -f2 -d " " | rev)
nberror=0

while true; do
	nom_c=$(sed -n "${nb} p" lesSRC/fichier_c)
	if [ $(grep "${nom_c}" lesSRC/Fich_c_dansMakefile | wc -l | bc) = 0 ]
	then
		{
			echo "${yel}${nom_c} ${red}n'est pas present dans le Makefile${nul}"
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
					echo "${green}Aucun fichier manquant${nul}"
				}
			fi
			break
		}
	fi
	((nb--))
done

#Norminette
#------------------------------------------------------------
echo "${vio_}TEST NORMINETTE${nul}"

norminette -R CheckForbiddenSourceHeader $acces > Normi_deepthough.txt
error_norme=$(norminette -R CheckForbiddenSourceHeader $acces/*.c $acces/*.h | grep "Error" | wc -l)
warning_norme=$(norminette -R CheckForbiddenSourceHeader $acces/*.c $acces/*.h | grep "Warning" | wc -l)

if [ $error_norme != 0 ]
then
	{
		echo "Nb d'erreurs:  ${red}$error_norme${nul}"
	}
else
	{
		echo "${green}Pas d'erreurs de normes${nul}"
	}
fi
if [ $warning_norme != 0 ]
then
	{
		echo "Nb de warning: ${yel}$warning_norme${nul}"
	}
fi
echo "Aller voir Normi_deepthough.txt pour plus de precision"
