`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ethan Ahlquist
// Create Date: 01/17/2019 01:09:16 PM
// Module Name: RAT_MCU
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////

module RAT_MCU(

//////////////////////////////
//SYSTEM OUTPUT/INPUT
input [7:0] IN_PORT,
input CLK,
input INTR,
input RESET,
output [7:0]PORT_ID,
output [7:0]OUT_PORT,
output IO_STRB
//////////////////////////////
    );
    
    logic [9:0] PCtoROM; // OUT from PC      // PC -> P_ROM // PC_COUNT_wire
    
    logic [7:0] REG_MUX_OUT;    // From Mux to REG
    logic [7:0] ALU_MUX_OUT;    // From Mux to ALU
    logic [9:0] SCR_MUX_2_OUT;  // From Mux to SCR
    logic [9:0] SCR_MUX_4_OUT;  // From Mux to SCR
    
    logic [17:0]IR;     // OUT from PROG_ROM
    
    logic [7:0] DX;     // OUT from REG_FILE
    logic [7:0] DY;     // OUT from REG_FILE
    
    logic [7:0] StackPointer;    //OUT from STACK_POINTER
    logic [9:0] FROM_STACK;  //OUT from ScratchRAM
    
    /////////////////////////////////////////////////////////////////
    //Temperary inputs
    
    /////////////////////////////////////////////////////////////////
    
    logic C_FLAG;   // OUT from FLAGS
    logic Z_FLAG;   // OUT from FLAGS

    logic C_IN;        // OUT from ALU
    logic Z_IN;        // OUT from ALU
    logic [7:0] RESULT; // OUT from ALU
    
    logic I_SET;
    logic I_CLR;
    logic I_OUT;
    logic I_ACTUAL;
    
///////////////////////////////////
//TAGGED
    logic RF_WR;            // OUT from Control Unit
    logic RST;              // OUT from Control Unit
    logic PC_LD;            // OUT from Control Unit
    logic PC_INC;           // OUT from Control Unit
    logic [1:0] PC_MUX_SEL; // OUT from Control Unit
    logic [3:0] ALU_SEL;    // OUT from Control Unit
    logic [1:0]RF_WR_SEL;   // OUT from Control Unit
    logic ALU_OPY_SEL;      // OUT from Control Unit
    logic SCR_WE;           // OUT from Control Unit
    logic S_IO_STRB;        // OUT from Control Unit
    
    logic FLG_C_CLR, FLG_C_LD, FLG_Z_LD, FLG_LD_SEL, FLG_SHAD_LD, FLG_C_SET;
    logic SP_LD, SP_INCR, SP_DECR, SCR_DATA_SEL;
    logic [1:0] SCR_ADDR_SEL;
    //logic I_SET, I_CLR, PC_LD, PC_INC, ALU_OPY_SEL, RF_WR, SP_LD, SP_INCR, SP_DECR, SCR_WE, SCR_DATA_SEL, FLG_C_SET,
    //                 FLG_C_CLR, FLG_C_LD, FLG_Z_LD, FLG_LD_SEL, FLG_SHAD_LD, RST;
///////////////////////////////////    


    assign PORT_ID = IR[7:0];
    assign OUT_PORT = DX;
    assign IO_STRB = S_IO_STRB;
    
    
    PC_AND_PCMUX PC(.RST(RST), .PC_LD(PC_LD), .PC_INC(PC_INC), .CLK(CLK), .FROM_IMMED(IR[12:3]), 
                    .FROM_STACK(FROM_STACK), .PC_MUX_SEL(PC_MUX_SEL), .PC_COUNT(PCtoROM));
                    
    ProgROM ProgROM(.PROG_ADDR(PCtoROM), .PROG_IR(IR), .PROG_CLK(CLK));
    
    REG_MUX REG_MUX(.MUX_OUT(REG_MUX_OUT), .MUX_SEL(RF_WR_SEL), .IN_0(RESULT), .IN_1(FROM_STACK), 
                    .IN_2(StackPointer), .IN_3(IN_PORT));    
                    
    REG_FILE REG_FILE(.WR(RF_WR), .DIN(REG_MUX_OUT), .ADRX(IR[12:8]), .ADRY(IR[7:3]), .DX_OUT(DX), 
                    .DY_OUT(DY), .CLK(CLK));
                    
    ALU_MUX ALU_MUX(.MUX_OUT(ALU_MUX_OUT), .MUX_SEL(ALU_OPY_SEL), .IN_0(DY), .IN_1(IR[7:0]));       
                 
    ALU ALU(.SEL(ALU_SEL), .A(DX), .B(ALU_MUX_OUT), .CIN(C_FLAG), .RESULT(RESULT), .C(C_IN), .Z(Z_IN));
                    
    CONTROL_UNIT CU(.C(C_FLAG), .Z(Z_FLAG), .INTR(I_ACTUAL), .RESET(RESET), .CLK(CLK), .OPCODE_HI_5(IR[17:13]), .OPCODE_LO_2(IR[1:0]),         
                    .I_SET(I_SET), .I_CLR(I_CLR), .PC_LD(PC_LD), .PC_INC(PC_INC), .ALU_OPY_SEL(ALU_OPY_SEL), .RF_WR(RF_WR), .SP_LD(SP_LD), .SP_INCR(SP_INCR), .SP_DECR(SP_DECR), .SCR_WE(SCR_WE), .SCR_DATA_SEL(SCR_DATA_SEL),
                    .FLG_C_SET(FLG_C_SET), .FLG_C_CLR(FLG_C_CLR), .FLG_C_LD(FLG_C_LD), .FLG_Z_LD(FLG_Z_LD), .FLG_LD_SEL(FLG_LD_SEL), .FLG_SHAD_LD(FLG_SHAD_LD), .RST(RST), .IO_STRB(S_IO_STRB), 
                    .PC_MUX_SEL(PC_MUX_SEL), .RF_WR_SEL(RF_WR_SEL), .SCR_ADDR_SEL(SCR_ADDR_SEL),
                    .ALU_SEL(ALU_SEL));
                    
    FLAGS FLAGS(.Z_FLAG(Z_FLAG), .C_FLAG(C_FLAG), .Z_IN(Z_IN), .C_IN(C_IN), .FLG_C_SET(FLG_C_SET), .FLG_C_CLR(FLG_C_CLR), .FLG_C_LD(FLG_C_LD), .FLG_Z_LD(FLG_Z_LD), .FLG_LD_SEL(FLG_LD_SEL), .FLG_SHAD_LD(FLG_SHAD_LD), .CLK(CLK));
    
    STACK_POINTER SP(.RST(RST), .LD(SP_LD), .INCR(SP_INCR), .DECR(SP_DECR), .CLK(CLK), .DATA_IN(DX), .DATA_OUT(StackPointer));
    
    SCR_MUX_2 SCR_MUX_2(.MUX_OUT(SCR_MUX_2_OUT), .MUX_SEL(SCR_DATA_SEL), .IN_0(DX), .IN_1(PCtoROM));
    SCR_MUX_4 SCR_MUX_4(.MUX_OUT(SCR_MUX_4_OUT), .MUX_SEL(SCR_ADDR_SEL), .IN_0(DY), .IN_1(IR[7:0]), .IN_2(StackPointer), .IN_3(StackPointer -1));
    
    scratchRAM SCR(.DATA_IN(SCR_MUX_2_OUT), .WE(SCR_WE), .ADDR(SCR_MUX_4_OUT), .CLK(CLK), .DATA_OUT(FROM_STACK));
    
    I_FLAG I_FLAG(.I_SET(I_SET), .I_CLR(I_CLR), .CLK(CLK), .I_OUT(I_OUT));
    
    //AND-GATE
    always_comb begin
        I_ACTUAL = (I_OUT && INTR);
    end
    
endmodule
