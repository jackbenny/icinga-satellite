# icinga-satellite
An easy-to-use Dockerized Icinga2 satellite setup. It could be used as an
Icinga2 agent aswell, but I don't think that would make much sense. The goal
is instead to create an easy-to-deploy satellite image.

![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/jackbenny/icinga-satellite?sort=date)
![Docker Pulls](https://img.shields.io/docker/pulls/jackbenny/icinga-satellite)
![Docker Stars](https://img.shields.io/docker/stars/jackbenny/icinga-satellite)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/jackbenny/icinga-satellite)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/jackbenny/icinga-satellite)

## Tags and their respective Dockerfile

### Main tags
* [0.6, latest](https://github.com/jackbenny/icinga-satellite/blob/master/Dockerfile)
* [0.5](https://github.com/jackbenny/icinga-satellite/blob/0.5/Dockerfile)
* [0.4](https://github.com/jackbenny/icinga-satellite/blob/0.4/Dockerfile)
* [0.3](https://github.com/jackbenny/icinga-satellite/blob/0.3/Dockerfile)
* [0.2](https://github.com/jackbenny/icinga-satellite/blob/0.2/Dockerfile)
* [0.1](https://github.com/jackbenny/icinga-satellite/blob/0.1/Dockerfile)

### Alpine tags (currently has some problems)
* [0.1.1-alpine](https://github.com/jackbenny/icinga-satellite/blob/0.1.1-alpine/Dockerfile)
* [0.1-alpine](https://github.com/jackbenny/icinga-satellite/blob/0.1-alpine/Dockerfile)

> **NOTE:** Currently there are some problems with the Alpine image. 
> Use the *main images* instead, tagged *0.n*.

There are two available images for you to choose from. The main images (0.*n*) are based on
Debian 10-slim from tag 0.5 and up. Previous to 0.5 they were based on Ubuntu 18.04. 
The main images uses Icinga2 from Icingas official repository. 

The other images (0.*n*-alpine) are based on Alpine with Icinga2 from Alpines repository. 
From 0.1.1-alpine and up, the Alpine images are built on the latest Alpine image. Previous to
0.1.1 they were based on Alpine 3.11.

## Environment variables
Everything is controlled using the following environment variables.

* **CN** is the Common Name of the satellite
* **ZONE** is the zone in which this satellite should be in. If no zone is specified
  it defaults to using the **CN** as the zone.
* **PARENTCN** is the Common Name of the parent host, for example the master. If
  no **PARENTCN** is specified it defaults to using the **PARENTHOST** as a
  **PARENTCN**
* **PARENTHOST** is the FQDN or IP of the parent host, for example the master.
* **PARENTPORT** is the Icinga2 port on the parent host. Defaults to 5665.
* **TICKET** is the ticket you get from the master (if you are using Director
  you find it under the Agent tab of the host).
* **TICKET_PATH** is the path to the ticket secrets file if you use Swarm and wants to use
  secrets instead (to keep your ticket secure). The ticket should be on ONE line only 
  and be created as an external secret. This variable is optional and only apply for
  Docker Swarm.
* **ACCEPT_CONFIG** takes a ***y*** or ***n*** value for yes or no. The default is
  ***n***
* **ACCEPT_COMMANDS** takes a ***y*** or ***n*** value for yes or no. The default is
  ***n***
* **DISABLE_CONFD** takes a ***y*** or ***n*** value for yes or no. The default is
  ***y***. This should be a sane default for most people.
* **LOCAL_TIMEZONE** sets the local timezone of the satellite. For example
  *Europe/Stockholm* or *America/New_York*

## Example usage
```
#> docker run -d --name my-icinga-sat \
  -p 5665:5665 \
  -e CN=icinga-sat02.local \
  -e PARENTHOST=icinga-master.local \
  -e PARENTCN=icinga-master.local \
  -e PARENTZONE=master \
  -e TICKET=124de0573705d1133db62a974aaf \
  -e DISABLE_CONFD=y -e ACCEPT_CONFIG=y -e ACCEPT_COMMANDS=y \ 
   jackbenny/icinga-satellite
```

## docker-compose.yml example
```
version: "3.8"
services:
  my-icinga-sat:
    image: jackbenny/icinga-satellite
    ports:
      - 5665:5665
    restart:always
    environment:
      - CN=icinga-sat02.local
      - ZONE=icinga-sat02.local
      - PARENTHOST=icinga-master.local
      - PARENTCN=icinga-master.local
      - PARENTZONE=master
      - TICKET=124de0573705d1133db62a974aaf
      - ACCEPT_CONFIG=y
      - ACCEPT_COMMANDS=y
      - DISABLE_CONFD=y
      - LOCAL_TIMEZONE=Europe/Stockholm
```

## docker-compose.yml example with Docker secrets
```
version: "3.8"
services:
  my-icinga-sat:
    image: jackbenny/icinga-satellite
    environment:
      - CN=icinga-sat02.local
      - PARENTHOST=icinga-master.local
      - PARENTZONE=master
      - TICKET_PATH=/var/run/secrets/ticket
      - ACCEPT_CONFIG=y
      - ACCEPT_COMMANDS=y
      - DISABLE_CONFD=y
      - LOCAL_TIMEZONE=Europe/Stockholm
    secrets:
      - ticket
secrets:
  ticket:
    external: true
```

