cat header                   >> index.html
echo "<div id=\"recipes\">"  >> index.html
cat  recipes.html            >> index.html
echo "</div>"                >> index.html
echo "<div id=\"keywords\">" >> index.html
cat keywords.html            >> index.html
echo "</div>"                >> index.html
cat footer                   >> index.html
