```bash
$ export ACCESS_TOKEN=eyJhbG...

$ export SPACE_ROOT_PAGE_ID=hoge

$ time bash get-endpoint-list.sh

real    0m5.587s
user    0m0.183s
sys     0m0.020s

$ time bash get-page-detail.sh

real    0m0.600s
user    0m0.146s
sys     0m0.041s

$ time bash get-page-detail-descendant.sh

real    0m0.714s
user    0m0.181s
sys     0m0.003s

$ export NEW_TITLE_PREFIX="ABC-"

$ cat page-detail-descendant.json | jq --arg NEW_TITLE_PREFIX $NEW_TITLE_PREFIX 'map({"title": ($NEW_TITLE_PREFIX+.title) ,"version":{"number":(.version.number + 1)},"type":.type ,"status":.status,"ancestors":.ancestors,"body":.body  })'  >update-info-list.json

#更新処理は大量にあるとWEBに反映されるまでの時間がかかるかもしれない（若干怪しい）
$ time bash update-page.sh

real    0m16.902s
user    0m0.360s
sys     0m0.029s


$ cat page-detail-descendant.json | jq 'map({"title": .title ,"version":{"number":(.version.number + 1)},"type":.type ,"status":.status,"an
cestors":.ancestors,"body":.body  })'  >delete-info-list.json

#削除処理は事故に注意！
$ time bash delete-page.sh

real    0m17.729s
user    0m0.265s
sys     0m0.057s
```