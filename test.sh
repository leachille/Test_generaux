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
if [ -f $acces/auteur ]
then
	{
		echo "Fichier auteur trouve"
	}
	if [ $(logall) != $(cat $acces/auteur) ]
	then
		{
			echo "Fichier Auteur : KO!"
			echo Nom dans export : $(logall)
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
all=$(cat $acces/Makefile | tr "\t" " " | grep "all " | cut -f3 -d " ")
make fclean -C $acces >/dev/null 2> Make_error/make_fclean.txt
make $all -C $acces >/dev/null 2> Make_error/make_all.txt
make all -C $acces >/dev/null 2> Make_error/make_all.txt
make clean -C $acces >/dev/null 2> Make_error/make_clean.txt
make re -C $acces >/dev/null 2> Make_error/make_re.txt
erreur=$(grep 'Error\|Warning' Make_error/make_all.txt | wc -l)
if [ $erreur != 0 ]
then
	{
		echo "Make all : ERROR"
		echo "nb erreurs : $erreur"
	}
else
	{
		echo "Make all : OK"
	}
fi
erreur=$(grep 'Error\|Warning' Make_error/make_all.txt | wc -l)
if [ $erreur != 0 ]
then
	{
		echo "Make all : ERROR"
		echo "nb erreurs : $erreur"
	}
else
	{
		echo "Make all : OK"
	}
fi
erreur=$(grep 'Error\|Warning' Make_error/make_all.txt | wc -l)
if [ $erreur != 0 ]
then
	{
		echo "Make all : ERROR"
		echo "nb erreurs : $erreur"
	}
else
	{
		echo "Make all : OK"
	}
fi
