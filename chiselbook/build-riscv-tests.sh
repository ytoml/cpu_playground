#!/bin/bash
RVTESTS="/opt/riscv/riscv-tests"
PJ="/opt/riscv/workspace"
CYAN="\e[1;36m"
RESET="\e[m"

info() {
  echo -e "${CYAN}${1}${RESET}"
}

# Overwrite start address
cat ${RVTESTS}/env/p/link.ld | sed -e 's/0x80000000/0x00000000/g' > .tmp
cat .tmp > ${RVTESTS}/env/p/link.ld
rm .tmp
info "Start address is configured."

# Configure
cd ${RVTESTS}
autoconf
./configure --prefix=${PJ}/riscv-tests

# Build
info "make"
make
info "make install"
make install