package riscv

import java.nio.file.Paths

import chisel3._
import chisel3.util._

import common.Consts.{ADDR_LEN, WORD_LEN}

class Top(val hexfile: String, val term_inst: Int) extends Module {
    val f = Paths.get(hexfile)
    val testname = f.getFileName().toString().replaceAll(".hex", "")

    val core = Module(new Core(testname, term_inst.U(WORD_LEN.W)))
    val memory = Module(new Memory(hexfile))
    core.io.imem <> memory.io.imem
    core.io.dmem <> memory.io.dmem

    val testio = IO(new Bundle {
        val exit = Output(Bool())
    })
    testio.exit := core.io.exit
}
