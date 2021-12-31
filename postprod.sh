cat header                >> index.html
echo '<div id="recipes">' >> index.html
markdown recipes.md       >> index.html
echo '</div>'             >> index.html
cat rightHandSide.html    >> index.html
cat footer                >> index.html
