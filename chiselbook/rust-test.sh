#!/bin/bash

CONTAINER=$1

cd rust-test
cargo build --release
cd ../

docker start ${CONTAINER}
docker exec ${CONTAINER} riscv64-unknown-elf-objcopy -O binary target/myriscv32i-unknown-none-elf/release/rust-test.elf src/hex/rust-test.bin
docker exec ${CONTAINER} od -An -tx1 -w1 -v src/hex/rust-test.bin > src/hex/rust-test.hex                                                                    

sbt "testOnly riscv.RustSrcTest"
