#!/bin/bash

set -e

OPT="${SIPP_SCENARIOS_LOCATION:-/opt}"
PORT="${SIPP_PORT:-5060}"
V=" -r 1 -m 1"

# sipp -h to see the exit codes
run_sipp_ok() {
  local code=0
  "$@" || code=$?
  case " 0 99 " in
    *" $code "*) return 0 ;;
    *) echo "SIPp exited with code $code (expected 0 or 99)"; return $code ;;
  esac
}

run_uas_background() {
  local ip="$1"
  shift
  docker run -d --rm --name sipp-uas --network common-network --ip "$ip" \
    -v "$PWD/sipp-scenarios/:$OPT" \
    -v "$PWD/audios/:$OPT/audios" \
    sipp:latest sipp -i "$ip" -p "$PORT" "$@"
}

run_uac() {
  local ip="$1"
  shift
  run_sipp_ok docker run --rm --network common-network --ip "$ip" \
    -v "$PWD/sipp-scenarios/:$OPT" \
    -v "$PWD/audios/:$OPT/audios" \
    sipp:latest sipp -i "$ip" -p "$PORT" "$@"
}

wait_uat() {
  sleep 2
}

stop_uas() {
  docker stop sipp-uas 2>/dev/null || true
}

# OPTIONS scenario
echo "=== Scenario: OPTIONS ==="
run_uas_background 172.25.0.12 $V -sf "$OPT/options/receiver_options.xml" $V -nd
wait_uat
run_uac 172.25.0.10 172.25.0.12:$PORT $V -sf "$OPT/options/options.xml"
stop_uas

# REGISTER scenario
echo "=== Scenario: REGISTER ==="
run_uas_background 172.25.0.12 $V -sf "$OPT/register/receives_register.xml" -inf "$OPT/register/register.csv" -infindex register.csv 0 -nd
wait_uat
run_uac 172.25.0.10 172.25.0.12:$PORT $V -sf "$OPT/register/register.xml" -inf "$OPT/register/register.csv" -nd
stop_uas

# UAC as internal
echo "=== Scenario: UAC as internal ==="
run_uas_background 172.25.0.12 $V -sf "$OPT/uas/uas.xml" -inf "$OPT/uas/uas.csv" $V -nd
wait_uat
run_uac 172.25.0.10 172.25.0.12:$PORT $V -sf "$OPT/uac/uac.xml" -inf "$OPT/uac/uac_from_internal.csv" -nd
stop_uas

# Reject Scenario
echo "=== Scenario: Reject ==="
run_uas_background 172.25.0.12 $V -sf "$OPT/uas/uas_rejects.xml" -inf "$OPT/uas/uas.csv" $V -nd
wait_uat
run_uac 172.25.0.10 172.25.0.12:$PORT $V -sf "$OPT/uac/uac_receives_reject.xml" -inf "$OPT/uac/uac_from_internal.csv"
stop_uas

# UAS sends BYE
echo "=== Scenario: UAS sends BYE ==="
run_uas_background 172.25.0.12 $V -sf "$OPT/uas/uas_sent_bye.xml" -inf "$OPT/uas/uas.csv" $V -nd
wait_uat
run_uac 172.25.0.10 172.25.0.12:$PORT $V -sf "$OPT/uac/uac_receives_bye.xml" -inf "$OPT/uac/uac_from_internal.csv"
stop_uas

# UAC cancels
echo "=== Scenario: UAC cancels ==="
run_uas_background 172.25.0.12 $V -sf "$OPT/uas/uas_receives_cancel.xml" -inf "$OPT/uas/uas.csv" $V -nd
wait_uat
run_uac 172.25.0.10 172.25.0.12:$PORT $V -sf "$OPT/uac/uac_cancels.xml" -inf "$OPT/uac/uac_from_internal.csv"
stop_uas

# UAC Re-Invites
echo "=== Scenario: UAC Re-Invites ==="
run_uas_background 172.25.0.12 $V -sf "$OPT/uas/uas_receives_reinvite.xml" -inf "$OPT/uas/uas.csv" $V -nd
wait_uat
run_uac 172.25.0.10 172.25.0.12:$PORT $V -sf "$OPT/uac/uac_reinvite.xml" -inf "$OPT/uac/uac_from_internal.csv"
stop_uas

# UAS Hold/Un-Hold Scenario
echo "=== Scenario: UAS Hold/UnHold Scenario ==="
run_uas_background 172.25.0.12 $V -sf "$OPT/uas/uas_hold_unhold.xml" -inf "$OPT/uas/uas.csv" $V -nd
wait_uat
run_uac 172.25.0.10 172.25.0.12:$PORT $V -sf "$OPT/uac/uac_receives_hold_unhold.xml" -inf "$OPT/uac/uac_from_internal.csv"
stop_uas

# UAC as internal with audio
echo "=== Scenario: UAC as internal with audio ==="
run_uas_background 172.25.0.12 $V -sf "$OPT/uas/uas_with_audio.xml" -inf "$OPT/uas/uas.csv" $V -nd
wait_uat
run_uac 172.25.0.10 172.25.0.12:$PORT $V -sf "$OPT/uac/uac_with_audio.xml" -inf "$OPT/uac/uac_from_internal.csv" -nd
stop_uas

# UAC as provider
echo "=== Scenario: UAC as provider ==="
run_uas_background 172.25.0.12 $V -sf "$OPT/uas/uas.xml" -inf "$OPT/uas/uas.csv" $V -nd
wait_uat
run_uac 172.25.0.10 172.25.0.12:$PORT $V -sf "$OPT/uac/uac.xml" -inf "$OPT/uac/uac_from_provider.csv" -nd
stop_uas

echo "=== All scenario tests completed ==="
