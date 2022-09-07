package riscv

import chisel3._
import chisel3.util._
import chisel3.util.Arbiter

import common.Consts._
import common.Instructions._

// To specify what io.exit depends on.
trait TestTerminator
object TestTerminator {
    case object Instruction extends TestTerminator
    case object ProgramCounter extends TestTerminator
}

class Core(val term: UInt, val terminator: TestTerminator) extends Module {
	val io = IO(new Bundle {
		val imem = Flipped(new ImemPortIo())
		val dmem = Flipped(new DmemPortIo())
		val exit = Output(Bool())
        val gp   = Output(UInt(WORD_LEN.W)) // Global pointer (for test)
	})
	val regfile = Mem(32, UInt(WORD_LEN.W))
	val csr_regs = Mem(4096, UInt(WORD_LEN.W))
    io.gp := regfile(3)

    // Fetch
    /* -------------------------------------------------- */
	val pc_reg = RegInit(START_ADDR)
	io.imem.addr := pc_reg
	val inst = io.imem.inst

    /* -------------------------------------------------- */

    // Decode
    /* -------------------------------------------------- */
    val ctrl_sig = ListLookup(
        inst,
        List(ALU_X, OP1_RS1, OP2_RS2, M_EN_X, R_EN_X, WB_X, CSR_X),
        Array(
            // Memory
            LW		-> List(ALU_ADD, OP1_RS1, OP2_IMI, M_EN_X, R_EN_S, WB_MEM, CSR_X),
            SW		-> List(ALU_ADD, OP1_RS1, OP2_IMS, M_EN_S, R_EN_X, WB_X, CSR_X),
            // Arithmetic
            ADD		-> List(ALU_ADD, OP1_RS1, OP2_RS2, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            ADDI	-> List(ALU_ADD, OP1_RS1, OP2_IMI, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            SUB		-> List(ALU_SUB, OP1_RS1, OP2_RS2, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            // Logical
            AND		-> List(ALU_AND, OP1_RS1, OP2_RS2, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            OR		-> List(ALU_OR , OP1_RS1, OP2_RS2, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            XOR		-> List(ALU_XOR, OP1_RS1, OP2_RS2, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            ANDI	-> List(ALU_AND, OP1_RS1, OP2_IMI, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            ORI		-> List(ALU_OR , OP1_RS1, OP2_IMI, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            XORI	-> List(ALU_XOR, OP1_RS1, OP2_IMI, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            // Shift
            SLL		-> List(ALU_SLL, OP1_RS1, OP2_RS2, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            SRL		-> List(ALU_SRL, OP1_RS1, OP2_RS2, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            SRA		-> List(ALU_SRA, OP1_RS1, OP2_RS2, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            SLLI	-> List(ALU_SLL, OP1_RS1, OP2_IMI, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            SRLI	-> List(ALU_SRL, OP1_RS1, OP2_IMI, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            SRAI	-> List(ALU_SRA, OP1_RS1, OP2_IMI, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            // Comparison
            SLT		-> List(ALU_SLT , OP1_RS1, OP2_RS2, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            SLTU	-> List(ALU_SLTU, OP1_RS1, OP2_RS2, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            SLTI	-> List(ALU_SLT , OP1_RS1, OP2_IMI, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            SLTIU	-> List(ALU_SLTU, OP1_RS1, OP2_IMI, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            // Branch
            BEQ		-> List(BR_BEQ,  OP1_RS1, OP2_RS2, M_EN_X, R_EN_X, WB_X, CSR_X),
            BNE		-> List(BR_BNE,  OP1_RS1, OP2_RS2, M_EN_X, R_EN_X, WB_X, CSR_X),
            BLT		-> List(BR_BLT,  OP1_RS1, OP2_RS2, M_EN_X, R_EN_X, WB_X, CSR_X),
            BGE		-> List(BR_BGE,  OP1_RS1, OP2_RS2, M_EN_X, R_EN_X, WB_X, CSR_X),
            BLTU	-> List(BR_BLTU, OP1_RS1, OP2_RS2, M_EN_X, R_EN_X, WB_X, CSR_X),
            BGEU	-> List(BR_BGEU, OP1_RS1, OP2_RS2, M_EN_X, R_EN_X, WB_X, CSR_X),
            // Jump
            JAL		-> List(ALU_ADD,  OP1_PC,  OP2_IMJ, M_EN_X, R_EN_S, WB_PC, CSR_X),
            JALR	-> List(ALU_JALR, OP1_RS1, OP2_IMI, M_EN_X, R_EN_S, WB_PC, CSR_X), // Note that JALR is I Type.
            // Imm Load
            LUI		-> List(ALU_ADD, OP1_X,  OP2_IMU, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            AUIPC	-> List(ALU_ADD, OP1_PC, OP2_IMU, M_EN_X, R_EN_S, WB_ALU, CSR_X),
            // Control and Status Register
            CSRRW	-> List(ALU_COPY1, OP1_RS1, OP2_X, M_EN_X, R_EN_S, WB_CSR, CSR_W),
            CSRRWI	-> List(ALU_COPY1, OP1_IMZ, OP2_X, M_EN_X, R_EN_S, WB_CSR, CSR_W),
            CSRRS	-> List(ALU_COPY1, OP1_RS1, OP2_X, M_EN_X, R_EN_S, WB_CSR, CSR_S),
            CSRRSI	-> List(ALU_COPY1, OP1_IMZ, OP2_X, M_EN_X, R_EN_S, WB_CSR, CSR_S),
            CSRRC	-> List(ALU_COPY1, OP1_RS1, OP2_X, M_EN_X, R_EN_S, WB_CSR, CSR_C),
            CSRRCI	-> List(ALU_COPY1, OP1_IMZ, OP2_X, M_EN_X, R_EN_S, WB_CSR, CSR_C),
            // Exception Call
            ECALL	-> List(ALU_X, OP1_X, OP2_X, M_EN_X, R_EN_X, WB_X, CSR_E),
        )
    )
    val exec_func :: op1_sel :: op2_sel :: mem_en :: reg_en :: wb_sel :: csr_cmd :: Nil = ctrl_sig;
    /* -------------------------------------------------- */

    // Execute
    /* -------------------------------------------------- */
    val rs1_addr    = inst(19, 15)
    val rs2_addr    = inst(24, 20)
    val wb_addr     = inst(11, 7)
    val rs1_data    = Mux(rs1_addr =/= 0.U(WORD_LEN.W), regfile(rs1_addr), 0.U(WORD_LEN.W));
    val rs2_data    = Mux(rs2_addr =/= 0.U(WORD_LEN.W), regfile(rs2_addr), 0.U(WORD_LEN.W));
    val imm_i       = inst(31, 20)
    val imm_i_sext  = Cat(Fill(20, imm_i(11)), imm_i)
    val imm_s       = Cat(inst(31, 25), inst(11, 7))
    val imm_s_sext  = Cat(Fill(20, imm_s(11)), imm_s)
    // Imm for B/J Type is always even because instrcution width is 16 or 32 bits.
    val imm_b       = Cat(inst(31), inst(7), inst(30, 25), inst(11, 8))
    val imm_b_sext  = Cat(Fill(19, imm_b(11)), imm_b, 0.U(1.U)) 
    val imm_j       = Cat(inst(31), inst(19, 12), inst(20), inst(30, 21))
    val imm_j_sext  = Cat(Fill(11, imm_j(19)), imm_j, 0.U)
    val imm_u       = inst(31, 12)
    val imm_u_sft   = Cat(imm_u, Fill(12, 0.U))
    val imm_z       = inst(19, 15)
    val imm_z_uext  = Cat(Fill(27, 0.U), imm_z)
    val op1_data = MuxCase(0.U(WORD_LEN.W), Seq(
        (op1_sel === OP1_RS1) -> rs1_data,
        (op1_sel === OP1_PC)  -> pc_reg,
        (op1_sel === OP1_IMZ) -> imm_z_uext,
    ));
    val op2_data = MuxCase(0.U(WORD_LEN.W), Seq(
        (op2_sel === OP2_RS2) -> rs2_data,
        (op2_sel === OP2_IMI) -> imm_i_sext,
        (op2_sel === OP2_IMS) -> imm_s_sext,
        (op2_sel === OP2_IMJ) -> imm_j_sext,
        (op2_sel === OP2_IMU) -> imm_u_sft,
    ));

    // ALU
    val alu_out = MuxCase(0.U(WORD_LEN.W), Seq(
        (exec_func === ALU_ADD)   -> (op1_data + op2_data),
        (exec_func === ALU_SUB)   -> (op1_data - op2_data),
        (exec_func === ALU_AND)   -> (op1_data & op2_data),
        (exec_func === ALU_OR)    -> (op1_data | op2_data),
        (exec_func === ALU_XOR)   -> (op1_data ^ op2_data),
	    (exec_func === ALU_SLL)   -> (op1_data << op2_data(4, 0))(31, 0),
	    (exec_func === ALU_SRL)   -> (op1_data >> op2_data(4, 0)).asUInt(),
	    (exec_func === ALU_SRA)   -> (op1_data.asSInt() >> op2_data(4, 0)).asUInt(), // Arithmetic(signed) right shift
	    (exec_func === ALU_SLT)   -> (op1_data.asSInt() < op2_data.asSInt()).asUInt(),
	    (exec_func === ALU_SLTU)  -> (op1_data < op2_data).asUInt(),
	    (exec_func === ALU_JALR)  -> ((op1_data + op2_data) & ~1.U(WORD_LEN.W)),
        (exec_func === ALU_COPY1) -> op1_data,
    ));

    // Control Flow
	val pc_plus4 = pc_reg + 4.U(WORD_LEN.W)
    val br_flag = MuxCase(false.B, Seq(
        (exec_func === BR_BEQ)  -> (op1_data === op2_data),
        (exec_func === BR_BNE)  -> !(op1_data === op2_data),
        (exec_func === BR_BLT)  -> (op1_data.asSInt() < op2_data.asSInt()),
        (exec_func === BR_BGE)  -> !(op1_data.asSInt() < op2_data.asSInt()),
        (exec_func === BR_BLTU) -> (op1_data.asUInt() < op2_data.asUInt()),
        (exec_func === BR_BGEU) -> !(op1_data.asUInt() < op2_data.asUInt()),
    ))
    val br_target = pc_reg + imm_b_sext
    val j_flag = (inst === JAL || inst === JALR)
    val pc_next = MuxCase(pc_plus4, Seq(
        br_flag          -> br_target,
        j_flag           -> alu_out,
        (inst === ECALL) -> csr_regs(0x305), // Jump to Trap Vector address
    ))
    pc_reg := pc_next

    // CSR
    val csr_addr = Mux(csr_cmd === CSR_E, 0x342.U(WORD_LEN.W), inst(31, 20))
    val csr_rdata = csr_regs(csr_addr)
    val csr_wdata = MuxCase(0.U(WORD_LEN.W), Seq(
        (csr_cmd === CSR_W) -> op1_data,
        (csr_cmd === CSR_S) -> (csr_rdata | op1_data),
        (csr_cmd === CSR_C) -> (csr_rdata & ~op1_data),
        (csr_cmd === CSR_E) -> 11.U(WORD_LEN.W),  // Machine Mode 
    ))
    /* -------------------------------------------------- */

    // Memory
    /* -------------------------------------------------- */
    io.dmem.addr := alu_out
    io.dmem.w_en := (inst === SW)
    io.dmem.wdata := op2_data
    /* -------------------------------------------------- */

    // WriteBack
    /* -------------------------------------------------- */
    val wb_data = MuxCase(alu_out, Seq(
        (wb_sel === WB_MEM) -> io.dmem.rdata,
        (wb_sel === WB_PC)  -> pc_plus4,
        (wb_sel === WB_CSR) -> csr_rdata,
    )) 
    when(reg_en === R_EN_S) {
        regfile(wb_addr) := wb_data
    }
    when(csr_cmd =/= CSR_X) {
        csr_regs(csr_addr) := csr_wdata
    }
    
    // Debug signals
    /* -------------------------------------------------- */
	printf(p"${"-"*50}\n")
    // val inst_name = InstructionNameLookup(inst, "Invalid")
	printf(p"pc_reg     : 0x${Hexadecimal(pc_reg)}\n")
	printf(p"inst       : 0x${Hexadecimal(inst)}\n")
	// printf(p"inst(name) : $inst_name\n")
	printf(p"rs1_addr   : $rs1_addr\n")
	printf(p"rs2_addr   : $rs2_addr\n")
	printf(p"wb_addr    : $wb_addr\n")
	printf(p"rs1_data   : 0x${Hexadecimal(rs1_data)}\n")
	printf(p"rs2_data   : 0x${Hexadecimal(rs2_data)}\n")
	printf(p"wb_data    : 0x${Hexadecimal(wb_data)}\n")
	printf(p"dmem.addr	: 0x${Hexadecimal(io.dmem.addr)}\n")
	printf(p"dmem.w_en	: 0x${Hexadecimal(io.dmem.w_en)}\n")
	printf(p"dmem.wdata : 0x${Hexadecimal(io.dmem.wdata)}\n")
	printf(p"dmem.rdata : 0x${Hexadecimal(io.dmem.wdata)}\n")
    when(csr_cmd =/= CSR_X) {
	    printf(p"csr_addr   : $csr_addr\n")
	    printf(p"csr_rdata  : 0x${Hexadecimal(csr_rdata)}\n")
	    printf(p"csr_wdata  : 0x${Hexadecimal(csr_wdata)}\n")
    }
	printf(p"br_flag    : 0x${Hexadecimal(io.dmem.wdata)}\n")
	printf(p"j_flag     : 0x${Hexadecimal(io.dmem.wdata)}\n")
	printf(p"gp         : 0x${Hexadecimal(io.gp)}\n")

    import TestTerminator._
    terminator match {
        case Instruction => {
            io.exit := (inst === term) /* hex test */ 
        }
        case ProgramCounter => {
            io.exit := (pc_reg === term) /* hex test */ 
        }
    }
}

