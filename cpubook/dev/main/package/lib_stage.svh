`ifndef	LIB_STAGE_SVH
`define	LIB_STAGE_SVH
`include "main/package/lib_cpu.svh"
package	lib_operation;
	typedef enum logic[1:0] {
		FETCH, DECODE, EXECUTE, MEMSTORE
	} STAGE;

	function automatic STAGE next_stage(STAGE stage);
		unique case(stage)
			FETCH:		next_stage = DECODE;
			DECODE:		next_stage = EXECUTE;
			EXECUTE:	next_stage = MEMSTORE;
			MEMSTORE:	next_stage = FETCH;
			default: ;
		endcase
	endfunction
	
endpackage
`endif // LIB_STAGE_SVH