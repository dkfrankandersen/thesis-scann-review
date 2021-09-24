docker stop fa-scann
TIMEOUT 3

docker container ls -a
TIMEOUT 3

docker container rm fa-scann
TIMEOUT 3

docker image ls -a
TIMEOUT 3

docker image rm scann-fa-base
TIMEOUT 3

docker build -t scann-fa-base .
TIMEOUT 3

docker run --name fa-scann -it scann-fa-base:latest /bin/bash