#!/usr/bin/env bash

rm -f dist/traefik || true

make binary

docker build -t hub.linexdev.io/$LINEX_STACK/traefik --pull=true --no-cache .

docker-machine ssh dev-$LINEX_STACK-SwarmManager "docker service rm traefik"

docker push hub.linexdev.io/$LINEX_STACK/traefik

linex --action swarm-traefik