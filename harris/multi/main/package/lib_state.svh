`ifndef LIB_STATE_SVH
`define LIB_STATE_SVH
package lib_state;
	typedef enum logic[3:0] {
		FETCH, DECODE, 
		INVALID_ST
	} STATE;
endpackage
`endif /* LIB_STATE_SVH */