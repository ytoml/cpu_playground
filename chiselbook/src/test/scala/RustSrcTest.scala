package riscv

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._

import common.Consts.WORD_LEN

class RustSrcTest extends AnyFlatSpec with ChiselScalatestTester {
    // Use long not to be taken as negative integer.
    val unimp = 0xc0001073L.U(WORD_LEN.W)

    s"mycpu:rust-test" should "work through riscv-tests" in {
        test(new Top("src/hex/rust-test.hex", unimp, TestTerminator.Instruction)) { c =>
            c.clock.setTimeout(50)
            while (!c.testio.exit.peek().litToBoolean) {
                c.clock.step(1)
            }
            c.clock.step(1) // make sure to print last status
        }
    }
}