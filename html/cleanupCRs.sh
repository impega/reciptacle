for i in $( ls ../*.md ); do
  sed -i "s///g" "$i";
done;
