#!/bin/bash

echo "Recettes" >> index.md;
echo "========" >> index.md;

for i in $(  ls ../*.md | sed s/\.md// | sed 's/\.\.\///' | grep -v "README\|index" ); do
  j=$( head -n 1 ../$i.md | sed s/\// );
  for k in $( cat ../$i.md | sed "s/ /\n/g" | sed -n "/#/,/ /p" | sed "s/#//" ); do
    echo "* [$j]($i.html)" >> index.$k.md;
  done;
  echo "* [$j]($i.html)" >> index.md;
  sed "1i[Retour à l'index](index.html)\n" ../$i.md > $i.md;
  sed -i "s/#/\\\\#/g" $i.md;
done

echo ""           >> index.md;
echo "Mots clefs" >> index.md;
echo "==========" >> index.md;

for i in $( ls *.md | grep -e "index\..*\.md" | sed 's/index\.//' | sed "s/\.md//" ); do
  echo "* [$i](index.$i.html)" >> index.md;
  sed -i "1i[Retour à l'index](index.html)\n" index.$i.md;
done;
