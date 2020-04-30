# icinga-satellite
An easy-to-use Dockerized Icinga2 satellite setup. It could be used as an
Icinga2 agent aswell, but I don't think that would make much sense. The goal
is instead to create an easy-to-deploy satellite Docker.

## Tags

### Main tags
* **0.4, latest**
* **0.3**
* **0.2**
* **0.1**

### Alpine tags (currently has some problems)
* **0.1.1-alpine**
* **0.1-alpine**

> **NOTE:** Currently there are some problems with the Alpine image. Use the main images
> instead, tagged *0.n*.

There are two available images for you to choose from. The default ones (0.*n*) are based on
Ubuntu 18.04, with Icinga2 from Icingas official repository. The other images (0.*n*-alpine) is
based on Alpine 3.11, with Icinga2 from Alpines repository. From 0.1.1-alpine and up, the Alpine
image is built on the latest Alpine.

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


