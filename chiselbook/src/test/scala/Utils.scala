package riscv

import scala.io.AnsiColor._

object RunInfo {
    def apply(name: String) = {
        println("="*50)
        println(s"${CYAN}Running $name ...${RESET}")
        println("="*50)
    }
}

object SupportedInstructions {
    val ui = Iterator(
        "sw",
        "lw",
        "add",
        "addi",
        "sub",
        "and",
        "andi",
        "or",
        "ori",
        "xor",
        "xori",
        "sll",
        "srl",
        "sra",
        "slli",
        "srli",
        "srai",
        "slt",
        "sltu",
        "slti",
        "sltiu",
        "beq",
        "bne",
        "blt",
        "bge",
        "bltu",
        "bgeu",
        "jal",
        "jalr",
        "lui",
        "auipc",
    )
    val mi = Iterator(
        "csr", 
        "scall"
    )
}