#!/bin/sh

# Build mkdocs-material-with-pdf image
#
# 1. Cleanup
# 2. Build image 
# 3. Run (create site + pdf)
# 4. Open pdf

for i in $(docker ps -a | grep mkdoc | awk {'print $1'}); do docker stop $i; done
for i in $(docker ps -a | grep mkdoc | awk {'print $1'}); do docker rm $i; done
docker rmi mkdocs-material-with-pdf

docker build . -f ./Dockerfile.mkdocs-material-with-pdf -t mkdocs-material-with-pdf

if [ $? -eq 0 ]; then
  docker run -it --rm -v $(pwd):/docs mkdocs-material-with-pdf
  if [ $? -eq 0 ]; then
    xdg-open site/pdf/document.pdf
  fi
fi

