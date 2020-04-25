# icinga-satellite
An easy-to-use Dockerized Icinga2 satellite setup. It could be used as an
Icinga2 agent aswell, but I don't think that would make much sense. The goal
is instead to create an easy-to-deploy satellite Docker.

## Environment variables
Everything is controlled using the follwing environment variables.

* **CN** is the Common Name of the satellite
* **ZONE** is the Zone name in which the satellite is. If no zone is specified
  it defaults to using the **CN** as the zone.
* **PARENTCN** is the Common Name of the parent host, for example the master. If
  no **PARENTCN** is specified it defaults to using the **PARENTHOST** as a
  **PARENTCN**
* **PARENTHOST** is the FQDN or IP of the parent host, for example the master.
* **PARENTPORT** is the Icinga2 port on the parent host. Defaults to 5665.
* **TICKET** is the ticket you get from the master (if you are using Director
  you find it under the Agent tab of the host).
* **ACCEPT_CONFIG** takes a *y* or *n* value for yes or no. The default is
  *n*(o).
* **ACCEPT_COMMANDS** takes a *y* or *n* value for yes or no. The default is
  *n*(o).
* **DISABLE_CONFD** takes a *y* or *n* value for yes or no. The default is
  *y*(es). This should be a sane default for most people.

## Example usage
```
#> docker run -d --name my-icinga-sat \
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
```

