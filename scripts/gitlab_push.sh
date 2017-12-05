#!/bin/bash

curl -X POST -i -H 'X-Gitlab-Event: Push Hook' -H 'Content-Type: application/json' -d @gitlab_push.json http://localhost:4567
