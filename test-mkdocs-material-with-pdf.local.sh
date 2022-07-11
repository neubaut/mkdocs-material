#!/bin/sh

# Build mkdocs-material-with-pdf image with local mkdocs-with-pdf
#
# 1. Cleanup
# 2. Clone mkdocs-with-pdf
# 3. Create polyfills
# 4. Build image
# 5. Run (create site + pdf)
# 6. Open pdf


for i in $(docker ps -a | grep mkdoc | awk {'print $1'}); do docker stop $i; done
for i in $(docker ps -a | grep mkdoc | awk {'print $1'}); do docker rm $i; done
docker rmi mkdocs-material-with-pdf

if [ ! -d mkdocs-with-pdf ]; then
  git clone https://github.com/neubaut/mkdocs-with-pdf.git
fi

pwd=$(pwd)
cd mkdocs-with-pdf/custum_style_src/material-polyfills
npm install
npm run build
cp dist/* $pwd/mkdocs-with-pdf/mkdocs_with_pdf/themes
cd $pwd
ls -l mkdocs-with-pdf/mkdocs_with_pdf/themes

docker build . -f ./Dockerfile.mkdocs-material-with-pdf.local -t mkdocs-material-with-pdf

if [ $? -eq 0 ]; then
  docker run -it --rm -v $(pwd):/docs mkdocs-material-with-pdf
  if [ $? -eq 0 ]; then
    xdg-open site/pdf/document.pdf
  fi
fi

