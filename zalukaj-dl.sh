#!/bin/bash

#Copyright © 2016 Damian Majchrzak (DamiaX)
#https://github.com/DamiaX/zalukaj.tv-dl/

version="0.5"
app_name="Zalukaj.com-DL"
temp_files=(.temp.dvs .out.dvs .title.dvs .up.sh);
connect_test_url=(google.com facebook.com kernel.org);
vshare_url="https://raw.githubusercontent.com/DamiaX/D-Vshare.io/master/d-vshare";
version_url="https://raw.githubusercontent.com/DamiaX/zalukaj.tv-dl/master/VERSION";
pl_url="https://raw.githubusercontent.com/DamiaX/zalukaj.tv-dl/master/Language/zalukaj.pl.lang";
en_url="https://raw.githubusercontent.com/DamiaX/zalukaj.tv-dl/master/Language/zalukaj.en.lang";
pl_name=".zalukaj.pl.lang"
en_name=".zalukaj.en.lang"
up="https://raw.githubusercontent.com/DamiaX/zalukaj.tv-dl/master/Core/up.sh"
video_dir="$HOME/Zalukaj.tv_Movies"
arg1="$1"
term="/dev/tty";
vshare_name=".d-vshare.sh"

langpl()
{
if [ ! -e $pl_name ] ; then
wget -q $pl_url -O  $pl_name;
fi
}

langen()
{
if [ ! -e $en_name ] ; then
wget -q $en_url -O  $en_name;
fi
}

lang_init_pl()
{
source $pl_name;
}

lang_init_en()
{
source $en_name;
}

case $LANG in
*PL*) 
langpl;
lang_init_pl;
 ;;
*) 
langen;
lang_init_en;
 ;;
esac

show_text()
{
	echo -e -n "\E[$1;1m$2\033[0m"
 	echo ""
}

test_connect()
{
ping -q -c1 ${connect_test_url[0]} > "${temp_files[0]}";
if [ "$?" -eq "2" ];
then
ping -q -c1 ${connect_test_url[1]} > "${temp_files[0]}";
if [ "$?" -eq "2" ];
then
ping -q -c1 ${connect_test_url[2]} > "${temp_files[0]}";
if [ "$?" -eq "2" ];
then
if [ "$1" = "0" ]
then
show_text 31 "$no_connect";
rm -rf "${temp_files[0]}";
exit;
else
rm -rf "${temp_files[0]}";
exit;
fi
fi
fi
fi
}

update()
{
wget --no-cache --no-dns-cache -q $version_url -O ${temp_files[0]}
echo "$version" > ${temp_files[1]}

cat ${temp_files[0]}|tr . , >${temp_files[2]}
cat ${temp_files[1]}|tr . , >${temp_files[0]}

sed -i 's@,@@g' ${temp_files[0]}
sed -i 's@,@@g' ${temp_files[2]}

ver7=`cat "${temp_files[0]}"`
ver9=`cat "${temp_files[2]}"`

if [ $ver7 -eq $ver9 ]
    then
show_text 35 "=> $new_version"
else
show_text 37 "=> $download_new"

wget -q $up -O ${temp_files[3]}

chmod +x "${temp_files[3]}"

./"${temp_files[3]}" $0
exit;
fi
}

check_data()
{
if [[ ! -d $video_dir ]] ;
then
mkdir $video_dir;
fi
}

parse_f()
{
sed -i 's@src="/player.php?@ <program>http://zalukaj.com/player.php?@g' ${temp_files[0]};
sed -i 's@" width="490" height="370"@ </program>@g' ${temp_files[0]};
grep "<program>" ${temp_files[0]} > ${temp_files[1]};
awk -vRS="</program>" '{gsub(/.*<program.*>/,"");print}' ${temp_files[1]} > ${temp_files[0]};
grep "http://zalukaj.tv/player.php?" ${temp_files[0]} > ${temp_files[1]};
sed -i 's@id=@x=1\&id=@g' ${temp_files[1]};
link=`cat ${temp_files[1]}`;
wget -q $link -O ${temp_files[0]};
}
 
parse_t()
{
 sed -i 's@<iframe src="http://vshare.io/v/@ <program>http://vshare.io/d/@g' ${temp_files[0]};
 sed -i 's@/width-470/height-305/"@</program> @g' ${temp_files[0]};
 grep "<program>" ${temp_files[0]} > ${temp_files[1]};
 awk -vRS="</program>" '{gsub(/.*<program.*>/,"");print}' ${temp_files[1]} > ${temp_files[0]};
 grep "http://vshare.io/d/" ${temp_files[0]} > ${temp_files[1]};
 link=`cat ${temp_files[1]}`;
}
 
title()
{
sed -i 's@- Zalukaj.com@@g' ${temp_files[0]};
cat ${temp_files[0]} | grep -oPm1 "(?<=<title>)[^<]+" > ${temp_files[2]};
sed -i 's@/@-@g' ${temp_files[2]};
sed -i 's/[ \t]*$//' ${temp_files[2]};
video_title=`cat ${temp_files[2]}`;
}

include()
{
if [[ ! -e $vshare_name ]] ; then
wget -q $vshare_url -O $vshare_name;
fi
}

default_answer()
{
if [ -z $answer ]; then
answer='y';
fi
}

hello()
{
clear;
clear_data;
show_text 33 "$app_name [$version]";
test_connect;
update;
check_data;
}

clear_data()
{
rm -rf  ${temp_files[*]};
}

check_arg()
{
if [ -z "$arg1" ]; 
then
show_text 31 "$ask_url"
read url;
wget -q $url -O ${temp_files[0]};
else
wget -q $arg1 -O ${temp_files[0]};
fi
}

main()
{
hello;
include;
check_arg;
title;
parse_f;
parse_t;
clear_data;
./$vshare_name "$link" "$video_title" "$video_dir"
}

main;
