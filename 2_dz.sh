#!/bin/bash
while getopts "d:n:" option
do
  case $option in
    n ) name="$OPTARG";;
    d ) path="$OPTARG";;
  esac
done

arch=$(tar -cz $path | base64)

echo "#!/bin/bash
arch=\"$arch\"
while getopts \"o:\" opt
do
    case \$opt in
    o ) unpack="\$OPTARG";;
    esac
done
if [ \$unpack ]
then
    echo \"\$arch\" | base64 --decode | tar -xvz -C \$unpack
else
    echo \"\$arch\" | base64 --decode | tar -xvz
fi" > $name.sh

chmod 755 $name.sh