cat header                 >> index.html
echo '<div id="recipes">'  >> index.html
markdown recipes.md        >> index.html
echo '</div>'              >> index.html
echo '<div id="keywords">' >> index.html
markdown keywords.md       >> index.html
echo '</div>'              >> index.html
cat footer                 >> index.html
