# QGIS Server

## Overview

This is a small demo repo. It utilizes several practices:

- build QGIS-Server directly from source (resulting image size is around 1gb)
- strictly separate QGIS-Server from the Webserver
- `pg_service.conf` file per project (sufficient for many things but mainly useful for DEV/STAG/PROD etc)
- Gateway route trafic to QGIS-Server, project is determined by subdomain (http://test.localhost:8081/wfs3 uses `test/test.qgs` and `test/pg_service.conf`)
- project file is sent as `fcgi param` instead of `url param` `map` (avoid ugly url rewriting)
- wfs3 is working fully with multiple projects
- a listing of avalable projects can be shown http://localhost:8081/projects/
- Webserver answers correctly 404 if project file does not exist (traffic does not go all the way to QGIS-Server)
- use [tini](https://github.com/krallin/tini) to transparently send signals (stopping/killing docker containers is working - aka no wait time until force) and correct handling of maybe existing zombie processes (cleaning in long running deployments)

All this is a demonstrator setup. It showcases the possibilities to produce minuscule images and resource saving scalable variable setup.

## HowTo

```
docker-compose build
docker compose up -d
```

- [Projects list page](http://localhost:8081/projects/)
- [Test project OGC (WMS/WFS/etc.)](http://test.localhost:8081/ogc) or [Test project OGC (WMS/WFS/etc.)](http://test.localhost:8081)
- [Test project WFS3](http://test.localhost:8081/wfs3)

## Stats

The main difference between regular scenario and this one is the number of qgis processes inside a container and the slightly smaller memory footprint.
The stats below show 2 servers deploments in idle. While the difference in this situation is minimal it spreads a lot when systems get load. While we
can't handle/scale resources well in the regular aproach it can be handled better in this showcase approach. Especially if combined with a queue system
to even out the load better (with simple webserver in front the problem of request jam/no good load balancing still exists).

### This showcase scenario

```
CONTAINER ID   NAME            CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O        PIDS
4a238bc8e49d   qgis-server-2   0.00%     87.8MiB / 30.19GiB    0.28%     9.73MB / 9.43MB   0B / 193kB       8
f6f482728e10   qgis-server-1   0.01%     92.8MiB / 30.19GiB    0.30%     10.7MB / 9.31MB   0B / 193kB       8
```

### A regular setup with [opengisch/qgis-server:3.28.4-jammy](https://hub.docker.com/r/opengisch/qgis-server)

```
CONTAINER ID   NAME            CPU %     MEM USAGE / LIMIT     MEM %     NET I/O         BLOCK I/O         PIDS
e83de12a953f   qgis-server-1   0.00%     106.7MiB / 30.19GiB   0.35%     12.6kB / 726B   0B / 3.59MB       40
6205ee06edc5   qgis-server-2   0.00%     120.6MiB / 30.19GiB   0.39%     12.3kB / 656B   0B / 3.59MB       40
```

### Docker image sizes

```
REPOSITORY             TAG           IMAGE ID       CREATED         SIZE
qgis-server-showcase   3.34.5        3a88ff9d87d6   2 hours ago     1.1GB
opengisch/qgis-server  3.28.4-jammy  9ca95b03e286   13 months ago   2.2GB
```