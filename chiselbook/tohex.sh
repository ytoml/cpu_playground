#!/bin/bash

PJ="/opt/riscv/workspace"
FILES=${PJ}/riscv-tests/share/riscv-tests/isa/rv32*i-p-*
SAVE_DIR=${PJ}/src/riscv

for f in $FILES
do
    FILE_NAME="${f##*/}"
    if [[ ! $f =~ "dump" ]]; then 
        echo "Convert to .bin: $f"
        riscv64-unknown-elf-objcopy -O binary $f $SAVE_DIR/$FILE_NAME.bin
        od -An -tx1 -w1 -v $SAVE_DIR/$FILE_NAME.bin > $SAVE_DIR/$FILE_NAME.hex   
        rm -f $SAVE_DIR/$FILE_NAME.bin
    fi
done