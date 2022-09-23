package riscv

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import java.io.{File, FileNotFoundException}
import org.scalatest.Exceptional

import common.Consts.WORD_LEN

class HexTest extends AnyFlatSpec with ChiselScalatestTester {
  val configs = Iterator(
    ("fetch", 0x34333231), // includes decode test
    ("lw", 0x14131211),
    ("sw", 0x00602823)
  )

  configs.foreach {
    case (name, term_addr) => {
      "mycpu:" + name should "work through hex" in {
        RunInfo(name)
        test(new Top(s"src/hex/$name.hex", term_addr.U(WORD_LEN.W), TestTerminator.Instruction)) { c =>
          while (!c.testio.exit.peek().litToBoolean) {
            c.clock.step(1)
          }
          c.clock.step(1) // make sure to print last status
        }
      }
    }
  }
}
