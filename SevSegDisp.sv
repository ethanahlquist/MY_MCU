`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Paul Hummel
//
// Create Date: 06/29/2018 12:58:25 AM
// Design Name: Seven SSEGment Display Driver
// Module Name: SevSSEGDisp
// Target Devices: RAT MCU on Basys3
// Description: 7 SSEGment Display Driver with a 16-bit input and 4 character
//              display. The input is assumed to be unsigned and  can be
//              displayed as hex or decimal. The BCD converts the 16-bit
//              input into binary coded decimal of 4 digits, giving a
//              maximum value of 9999. This is below the maximum value of a
//              16-bit input (65,535).
//
//              7 SSEGment configuration for SSEG and DISP_EN
//              SSEG = {dp,a,b,c,d,e,f,g}
//              DISP_EN = {d4, d3, d2, d1}
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module SevSegDisp(
    input CLK,              // 100 MHz clock
    input MODE,             // 0 - display hex, 1 - display decimal
    input [15:0] ALU_VAL,
    output [7:0] SSEG,
    output [3:0] SSEG_EN
    );

    logic [15:0] BCD_Val;
    logic [15:0] Hex_Val;
    
    BCD BCDMod (.HEX(ALU_VAL), .THOUSANDS(BCD_Val[15:12]),
                .HUNDREDS(BCD_Val[11:8]), .TENS(BCD_Val[7:4]),
                .ONES(BCD_Val[3:0]));
    
    CathodeDriver CathMod (.HEX(Hex_Val), .CLK(CLK), .CATHODES(SSEG),
                            .ANODES(SSEG_EN));
    
    // MUX to switch between HEX and BCD input
    always_comb begin
        if (MODE == 1'b1)
            Hex_Val = BCD_Val;
        else
            Hex_Val = ALU_VAL;
    end
    
    
endmodule
