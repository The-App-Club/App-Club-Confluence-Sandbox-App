#!/usr/bin/env bash

WILL_DELETE_COUNT=$(cat delete-info-list.json | jq 'length')

for (( i=0; i<$WILL_DELETE_COUNT; i++ ))
do  

  content_id=$(cat page-detail-descendant.json | jq -r --arg DELETED_COUNT $i '.[($DELETED_COUNT|tonumber)].id');

  curl --request DELETE \
    --url "https://api.atlassian.com/ex/confluence/hogehoge/wiki/rest/api/content/${content_id}" \
    --header "Authorization: Bearer $ACCESS_TOKEN"

  sleep 5;
done

#トップページ
curl --request DELETE \
  --url "https://api.atlassian.com/ex/confluence/hogehoge/wiki/rest/api/content/${SPACE_ROOT_PAGE_ID}" \
  --header "Authorization: Bearer $ACCESS_TOKEN"
