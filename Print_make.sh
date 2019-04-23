#couleur
red="\033[31m"
yel="\033[33m"
green="\033[32m"
nul="\033[0m"


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
    echo "Make $regle : ${yel}OK${nul}"
    echo "Warning : $warning"
  }
else
  {
    echo "Make $regle : ${green}OK${nul}"
  }
fi
