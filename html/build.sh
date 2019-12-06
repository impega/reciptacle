#!/bin/bash

set -eu

cmd="$1"

listmd() {
  find . | grep '\.md$' | grep -v "keywords.md" | sed 's/\.md$//'
}

listdir() {
  listmd | grep -o '^.*/' | uniq
}

rightHandSide() {
  echo '<div id="rhs">'      >> rightHandSide.html
  echo '<div id="keywords">' >> rightHandSide.html
  markdown keywords.md       >> rightHandSide.html
  echo '</div>'              >> rightHandSide.html
  cat index                  >> rightHandSide.html
  echo '</div>'              >> rightHandSide.html
}

recipe() {
  file="$1"
  cp header "$file".html
  title=$(head -n1 "$file".md)
  sed -i "s/<title>/<title>${title//\//\\/} - /" "$file".html;
  echo '<article id="recipes" itemscope itemtype="http://schema.org/Recipe">'  >> "$file".html
  # la description est la première balise après le titre. probablement un
  # paragraphe
  # les li avant préparation sont des ingrédients
  # les instructions suivent "préparation"
  # les mots-clés suivent "Mots clefs"
  markdown "$file".md | \
    sed 's/<h1/<h1 itemprop=\"name\"/' | \
    sed '{N; N; s/\(<h1[^>]*>[^>]*>[[:space:]]*<p\)/\1 itemprop=\"description\"/}' | \
    sed -r\
      -e '1h;2,$H;$!d;g'\
      -e ":loop"\
      -e 's/<li>(.*Pr(é|e)paration)/<li itemprop=\"recipeIngredient\">\1/g'\
      -e "t loop" | \
    sed -r \
      -e '1h;2,$H;$!d;g'\
      -e 's#(<h2>Pr(é|e)paration[^>]*>[^<]*<\w*)#\1 itemprop=\"recipeInstructions\"#' |\
    sed -r \
      -e '1h;2,$H;$!d;g'\
      -e 's#(<h2>Mots[^>]*>[^<]*<\w*)#\1 itemprop=\"keywords\"#' \
    >> "$file".html

  echo '</article>'              >> "$file".html
  cat rightHandSide.html     >> "$file".html
  cat footer                 >> "$file".html
}

case "$cmd" in
  build)
    rightHandSide
    listdir | while read f; do mkdir -p "$f"; done
    listmd  | while read f; do recipe "$f"; done
    ;;

  clean)
    listmd  | while read f; do rm -f "$f".html; done
    listdir | while read f; do if [ -e "$f" ]; then rmdir -p "$f"; fi; done
    rm -f s.sh~
    ;;

  *)
    echo "Usage: $0 (build|clean)"
esac
