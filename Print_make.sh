#couleur
source color.sh

erreur=$(cat test_make/error.txt)
warning=$(cat test_make/warning.txt)
regle=$(cat test_make/regle.txt)

if [ $erreur != 0 ]
then
  {
    if [ $warning != 0 ]
    then
      {
        echo "Make $regle : ERROR"
        echo "Erreurs : ${red}$erreur${nul}"
        echo "warning : ${yel}$warning${nul}"
      }
    else [ $warning = 0 ]
      {
        echo "Make $regle : ${red}ERROR${nul}"
        echo "Erreurs : ${red}$erreur"
      }
    fi
  }
elif [ $warning != 0 ]
then
  {
    echo "Make $regle :"
	echo "${up}				${yel}OK${nul}"
    echo "Warning : $warning"
  }
else
  {
    echo "Make $regle :"
	echo "${up}				${green}OK${nul}"
  }
fi
