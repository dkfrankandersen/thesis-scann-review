docker stop fa-scann
ECHO.
TIMEOUT 3

docker container ls -a
ECHO.
TIMEOUT 3

docker container rm fa-scann
ECHO.
TIMEOUT 3

docker image ls -a
ECHO.
TIMEOUT 3

docker image rm scann-fa-base
ECHO.
TIMEOUT 3

docker build -t scann-fa-base .
ECHO.
TIMEOUT 3

docker run --name fa-scann -it scann-fa-base:latest /bin/bash