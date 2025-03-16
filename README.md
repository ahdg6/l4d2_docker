战役整合包 Docker 一键开启，支持插件管理，地图管理，按照已经装的文件嵌套丢进去就行，go 会处理一切软链接。
特别适合和朋友临时开三方图来玩，默认 96 tick，不建议改 100 tick，96 tick 不会出 bug。

开服只需要
``` bash
docker compose up -d
```

开启后不会选图启动，此时进不了服务器，可以进入控制台输入 map
``` bash
docker attach l4d2server
map c1m2_streets
```

插件和地图的读取最多读到第二层文件夹，如果需要临时关闭某个插件可以
``` bash
cd plugins
mkdir disabled
mv 插件文件夹 disabled
```
