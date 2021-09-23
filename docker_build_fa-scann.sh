#!/bin/bash

sudo docker build -t scann-fa-base .
sudo docker run --name fa-scann -it scann-fa-base:latest /bin/bash 