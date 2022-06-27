module iseq #(parameter WIDTH = 8) 
 (input logic [WIDTH-1:0] x, y, 
 output logic z); 
 assign z = (x == y); 
endmodule