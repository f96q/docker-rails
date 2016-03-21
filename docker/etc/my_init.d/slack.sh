#!/bin/sh

if [ -n "$DEPLOY_SLACK_WEBHOOK_URL" ]; then
  curl -d "payload={\"username\":\"deploy\",\"text\":\"$DEPLOY_SLACK_MESSAGE\"}" $DEPLOY_SLACK_WEBHOOK_URL
fi
