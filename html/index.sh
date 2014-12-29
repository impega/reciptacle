#!/bin/bash

for i in $(  ls ../*.md | sed s/\.md// | sed 's/\.\.\///' | grep -v "README\|index" ); do
  j=$( head -n 1 ../$i.md | sed s/\// );
  echo "* [$j]($i.html)";
  sed -i "1i[Retour à l'index](index.html)\n" ../$i.md;
done
