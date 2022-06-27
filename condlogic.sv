module condlogic(input logic [3:0] Cond, 
 input logic [3:0] Flags, 
 input logic [3:0] ALUFlags, 
 input logic [1:0] FlagsW, 
 output logic CondEx, 
 output logic [3:0] FlagsNext); 
 
 logic n, z, c, ov, ge; 
 
 assign {n, z, c, ov} = Flags; 
 assign ge = (n == ov); 
 
 always_comb 
 case(Cond) 
 4'b0000: CondEx = z; // EQ 
 4'b0001: CondEx = ~z; // NE 
 4'b0010: CondEx = c; // CS 
 4'b0011: CondEx = ~c; // CC 
 4'b0100: CondEx = n; // MI 
 4'b0101: CondEx = ~n; // PL 
 4'b0110: CondEx = ov; // VS 
 4'b0111: CondEx = ~ov; // VC 
 4'b1000: CondEx = c & ~z; // HI 
 4'b1001: CondEx = ~(c & ~z); // LS 
 4'b1010: CondEx = ge; // GE 
 4'b1011: CondEx = ~ge; // LT 
 4'b1100: CondEx = ~z & ge; // GT 
 4'b1101: CondEx = ~(~z & ge); // LE 
 4'b1110: CondEx = 1'b1;//no cond
 default: CondEx = 1'bx; // undef
 endcase 
 
 assign FlagsNext[3:2] = (FlagsW[1] & CondEx) ? ALUFlags[3:2] : 
Flags[3:2]; 
 assign FlagsNext[1:0] = (FlagsW[0] & CondEx) ? ALUFlags[1:0] : 
Flags[1:0]; 
endmodule
