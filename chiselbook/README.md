# Chisel Book
以下でテストを実行。各 `sbt` コマンドの実行も Docker 内で行うのであれば必要に応じて `docker exec` などをつける。

- 簡易なテスト(7-9 章)
```shell
sbt "testOnly riscv.HexTest"
```
- riscv-tests
```shell
# ${CONTAINER} は riscv-tests がインストール済みのコンテナの名称
docker start ${CONTAINER}
docker exec ${CONTAINER} ./build-riscv-tests.sh
docker exec ${CONTAINER} ./tohex.sh
sbt "testOnly riscv.RiscvTest"
```
- Rust ソースからコンパイルしたプログラムのテスト
```shell
# ${CONTAINER} は riscv-tests がインストール済みのコンテナの名称
docker start ${CONTAINER}
./rust-test.sh ${CONTAINER}
```