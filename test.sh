tmp=0
if [ -a ./chemin ];
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
if [ -a $acces/auteur ]
then
	{
		echo "Fichier auteur trouve"
	}
	if [ $(logname) != $(cat $acces/auteur) ]
	then
		{
			echo "Fichier Auteur : KO!"
			echo Nom dans export : $(logname)
			echo "Nom dans fichier auteur : $(cat $acces/auteur)"
		}
	else
		{
			echo "Fichier Auteur : OK"
		}
	fi
else
	{
		echo "Fichier Auteur non trouve: KO!"
		echo "path : $acces/auteur"
	}
fi

#Norminette
#------------------------------------------------------------
#norminette -R CheckForbiddenSourceHeader $acces

#Makefile
#------------------------------------------------------------
make fclean -C $acces >/dev/null 2> Make_error/make_fclean.txt
make -C $acces >/dev/null 2> Make_error/make.txt
make all -C $acces >/dev/null 2> Make_error/make_all.txt
make clean -C $acces >/dev/null 2> Make_error/make_clean.txt
make re -C $acces >/dev/null 2> Make_error/make_re.txt
