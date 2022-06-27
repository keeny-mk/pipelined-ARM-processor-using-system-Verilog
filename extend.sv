module extend(input logic [23:0] i, 
 input logic [1:0] ImmSrc, 
 output logic [31:0] ExtImm); 
 
 always_comb 
 case(ImmSrc) 
 2'b00: ExtImm = {24'b0, i[7:0]}; // 8-bit immediate 
 2'b01: ExtImm = {20'b0, i[11:0]}; // 12-bit immediate 
 2'b10: ExtImm = {{6{i[23]}}, i[23:0], 2'b00}; // Branch 
 default: ExtImm = 32'bx; // undefined 
 endcase 
endmodule