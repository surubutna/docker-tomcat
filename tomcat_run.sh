#!/bin/bash

RED='\033[31;1m'   #red
GREEN='\033[32;1m'   #green
BLUE='\033[34;1m'   #blue
NC='\033[0m'   #no color

#Check Dockerfile
if [ ! -f Dockerfile ]; then
  echo -e "\n${RED}ERROR: Dockerfile not found in the current directory.${NC}\n"
  exit 1
fi

IMAGE_NAME="tomcat-ssl3"
CONTAINER_NAME="tomcat-ssl3-container"

#Build image
echo -e "\n${BLUE}Building $IMAGE_NAME image...${NC}\n"
docker build -t $IMAGE_NAME .

#Check build
if [ $? -ne 0 ]; then
  echo -e"\n${RED}ERROR: Failed to build $IMAGE_NAME image.${NC}\n"
  exit 1
fi

#Run container
echo -e "\n${BLUE}Running $CONTAINER_NAME...${NC}\n"
docker run -d -p 4041:4041 --name $CONTAINER_NAME $IMAGE_NAME

#Check run
if [ $? -ne 0 ]; then
  echo -e "\n${RED}Failed to start $CONTAINER_NAME container.${NC}\n"
  exit 1
fi

#A-Ok
echo -e "\n${GREEN}$CONTAINER_NAME is running successfully.${NC} \n\nAccess app at https://localhost:4041/sample \n"
