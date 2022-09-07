# Rust source for RiscV
`myriscv32i-unknown-none-elf.json` はターゲット情報。ちなみにデフォルトは  
```shell  
rustc +nightly -Z unstable-options --target=riscv32i-unknown-none-elf --print target-spec-json
```  
で確認可能。