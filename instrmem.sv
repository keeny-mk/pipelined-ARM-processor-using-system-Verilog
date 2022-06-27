module instrmem(input logic [31:0] adr,
output logic [31:0] rd);
logic [31:0] ram[256:0];  //1 kb mem
initial
$readmemh("mem.dat",ram);
assign rd = ram[adr[12:2]]; // word alligned and 13 bits to address 1 kb memory
endmodule