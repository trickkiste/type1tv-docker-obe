docker-stackbrew-obe-rt
=======================

Dockerfile for OpenBroadcastEncoder

A [Stackbrew/Ubuntu](https://github.com/tianon/docker-brew-ubuntu/tree/precise)-based image for [Docker](http://docker.io/), with [OBE](https://github.com/ob-encoder/obe-rt) installed.

This image has been tested on a Ubuntu 14.04 host only.
Docker setup is not part of this manual.

* Copy init/obe-docker.conf to /etc/init/ on your host system.
* Edit OBE settings in it to your requirements.
* Install the latest Blackmagic drivers on the system.
* Create a obe Docker container with the following command:
sudo docker run -t --name obe --privileged -v /dev/blackmagic:/dev/blackmagic -v /etc/blackmagic/BlackmagicPreferences.xml:/etc/blackmagic/BlackmagicPreferences.xml trickkiste/docker-stackbrew-obe-rt-custom
* stop the container so startup can be managed by Upstart: sudo docker kill obe
* Start OBE with: sudo start obe-docker
* Watch what is going on with: sudo tmux a -t obe
