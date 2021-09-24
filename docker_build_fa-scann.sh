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

sudo docker image rm scann-fa-base
printf "\n"
sleep 3

sudo docker build -t scann-fa-base .
printf "\n"
sleep 3

sudo docker run --name fa-scann -it scann-fa-base:latest /bin/bash