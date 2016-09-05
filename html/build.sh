#!/bin/bash

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
  echo '<div id="recipes">'  >> "$file".html
  markdown "$file".md        >> "$file".html
  echo '</div>'              >> "$file".html
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
