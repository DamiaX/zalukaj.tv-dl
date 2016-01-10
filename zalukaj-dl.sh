#!/bin/bash

temp_files=(.temp.dvs .out.dvs title.dvs);

wget -q $1 -O ${temp_files[0]};

parse_f()
{
sed -i 's@src="/player.php?@ <program>http://zalukaj.tv/player.php?@g' ${temp_files[0]};
sed -i 's@" width="490" height="370"@ </program>@g' ${temp_files[0]};
grep "<program>" ${temp_files[0]} > ${temp_files[1]};
awk -vRS="</program>" '{gsub(/.*<program.*>/,"");print}' ${temp_files[1]} > ${temp_files[0]};
grep "http://zalukaj.tv/player.php?" ${temp_files[0]} > ${temp_files[1]};
sed -i 's@id=@x=1\&id=@g' ${temp_files[1]};
link=`cat ${temp_files[1]}`;
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
sed -i 's@- Zalukaj.tv@@g' ${temp_files[0]};
cat ${temp_files[0]} | grep -oPm1 "(?<=<title>)[^<]+" > ${temp_files[2]};
sed -i 's@/@-@g' ${temp_files[2]};
sed -i 's/[ \t]*$//' ${temp_files[2]};
video_title=`cat ${temp_files[2]}`;
}

title;
parse_f;
wget -q $link -O ${temp_files[0]};
parse_t;
rm -rf  ${temp_files[*]};

./d-vshare.sh "$link" "$video_title"
