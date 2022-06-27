module top(input logic clk, reset,
output logic [31:0] WriteDataM, DataAdrM,
output logic MemWriteM);

logic [31:0] PCF, InstrF, ReadDataM;
arm arm(clk, reset, PCF, InstrF, MemWriteM, DataAdrM,
WriteDataM, ReadDataM);
instrmem instrmem(PCF, InstrF);
datamem datamem(clk, MemWriteM, DataAdrM, WriteDataM, ReadDataM);
endmodule
