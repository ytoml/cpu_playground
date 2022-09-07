package riscv

import java.nio.file.Paths

import chisel3._
import chisel3.util._

import common.Consts.{ADDR_LEN, WORD_LEN}


class Top(val hexfile: String, val term: Int, val terminator: TestTerminator) extends Module {
    val f = Paths.get(hexfile)
    val testname = f.getFileName().toString().replaceAll(".hex", "")

    val core = Module(new Core(term.U(WORD_LEN.W), terminator))
    val memory = Module(new Memory(hexfile))
    core.io.imem <> memory.io.imem
    core.io.dmem <> memory.io.dmem

    val testio = IO(new Bundle {
        val exit = Output(Bool())
        val gp   = Output(UInt(WORD_LEN.W))
    })
    testio.exit := core.io.exit
    testio.gp   := core.io.gp
}
