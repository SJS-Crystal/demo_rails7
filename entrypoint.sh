#!/bin/bash
set -e

if [ "$RUN_SETUP" = true ]; then
  bash /home/project/setup_deploy.sh
  echo '' > /home/project/setup_deploy.sh # run only one time, after deploying
fi

if [ "$RAILS_ENV" = "production" ] || [ "$RAILS_ENV" = "staging" ]; then
  rails assets:precompile
fi

exec $@
