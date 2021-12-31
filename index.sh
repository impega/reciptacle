#!/bin/bash

echo "Recettes"             >> recipes.md;
echo "========"             >> recipes.md;

for i in $(  ls ../*.md | sed s/\.md// | sed 's/\.\.\///' | grep -v "README\|index" ); do
  j=$( head -n 1 ../"$i".md );
  for k in $( cat ../"$i".md | sed "s/ /\n/g" | sed -n "/#/,/ /p" | sed "s/#//" | sed '/^[[:space:]]*$/d' ); do
    echo "* [$j]($i.html)" >> index."$k".md;
  done;
  echo "* [$j]($i.html)" >> recipes.md;
  cp ../"$i".md "$i".md;
  sed -i "s/#\([^[:space:]]*\)[[:space:]]*/[#\1](index.\1.html)/g" "$i".md;
done

echo "Mots clefs"              >> keywords.md;
echo "=========="              >> keywords.md;

for i in $( ls *.md | grep -e "index\..*\.md" | sed 's/index\.//' | sed "s/\.md//" ); do
  number=$(wc -l index.$i.md | sed 's/\([0-9]*\) .*$/\1/')
  #  echo "* [$i ($number))](index.$i.html)" >> keywords.md;
  size=$(echo "$number 3" | awk '{printf "%.2fem", $1/$2+1}')
  echo "<span style='font-size:${size}'><a href='index.$i.html'>$i</a></span>" >> keywords.md;
  sed -i "1i$i\n=====\n" index."$i".md;
done;

