module floprc #(parameter WIDTH = 8) 
 (input logic clk, r, c, 
 input logic [WIDTH-1:0] d, 
 output logic [WIDTH-1:0] q); 
 always_ff @(posedge clk, posedge r) 
 if (r) q <= 0; 
 else 
 if (c) q <= 0; 
 else q <= d; 
endmodule
