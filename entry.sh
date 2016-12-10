#!/usr/bin/env bash

set -e

#ENV=dev
APP="."
API_PARAMS=""
if [ "$ENV" == 'dev' ]; then
  # Application name
  APP=app
  API_PARAMS="--debug"

  if [ -e tb-api ]; then
    echo "Install tb-api from source code..."
    ./venv/bin/pip install -e tb-api[server]
  fi

  if [ -e setup.py ]; then
    echo "Install main code ..."
    INSTALL_CMD="./venv/bin/pip install -e ."
    if [ "$EXTRAS_REQUIRE" != "" ]; then
      INSTALL_CMD=$INSTALL_CMD[$EXTRAS_REQUIRE]
    fi

    echo $INSTALL_CMD

    $INSTALL_CMD
  fi
fi

if [ "$ENV" != "dev" ]; then
  # Application is in current directory
  APP="."

  echo Install tb-api
  ./venv/bin/pip install tb-api[server] --upgrade
fi

if [ "$COMMAND" != "" ]; then
  # Support inject custom command
  echo Run $COMMAND...

  bash -c "$COMMAND"
fi

if [ "$ENV" == "dev" ]; then
  APP=app
fi

echo "Application folder: $APP"

# Run
set +e
while true; do
  echo "Start api..."
  ./venv/bin/api $API_PARAMS --port 80 ioc -a $APP || { echo API failed; }

  echo "API stop. Will be started again after $SLEEP seconds..."
  sleep $SLEEP
done
