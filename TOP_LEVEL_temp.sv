`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ethan Ahlquist
// Create Date: 01/17/2019 01:09:16 PM
// Module Name: TOP_LEVEL
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////


module TOP_LEVEL(
    
    output [17:0] PROG_IR,
    input RST,
    input PC_LD,
    input PC_INC,
    input CLK,
    input [9:0] FROM_IMMED,
    input [9:0] FROM_STACK,
    input [1:0] PC_MUX_SEL
    );

    logic [9:0] t2; // PC -> P_ROM // PC_COUNT_wire
    
    PC_AND_PCMUX PC(.RST(RST), .PC_LD(PC_LD), .PC_INC(PC_INC), .CLK(CLK), .FROM_IMMED(FROM_IMMED), 
                    .FROM_STACK(FROM_STACK), .PC_MUX_SEL(PC_MUX_SEL), .PC_COUNT(t2));
    ProgROM ProgROM(.PROG_ADDR(t2), .PROG_IR(PROG_IR), .PROG_CLK(CLK));
    
endmodule
