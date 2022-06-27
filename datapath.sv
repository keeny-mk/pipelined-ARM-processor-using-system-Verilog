module datapath(input logic clk, reset, 
 input logic [1:0] RegSr_D, Imm_SrD, 
 input logic ALU_SrE, BTaken_E, 
 input logic [2:0] ALUCtrl_E, 
 input logic MemtoRegW, PCSr_W, RegWriteW, 
 output logic [31:0] PCF, 
 input logic [31:0] Inst_F, 
 output logic [31:0] Instr_D, 
 output logic [31:0] ALUO_M, WriteDataM, 
 input logic [31:0] DataR_M, 
 output logic [3:0] ALUFlagsE, 
 // hazard logic 
 output logic Match_1E_M, Match_1E_W, Match_2E_M, 
Match_2E_W, Match_12D_E, 
 input logic [1:0] Forward_AE, Forward_BE, 
 input logic F_stall, D_stall, D_Flush); 
 

 logic [31:0] PCP4_F, PC_next1F, PC_nextF; 
 logic [31:0] extenderImm_D, rd1D, rd2D, PCPlus8D; 
 logic [31:0] rd1E, rd2E, extenderImmE, SrcAE, SrcBE, DataW_E, ALUResultE; 
 logic [31:0] DataR_W, ALUO_W, ResultW; 
 logic [3:0] RA1D, RA2D, RA1E, RA2E, WA3E, WA3M, WA3W; 
 logic Match_1D_E, Match_2D_E; 
 
 // Fetch stage 
 mux2 #(32) pcnextmux(PCP4_F, ResultW, PCSr_W, PC_next1F); 
 mux2 #(32) Br_mux(PC_next1F, ALUResultE, BTaken_E, PC_nextF); 
 floper #(32) PCregister(clk, reset, ~F_stall, PC_nextF, PCF); 
 add #(32) pcadd(PCF, 32'h4, PCP4_F); 
 
 // Decode Stage 
 assign PCPlus8D = PCP4_F; // skip register 
 floperc #(32) inst_reg(clk, reset, ~D_stall, D_Flush, Inst_F, Instr_D); 
 mux2 #(4) ra1mux(Instr_D[19:16], 4'b1111, RegSr_D[0], RA1D); 
 mux2 #(4) ra2mux(Instr_D[3:0], Instr_D[15:12], RegSr_D[1], RA2D); 
 regf rf(clk, RegWriteW, RA1D, RA2D, 
 WA3W, ResultW, PCPlus8D, 
 rd1D, rd2D); 
 extend extender(Instr_D[23:0], Imm_SrD, extenderImm_D); 



//Execute Stage 
 flopr #(32) rd1reg(clk, reset, rd1D, rd1E); 
 flopr #(32) rd2reg(clk, reset, rd2D, rd2E); 
 flopr #(32) immreg(clk, reset, extenderImm_D, extenderImmE);
 flopr #(4) wa3ereg(clk, reset, Instr_D[15:12], WA3E); 
 flopr #(4) ra1reg(clk, reset, RA1D, RA1E); 
 flopr #(4) ra2reg(clk, reset, RA2D, RA2E); 
 mux3 #(32) byp1mux(rd1E, ResultW, ALUO_M, Forward_AE, SrcAE); 
 mux3 #(32) byp2mux(rd2E, ResultW, ALUO_M, Forward_BE, DataW_E); 
 mux2 #(32) sec_src(DataW_E, extenderImmE, ALU_SrE, SrcBE); 
 ALU alu(SrcAE, SrcBE, ALUCtrl_E, ALUResultE, ALUFlagsE); 
 
 // Memory Stage 
 flopr #(32) ALUResult_reg(clk, reset, ALUResultE, ALUO_M); 
 flopr #(32) wdreg(clk, reset, DataW_E, WriteDataM); 
 flopr #(4) wa3mreg(clk, reset, WA3E, WA3M); 
 
 // Writeback Stage 
 flopr #(32) aluoutreg(clk, reset, ALUO_M, ALUO_W); 
 flopr #(32) Readdata_reg(clk, reset, DataR_M, DataR_W); 
 flopr #(4) wa3wreg(clk, reset, WA3M, WA3W); 
 mux2 #(32) resmux(ALUO_W, DataR_W, MemtoRegW, ResultW); 
 
//  hazard comparison 
 iseq #(4) m0(WA3M, RA1E, Match_1E_M); 
 iseq #(4) m1(WA3W, RA1E, Match_1E_W); 
 iseq #(4) m2(WA3M, RA2E, Match_2E_M); 
 iseq #(4) m3(WA3W, RA2E, Match_2E_W); 
 iseq #(4) m4a(WA3E, RA1D, Match_1D_E); 
 iseq #(4) m4b(WA3E, RA2D, Match_2D_E); 
 assign Match_12D_E = Match_1D_E | Match_2D_E; 
 
endmodule