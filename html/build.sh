#!/bin/bash

cmd="$1"

listmd() {
  find . | grep '\.md$' | sed 's/\.md$//'
}

listdir() {
  listmd | grep -o '^.*/' | uniq
}

case "$cmd" in
  build)
    listdir | while read f; do mkdir -p "$f"; done
    listmd  | while read f; do markdown "$f".md > "$f".html; done
    ;;
  
  clean)
    listmd  | while read f; do rm -f "$f".html; done
    listdir | while read f; do if [ -e "$f" ]; then rmdir -p "$f"; fi; done
    rm -f s.sh~
    ;;
  
  *)
    echo "Usage: $0 (build|clean)"
esac
