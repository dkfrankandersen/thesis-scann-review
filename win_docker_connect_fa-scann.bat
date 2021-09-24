docker image ls -a
TIMEOUT 3

docker container ls -a
TIMEOUT 3

docker start fa-scann
TIMEOUT 3

docker attach fa-scann 