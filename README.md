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
  - [Reject Scenario](#reject-scenario)
  - [UAS sends BYE Scenario](#uas-sends-bye-scenario)
  - [UAC cancels](#uac-cancels)
  - [UAC Re-Invites](#uac-re-invites)
  - [UAC as internal](#uac-as-internal)
  - [UAC as internal with audio on both sides](#uac-as-internal-with-audio-on-both-sides)
  - [UAC as provider](#uac-as-provider)

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
docker compose run sipp sipp -i 172.25.0.10 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uac/uac.xml -inf /opt/uac/uac.csv -nd
docker compose run sipp sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uas/uas.xml -inf /opt/uas/uas.csv -nd
```

#### Execute SIPp scenario - inside container

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

## UAC cancels

```sh
docker compose run sipp sipp -i 172.25.0.10 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uas/uas_receives_cancel.xml -inf /opt/uas/uas.csv -nd -trace_screen -trace_msg  -message_file messages.log

docker compose run sipp sipp -i 172.25.0.12 -p 5060 172.25.0.3:5060 -r 1 -m 1 -sf /opt/uac/uac_cancels.xml -inf /opt/uac/uac_from_internal.csv
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
