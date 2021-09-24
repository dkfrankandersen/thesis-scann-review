docker image ls -a
echo.
sleep 3

docker container ls -a
echo.
sleep 3

docker start fa-scann
echo.
sleep 3

docker attach fa-scann 
sleep 3