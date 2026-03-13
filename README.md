# sipp-docker

SIPp with Docker Compose support

- [sipp-docker](#sipp-docker)
  - [What offers?](#what-offers)
  - [How can i use it?](#how-can-i-use-it)
    - [Use Image directly](#use-image-directly)
      - [Build Image](#build-image)
      - [Run Image](#run-image)
    - [Docker-Compose](#docker-compose)
      - [Build image](#build-image-1)
      - [Run Container](#run-container)
        - [Without arguments (for checking only if SIPp is available - outputs version info)](#without-arguments-for-checking-only-if-sipp-is-available---outputs-version-info)
        - [Execute SIPp scenario - from local terminal](#execute-sipp-scenario---from-local-terminal)
        - [Execute SIPp scenario - inside container](#execute-sipp-scenario---inside-container)
  - [Reject Scenario](#reject-scenario)
  - [UAS sends BYE Scenario](#uas-sends-bye-scenario)
  - [UAS forces Hold Scenario](#uas-forces-hold-scenario)
  - [UAC Re-Invites](#uac-re-invites)
  - [UAC as internal](#uac-as-internal)
  - [UAC as internal with audio on both sides](#uac-as-internal-with-audio-on-both-sides)
  - [UAC as provider](#uac-as-provider)

## What offers?

- Easy way to test/change between versions;
- Easy way to build with different FLAGS;
- Easy way to add and execute scenarios;

## How can i use it?

### Use Image directly

#### Build Image

Build the Docker image with the specified build arguments from `.env`:

```sh
docker build \
  --target sipp \
  --build-arg DEBIAN_VERSION=trixie \
  --build-arg SIPP_VERSION=v3.7.7 \
  --build-arg BUILD_FLAGS=SSL,PCAP,GSL \
  --build-arg SIPP_SCENARIOS_LOCATION=/opt \
  -t sipp:latest .
```

#### Run Image

Run a container using the built image with version check:

```sh
docker run --rm sipp:latest sipp -v
```

Run a container with mounted scenarios and audios volumes:

```sh
docker run --rm \
  --env-file .env \
  -v "$PWD/sipp-scenarios/:/opt" \
  -v "$PWD/audios/:/opt/audios" \
  sipp:latest sipp -v
```

Run a SIPp scenario from the mounted volumes:

```sh
docker run --rm \
  --env-file .env \
  -v "$PWD/sipp-scenarios/:/opt" \
  -v "$PWD/audios/:/opt/audios" \
  sipp:latest sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/register/register.xml -inf /opt/register/register.csv
```

Run the same scenario with a **custom CSV file** by mounting it as an extra volume (e.g. `./my-register.csv` in the current directory):

```sh
docker run --rm \
  --env-file .env \
  -v "$PWD/sipp-scenarios/:/opt" \
  -v "$PWD/audios/:/opt/audios" \
  -v "$PWD/my-register.csv:/opt/register/my-register.csv" \
  sipp:latest sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/register/register.xml -inf /opt/register/my-register.csv
```

Run a container in interactive shell mode:

```sh
docker run --rm -it \
  --env-file .env \
  -v "$PWD/sipp-scenarios/:/opt" \
  -v "$PWD/audios/:/opt/audios" \
  sipp:latest shell
```

### Docker-Compose

#### Build image

```sh
docker compose build sipp
```

#### Run Container

##### Without arguments (for checking only if SIPp is available - outputs version info)

```sh
docker compose up sipp
```

##### Execute SIPp scenario - from local terminal

```sh
docker compose run sipp sipp -i 172.25.0.10 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/options/options.xml
docker compose run sipp sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/register/register.xml -inf /opt/register/register.csv
docker compose run sipp sipp -i 172.25.0.10 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uac/uac.xml -inf /opt/uac/uac.csv -nd
docker compose run sipp sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uas/uas.xml -inf /opt/uas/uas.csv -nd
```

##### Execute SIPp scenario - inside container

```sh
docker compose run sipp shell
cd /opt ## sipp-scenarios folder volume target
sipp -i 10.0.0.1 -p 5060 10.0.0.2:5060 -r 1 -m 1 -sf options/options.xml
```

## Reject Scenario

```sh
docker compose run sipp sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uac/uac_receives_reject.xml -inf /opt/uac/uac_from_internal.csv

docker compose run sipp sipp -i 172.25.0.10 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uas/uas_rejects.xml -inf /opt/uas/uas.csv -nd -trace_screen -trace_msg  -message_file messages.log
```

## UAS sends BYE Scenario

```sh
docker compose run sipp sipp -i 172.25.0.10 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uas/uas_sent_bye.xml -inf /opt/uas/uas.csv -nd -trace_screen -trace_msg  -message_file messages.log

docker compose run sipp sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uac/uac_receives_bye.xml -inf /opt/uac/uac_from_internal.csv
```

## UAS forces Hold Scenario

```sh
docker compose run sipp sipp -i 172.25.0.10 -p 5060 172.25.0.12:5060 -r 1 -m 1 -sf /opt/uas/uas_hold_unhold.xml -inf /opt/uas/uas.csv -nd

docker compose run sipp sipp -i 172.25.0.12 -p 5060 172.25.0.10:5060 -r 1 -m 1 -sf /opt/uac/uac_receives_hold_unhold.xml -inf /opt/uac/uac_from_internal.csv -nd
```

## UAC Re-Invites

```sh
docker compose run sipp sipp -i 172.25.0.10 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uas/uas_receives_reinvite.xml -inf /opt/uas/uas.csv -nd -trace_screen -trace_msg  -message_file messages.log

docker compose run sipp sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uac/uac_reinvite.xml -inf /opt/uac/uac_from_internal.csv
```

## UAC as internal

```sh
docker compose run sipp sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uac/uac.xml -inf /opt/uac/uac_from_internal.csv -nd

docker compose run sipp sipp -i 172.25.0.10 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uas/uas.xml -inf /opt/uas/uas.csv -nd
```

## UAC as internal with audio on both sides

```sh
docker compose run sipp sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uac/uac_with_audio.xml -inf /opt/uac/uac_from_internal.csv -nd

docker compose run sipp sipp -i 172.25.0.10 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uas/uas_with_audio.xml -inf /opt/uas/uas.csv -nd
```

## UAC as provider

```sh
docker compose run sipp sipp -i 172.25.0.10 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uac/uac.xml -inf /opt/uac/uac_from_provider.csv -nd

docker compose run sipp sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uas/uas.xml -inf /opt/uas/uas.csv -nd
```
