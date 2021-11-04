#!/bin/zsh
alias siv="iverilog -g2012"

siv ./main/*/*.sv* ./main/*/*/*.sv ./test/*.sv
ret=$?
if [ ${ret} -ne 0 ]; then
	echo -e "\e[31m Compile Failed... \e[m"
	exit 1
fi

./a.out

file="test.vcd"
if [ -e ${file} ]; then
	open ${file}
fi