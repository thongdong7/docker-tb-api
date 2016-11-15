#!/usr/bin/env bash

set -e

#ENV=dev
APP="."
if [ $ENV == 'dev' ]; then
  # Application name
  APP=app

  if [ -e tb-api ]; then
    echo "Install tb-api from source code..."
    ./venv/bin/pip install -e tb-api
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
  ./venv/bin/pip install tb-api --upgrade
fi

if [ "$COMMAND" != "" ]; then
  # Support inject custom command
  echo Run $COMMAND...

  $COMMAND
fi

if [ "$ENV" == "dev" ]; then
  APP=app
fi

echo "Application folder: $APP"

# Run
set +e
while true; do
  echo "Start api..."
  ./venv/bin/api --debug --port 80 ioc -a $APP || { echo API failed; }

  echo "API stop. Will be started again after $SLEEP seconds..."
  sleep $SLEEP
done
