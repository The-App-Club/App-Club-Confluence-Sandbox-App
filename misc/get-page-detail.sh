#!/usr/bin/env bash

SPACE_BASE_URL="https://hogehoge.atlassian.net/wiki"

rm -f page-detail.json

cat endpoint-list.json | jq -sr 'map(.nextEndPoint)|map(select(.!=null))|join("\n")' | while read endpoint;do

    curl -s \
      --header "Authorization: Bearer $ACCESS_TOKEN"  \
      --header 'Accept: application/json' \
      --request GET \
      "https://api.atlassian.com/ex/confluence/hogehoge$endpoint" | \
      jq --arg SPACE_BASE_URL $SPACE_BASE_URL '.results|map({"id":.id,"type":.type,"title":.title,"url": ($SPACE_BASE_URL + (._links.webui)),"endpoint":._links.self,"type":.type,"status":.status,"version":{"number":.version.number},"ancestors":.ancestors|map({"id":.id}),"body":{}})' >>page-detail.json;

done

cat page-detail.json | jq -s 'flatten' | sponge page-detail.json