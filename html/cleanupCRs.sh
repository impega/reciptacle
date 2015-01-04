for i in $( ls ../*.md ); do
  sed -i "//d" "$i";
done;
