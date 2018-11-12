#!/usr/bin/env bash

# Define variables
BROKER_ID="b-cb7277de-8f18-482b-80c9-0c07a02333fd"
BROKER_HOST="b-cb7277de-8f18-482b-80c9-0c07a02333fd-1.mq.eu-central-1.amazonaws.com"
BROKER_PORT=61617
REBOOT_INTERVAL=5 # Such small interval is used because AWS reports running state after ~ 1 minute after broker is ready
WAIT_INTERVAL=5

# Reboot broker
while :; do
  # Verify if broker port is open
  nc -z -w2 "$BROKER_HOST" "$BROKER_PORT"
  if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d - %H-%M-%S') -  Broker port is open"
  fi
  # Verify if broker is in running state and if yes reboot it
  aws mq describe-broker --broker-id "$BROKER_ID" | grep "BrokerState" | grep "RUNNING" >/dev/nul
  if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d - %H-%M-%S') - Broker is running, wait an interval and reboot it..."
    sleep "$REBOOT_INTERVAL"
    aws mq reboot-broker --broker-id $BROKER_ID
    echo "$(date '+%Y-%m-%d - %H-%M-%S') - Broker rebooted..."
  else
    echo "$(date '+%Y-%m-%d - %H-%M-%S') - Waiting broker to boot..."
    sleep "$WAIT_INTERVAL"
  fi
done

