#!/usr/bin/env bash

LIMIT=100

#指定したスペース配下すべての子ページを取得する
rm -f endpoint-list.json

while true; do

  if [[ -f endpoint-list.json ]]; then

    NEXT_ENDPOINT=$(cat endpoint-list.json | jq -r '.nextEndPoint'|tail -n-1)

    if [[ "$NEXT_ENDPOINT" == "null" ]]; then
      break;
    fi

    curl -s \
      --header "Authorization: Bearer $ACCESS_TOKEN"  \
      --header 'Accept: application/json' \
      --request GET \
      "https://api.atlassian.com/ex/confluence/hogehoge/wiki/$NEXT_ENDPOINT" | \
      jq '.|{"start":.start,"limit":.limit,"size":.size, "nextEndPoint":._links.next}' >>endpoint-list.json

  else

    jq -n --arg SPACE_ROOT_PAGE_ID $SPACE_ROOT_PAGE_ID  --arg LIMIT $LIMIT '{"start": null,"limit":null,"size":null,"nextEndPoint":"/rest/api/content/\($SPACE_ROOT_PAGE_ID)/child/page?next=true&limit=\($LIMIT)&start=0&expand=page,version,ancestors,body"}' >>endpoint-list.json

    curl -s \
      --header "Authorization: Bearer $ACCESS_TOKEN"  \
      --header 'Accept: application/json' \
      --request GET \
      "https://api.atlassian.com/ex/confluence/hogehoge/wiki/rest/api/content/$SPACE_ROOT_PAGE_ID/descendant/page?next=true&limit=$LIMIT&start=0&expand=page,version,ancestors,body" | \
      jq '.|{"start":.start,"limit":.limit,"size":.size,"nextEndPoint":._links.next}' >>endpoint-list.json

  fi

  sleep 5;

done