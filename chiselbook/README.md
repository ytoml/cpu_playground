# Chisel Book
以下でテストを実行
- 簡易なテスト(7-9 章)
```shell
sbt "testOnly riscv.HexTest"
```
- riscv-tests
```shell
# riscv-tests がインストール済みのコンテナ上で実行(Dockerfile 参照)
mkdir 
./build-riscv-tests.sh
./tohex.sh
sbt "testOnly riscv.RiscvTest"
```