docker stop fa-scann
echo.
sleep 3

docker container ls -a
echo.
sleep 3

docker container rm fa-scann
echo.
sleep 3

docker image ls -a
echo.
sleep 3

docker image rm scann-fa-base
echo.
sleep 3

docker build -t scann-fa-base .
echo.
sleep 3

docker run --name fa-scann -it scann-fa-base:latest /bin/bash