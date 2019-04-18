ln=`ssh-keygen -f ~/.ssh/known_hosts -l -F "$1" |  awk '/line/ { print $NF }'`

echo $ln

#re='^[0-9]+$'
#if ! [[ $1 =~ $re ]] ; then
#   echo "error: Not a number" >&2; exit 1
#fi

if [[ $ln = *[!\ ]* ]]; then
  echo "\$param contains characters other than space"
else
  echo "\$param consists of spaces only"
fi