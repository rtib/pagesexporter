#!/bin/bash

curl -i \
  -X POST \
  -H 'X-GitHub-Event: push' \
  -H 'X-GitHub-Delivery: 1234asdf' \
  -H 'Content-Type: application/json' \
  -d @github_push.json \
  http://localhost:4567
