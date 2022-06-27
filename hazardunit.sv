module hazardunit(input logic clk, reset, 
 input logic Match_1E_M, Match_1E_W, Match_2E_M, 
Match_2E_W, Match_12D_E, 
 input logic RegWrM, RegWrW, 
 input logic BranchE, MemtoRegE, 
 input logic PCWrF, PCSrcW, 
 output logic [1:0] FwdAE, FwdBE, 
 output logic StallF, StallD, 
 output logic FlushD, FlushE); 
 logic ldrStallD; 

 
 always_comb begin 
 if (Match_1E_M & RegWrM) FwdAE = 2'b10; 
 else if (Match_1E_W & RegWrW) FwdAE = 2'b01; 
 else FwdAE = 2'b00; 
 
 if (Match_2E_M & RegWrM) FwdBE = 2'b10; 
 else if (Match_2E_W & RegWrW) FwdBE = 2'b01; 
 else FwdBE = 2'b00; 
 end 
 
 
 assign ldrStallD = Match_12D_E & MemtoRegE; 
 
 assign StallD = ldrStallD; 
 assign StallF = ldrStallD | PCWrF; 
 assign FlushE = ldrStallD | BranchE; 
 assign FlushD = PCWrF | PCSrcW | BranchE; 
 
endmodule 
