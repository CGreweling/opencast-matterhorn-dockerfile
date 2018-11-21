Opencast Matterhorn Dockerfile
==============================

To create a docker container for Opencast Matterhorn, please follow these steps.
They will clone this git repository and build a docker image called
opencast-matterhorn.

```
edit Dockerfile
change [your_username]:[password] to your own credentials for https://pkg.opencast.org/ .

docker build -t opencast .
docker run it --name=opencasttest -p 8080:8080 opencast /bin/sh

activemq start
/etc/init.d/activemq start

start opencast
/etc/init.d/opencast start

Open a browser:
http://localhost:8080
```
