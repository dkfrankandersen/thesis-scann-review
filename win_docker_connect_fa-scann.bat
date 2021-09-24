docker image ls -a
ECHO.
TIMEOUT 3


docker container ls -a
ECHO.
TIMEOUT 3


docker start fa-scann
ECHO.
TIMEOUT 3

docker attach fa-scann 