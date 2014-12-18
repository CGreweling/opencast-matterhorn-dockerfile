Opencast Matterhorn Dockerfile
==============================

To create a docker container for Opencast Matterhorn, please follow these steps.
They will clone this git repository and build a docker image called
opencast-matterhorn.

```
docker build -t opencast-matterhorn https://github.com/cgreweling/opencast-matterhorn-dockerfile.git
docker run -d --name=matterhorntest -p 8080:8080 opencast-matterhorn
```
