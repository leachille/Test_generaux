source color.sh

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

#Norminette
#------------------------------------------------------------
echo "${vio_}TEST FILE CHECKER${nul}"

find $acces -name "*.c" | rev | cut -f1 -d "/" | rev | cut -f1 -d "." > fichier_c.txt

sh file_checker.sh $acces
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
