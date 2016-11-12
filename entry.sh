#!/usr/bin/env bash

set -e

#ENV=dev

if [ $ENV == 'dev' ]; then
  if [ -e tb-api ]; then
    echo "Install tb-api from source code..."
    ./venv/bin/pip install -e tb-api
  fi

  echo "Install main code ..."
  INSTALL_CMD="./venv/bin/pip install -e ."
  if [ "$EXTRAS_REQUIRE" != "" ]; then
    INSTALL_CMD=$INSTALL_CMD[$EXTRAS_REQUIRE]
  fi
  
  echo $INSTALL_CMD

  $INSTALL_CMD
fi

# Run
set +e
while true; do
  echo "Start api..."
  ./venv/bin/api --debug --port 80 ioc -a app

  echo "API stop. Will be started again after $SLEEP seconds..."
  sleep $SLEEP
done
