module regf(input logic clk, 
 input logic we3, 
 input logic [3:0] ra1, ra2, wa3, 
 input logic [31:0] wd3, r15, 
 output logic [31:0] rd1, rd2); 
 logic [31:0] regno[14:0]; 

 always_ff @(negedge clk) 
 if (we3) regno[wa3] <= wd3; 
 assign rd1 = (ra1 == 4'b1111) ? r15 : regno[ra1]; 
 assign rd2 = (ra2 == 4'b1111) ? r15 : regno[ra2]; 

endmodule 