# sipp-docker

SIPp with Docker Compose support

- [sipp-docker](#sipp-docker)
  - [What offers?](#what-offers)
  - [How can i use it?](#how-can-i-use-it)
    - [Build image](#build-image)
    - [Run Container](#run-container)
      - [Without arguments (for checking only if SIPp is available - outputs version info)](#without-arguments-for-checking-only-if-sipp-is-available---outputs-version-info)
      - [Execute SIPp scenario - from local terminal](#execute-sipp-scenario---from-local-terminal)
      - [Execute SIPp scenario - inside container](#execute-sipp-scenario---inside-container)

## What offers?

- Easy way to test/change between versions;
- Easy way to build with different FLAGS;
- Easy way to add and execute scenarios;

## How can i use it?

### Build image

```sh
docker compose build sipp
```

### Run Container

#### Without arguments (for checking only if SIPp is available - outputs version info)

```sh
docker compose up sipp
```

#### Execute SIPp scenario - from local terminal

```sh
docker compose run sipp sipp -i 172.25.0.1 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/options/options.xml
docker compose run sipp sipp -i 172.25.0.1 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/register/register.xml -inf /opt/register/register.csv
```

#### Execute SIPp scenario - inside container

```sh
docker compose run sipp shell
cd /opt ## sipp-scenarios folder volume target
sipp -i 10.0.0.1 -p 5060 10.0.0.2:5060 -r 1 -m 1 -sf options/options.xml
```
