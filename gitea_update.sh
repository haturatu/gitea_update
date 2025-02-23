#!/bin/bash

# give me root

cat ./cmds | xargs -I {} bash -c 'which {} >/dev/null 2>&1  || echo "Please install: {} "'

GITEA_PATH=$(which gitea)
BINARY_URL=$(curl https://api.github.com/repos/go-gitea/gitea/releases/latest |\
  jq -r '.assets[] |
  select(.browser_download_url | match("linux-amd64$")) |
  .browser_download_url ')

NOW_GITEA_V=$(gitea -v | awk '{printf $3}')
DAEMON_RESTART="service gitea restart"

if ! echo $BINARY_URL | grep -qi $NOW_GITEA_V ; then
  wget -q -O gitea $BINARY_URL || exit 1
  chmod +x gitea
  mv gitea $GITEA_PATH || exit 2
  $DAEMON_RESTART 
else
  exit 0
fi
