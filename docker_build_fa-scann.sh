#!/bin/bash
sudo docker stop fa-scann
printf "\n"
sleep 3

sudo docker container ls -a
printf "\n"
sleep 3

sudo docker container rm fa-scann
printf "\n"
sleep 3

sudo docker image ls -a
printf "\n"
sleep 3

sudo docker image rm fa-scann-compiled
printf "\n"
sleep 3

sudo docker builder prune -a -f
printf "\n"
sleep 3

sudo docker build --no-cache -t fa-scann-compiled .
printf "\n"
sleep 3

sudo docker run --name fa-scann -it fa-scann-compiled:latest /bin/bash