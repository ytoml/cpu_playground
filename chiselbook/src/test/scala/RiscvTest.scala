package riscv

import chisel3._
import org.scalatest.flatspec.AnyFlatSpec
import chiseltest._
import java.io.{File, FileNotFoundException}
import org.scalatest.Exceptional

// import riscv.SupportedInstructions

class RiscvTest extends AnyFlatSpec with ChiselScalatestTester {
    // (ISA, Supported iter(instructions))
    val configs = Map(
        "ui" -> SupportedInstructions.ui,
        "mi" -> SupportedInstructions.mi,
    )

    configs.foreach {
        case (isa, instructions) => {
            instructions.foreach {
                case (inst) => {
                    s"mycpu:$isa-$inst" should "work through riscv-tests" in {
                        val name = s"rv32$isa-p-$inst"
                        val hexfile = s"src/riscv/$name.hex"
                        RunInfo(name)
                        test(new Top(hexfile, 0x44, TestTerminator.ProgramCounter)) { c =>
                            c.clock.setTimeout(100000)
                            while (!c.testio.exit.peek().litToBoolean) {
                                c.clock.step(1)
                            }
                            c.clock.step(1) // make sure to print last status
                            c.testio.gp.expect(1.U)
                        }
                    }
                }
            }
        }
    }
}