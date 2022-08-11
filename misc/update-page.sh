#!/usr/bin/env bash

WILL_UPDATE_COUNT=$(cat update-info-list.json | jq 'length')

for (( i=0; i<$WILL_UPDATE_COUNT; i++ ))
do  
  cat update-info-list.json | jq --arg UPDATED_COUNT $i '.[($UPDATED_COUNT|tonumber)]' >update.json;

  sleep 2;

  content_id=$(cat page-detail-descendant.json | jq -r --arg UPDATED_COUNT $i '.[($UPDATED_COUNT|tonumber)].id');

  curl --request PUT \
    --url "https://api.atlassian.com/ex/confluence/hogehoge/wiki/rest/api/content/${content_id}" \
    --header "Authorization: Bearer $ACCESS_TOKEN"  \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --data '@update.json' 1>/dev/null;

  sleep 5;
done