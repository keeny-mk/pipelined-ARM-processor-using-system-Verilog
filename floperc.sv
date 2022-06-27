module floperc #(parameter WIDTH = 8) 
 (input logic clk, r, e, c, 
 input logic [WIDTH-1:0] d, 
 output logic [WIDTH-1:0] q); 
 always_ff @(posedge clk, posedge r) 
 if (r) q <= 0; 
 else if (e) 
 if (c) q <= 0; 
 else q <= d; 
endmodule 
