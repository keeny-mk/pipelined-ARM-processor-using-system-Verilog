module add #(parameter WIDTH=8) 
 (input logic [WIDTH-1:0] x, y, 
 output logic [WIDTH-1:0] z); 
 
 assign z = x + y; 
endmodule
