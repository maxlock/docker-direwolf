# Dockerfile to run direwolf.

To build:

'docker build --tag direwolf:latest .'

To run:

'docker container run -it --rm --device /dev/snd --device /dev/hidraw0 --volume /mnt/docker_direwolf:/direwolf direwolf:latest'
