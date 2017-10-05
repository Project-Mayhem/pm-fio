#!/bin/bash
# Docker buildcycle script
# Build and automate cleanup - good to use on a dev box where this is the
# only project you are workingo on.

REPO_AND_IMAGE='falenn/pm-fio:1.0.9'
CONTAINER_NAME='pm-fio'

# remove built image for rebuild
docker rmi $(docker images | grep -v $REPO_AND_IMAGE | awk { 'print $3' })
# docker rmi $(docker images | awk {'print $3'})
# remove any images that are left around
# docker rmi $(docker images -f dangling=true -q)

# remove any existing stopped containers
docker ps -a | awk '{ print $1 }' | xargs docker rm
docker ps -a | awk '{ print $1,$2 }' | grep $REPO_AND_IMAGE | awk '{ print $1 }' | xargs -I {} docker rm -f {}

# build the image, removing intermediate layers, deleting cache
# docker build --rm --no-cache -t "$REPO_AND_IMAGE" .
docker build --no-cache -t "$REPO_AND_IMAGE" .

if [[ $? -eq 0 ]] ; then
  docker push $REPO_AND_IMAGE
fi
# run in interactive for debugging / development
docker run \
      --name $CONTAINER_NAME \
      -v config:/config \
      -l $CONTAINER_NAME \
      -it \
      $REPO_AND_IMAGE \
      --entrypoint="/bin/bash"
      # -it for interactive mode
      # --entrypoint="/bin/bash" for debugging

# attach to the new container
#docker attach -it $REPO_AND_IMAGE

# follow stdout
# docker logs -f $CONTAINER_NAME
