module datamem(input logic clk, we,
input logic [31:0] adr, wd,
output logic [31:0] rd);
logic [31:0] ram[256:0];
initial
$readmemh("mem.dat",ram);
assign rd = ram[adr[12:2]]; // word aligned
always_ff @(posedge clk)
if (we) ram[adr[12:2]] <= wd;
endmodule