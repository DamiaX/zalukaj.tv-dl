#!/bin/bash

#Copyright © 2016 Damian Majchrzak (DamiaX)
#http://damiax.github.io/zalukaj.tv-dl/

url="https://raw.githubusercontent.com/DamiaX/zalukaj.tv-dl/master/zalukaj-dl.sh";
name="$1";

rm -rf $name;

wget -q $url -O $name;
chmod +x $name;
./$name;
rm -rf $0;
exit;
