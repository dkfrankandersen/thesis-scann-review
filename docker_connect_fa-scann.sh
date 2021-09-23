#!/bin/bash
sudo docker image ls -a
printf "\n"
sleep 3
sudo docker container ls -a
printf "\n"
sleep 3
sudo docker start fa-scann
printf "\n"
sleep 3
sudo docker attach fa-scann 
printf "\n"