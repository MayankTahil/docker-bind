
# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/sameersbn/bind) and is the recommended method of installation.

> **Note**: Builds are also available on [Quay.io](https://quay.io/repository/sameersbn/bind)

```bash
docker pull mayankt/dhcpdns
```

Alternatively you can build the image yourself.

```bash
docker build -t mayankt/dhcpd github.com/mayanktahil/docker-bind
```

## Quickstart

Start DHCP and DHS Service for DDNS byt first updating the [`docker-compose.yaml`](./docker-compose.yaml) with your desired values and configs. 

Within this repository's directory, simply enter:

```bash
docker-compose up -d
```

When the container is started the [Webmin](http://www.webmin.com/) service is also started and is accessible from the web browser at http://localhost:10000. Login to Webmin with the username `admin` and password `{Specified in docker-composed.yaml}`.

The launch of Webmin can be inserting an argument within the `docker-compose.yaml` file by adding `--env WEBMIN_ENABLED=false`.

## Persistence

This is built into the `docker-compose.yaml` file as specified by the volume mounds (1: Webmin 2: dhcp 3:bind).