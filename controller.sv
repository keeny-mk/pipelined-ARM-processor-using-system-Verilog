module controller (input logic clk, reset, 
input logic [31:12] InstrD, input logic [3:0] ALUFlagsE,
output logic [1:0] RegSrcD, ImmSrcD, 
output logic ALUSrcE, BranchTakenE, output logic [2:0] ALUControlE,
output logic MemeWriteM, MemtoRegW, PCSrcW, RegWriteW, 
output logic RegWirteM, MemtoRegE, PCWrPendingF, 
input logic FlushE);

logic [9:0] controlsD;
logic CondExE, ALUOpD;
logic [2:0] ALUControlD;
logic ALUSrcD;
logic MemtoRegD, MemtoRegM;
logic RegWriteD, RegWriteE, RegWriteCondE;
logic MemWriteD, MemWriteE, MemWriteCondE;
logic BranchD, BranchE;
logic [1:0] FlagWriteD, FlagWriteE;
logic PCSrcD, PCSrcE, PCSrcM;
logic [3:0] FlagsE, FlagsNextE, CondE;

//Decode
always_comb
	casex(InstrD[27:26])
	  2'b00: if(InstrD[25]) controlsD = 10'b0000101001; // DP imm
		 else 	        controlsD = 10'b0000001001; // DP reg
	  2'b01: if(InstrD[20]) controlsD = 10'b0001111000; // LDR
		 else           controlsD = 10'b1001110100; // STR
	  2'b10: 		controlsD = 10'b0110100010; // B
	  default:		controlsD = 10'bx; 
	endcase
assign {RegSrcD, ImmSrcD, ALUSrcD, MemtoRegD, RegWriteD,
MemWriteD, BranchD, ALUOpD} = controlsD;

always_comb
	if (ALUOpD) begin
	  case (InstrD[24:21])
		4'b0100: ALUControlD = 3'b000; //ADD
		4'b0010: ALUControlD = 3'b001; //SUB
		4'b0000: ALUControlD = 3'b010; //AND
		4'b1100: ALUControlD = 3'b011; //OR
		4'b0001: ALUControlD = 3'b100; //EOR
		4'b1110: ALUControlD = 3'b101; //BIC
		default: ALUControlD = 3'bx;
	  endcase
	  FlagWriteD[1] = InstrD[20]; //N and Z flags
	  FlagWriteD[0] = InstrD[20] & (ALUControlD == 3'b000 | ALUControlD == 3'b001);
	  
	end else begin 
	  ALUControlD = 3'b000; //add for non-DP
	  FlagWriteD = 2'b00;
	end
assign PCSrcD = ((( InstrD [15:12] == 4'b1111) & RegWriteD) );

// Execute  
floprc #(7) regsEflushed(clk, reset, FlushE,
{FlagWriteD, BranchD, MemWriteD, RegWriteD, PCSrcD, MemtoRegD},
{FlagWriteE, BranchE, MemWriteE, RegWriteE, PCSrcE, MemtoRegE});
flopr #(4) regsE(clk, reset,{ALUSrcD, ALUControlD},{ALUSrcE, ALUControlE});
flopr #(4) condregE(clk, reset, InstrD[31:28], CondE);
flopr #(4) flagsreg(clk, reset, FlagsNextE, FlagsE);

condlogic cond(CondE, FlagsE, ALUFlagsE, FlagWriteE, CondExE, FlagsNextE);

assign BranchTakenE = BranchE & CondExE;
assign RegWriteCondE = RegWriteE & CondExE;
assign MemWriteCondE = MemWriteE & CondExE;
assign PCSrcCondE = PCSrcE & CondExE;

//Memory
flopr #(4) regsM(clk, reset,{MemWriteCondE, MemtoRegE, RegWriteCondE,PCSrcCondE},
{MemWriteM, MemtoRegM, RegWriteM, PCSrcM});

//Writeback
flopr #(3) regsW(clk, reset,{MemtoRegM, RegWriteM, PCSrcM},
{MemtoRegW, RegWriteW, PCSrcW});

//Hazard 
assign PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;

endmodule