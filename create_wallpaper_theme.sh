#!/bin/sh

if [ $# -ne 6 ]; then
    echo "usage: script.sh -n theme_name -l light_wallpaper -d dark_wallpaper"
    exit 1
fi

while getopts n:l:d: flag
do
    case "${flag}" in
        n) name=${OPTARG};;
        l) light=${OPTARG};;
        d) dark=${OPTARG};;
    esac
done

themepath="/usr/share/gnome-background-properties/"
bgpath="/usr/share/backgrounds/"

if [ ! -d "$themepath" ]; then
    echo "issue: $themepath doesn't exist"
    exit 1
fi

if [ ! -d "$bgpath" ]; then
    echo "issue: $bgpath doesn't exist"
    exit 1
fi

customwp="${bgpath}custom/"
lexp=$(echo "$light" | awk -F . '{print $NF}')
dexp=$(echo "$dark" | awk -F . '{print $NF}')
lightwp=$customwp$name-l.$lexp
darkwp=$customwp$name-d.$dexp
themefile=$themepath$name.xml

mkdir -p $customwp
cp "$light" "$lightwp"
cp "$dark" "$darkwp"

chmod +r-wx "$lightwp"
chmod +r-wx "$darkwp"

touch $themefile
echo '<?xml version="1.0"?>' > $themefile
echo '<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">' >> $themefile
echo '<wallpapers>' >> $themefile
echo '  <wallpaper deleted="false">' >> $themefile
echo '    <name>'$name'</name>' >> $themefile
echo '    <filename>'$lightwp'</filename>' >> $themefile
echo '    <filename-dark>'$darkwp'</filename-dark>' >> $themefile
echo '    <options>zoom</options>' >> $themefile
echo '    <shade_type>solid</shade_type>' >> $themefile
echo '    <pcolor>#241f31</pcolor>' >> $themefile
echo '    <scolor>#000000</scolor>' >> $themefile
echo '  </wallpaper>' >> $themefile
echo '</wallpapers>' >> $themefile
