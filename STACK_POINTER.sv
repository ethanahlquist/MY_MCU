`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ethan Ahlquist
// Create Date: 02/21/2019 12:04:25 PM
// Module Name: STACK_POINTER
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////


module STACK_POINTER(
    input [7:0] DATA_IN,
    input RST,
    input LD,
    input INCR,
    input DECR,
    input CLK,
    output logic [8:0] DATA_OUT
    );
    
        always_ff @(posedge CLK)
    begin
        if(RST == 1)
            DATA_OUT <= 8'h00;
        else if(LD == 1)
            DATA_OUT <= DATA_IN;
        else if(INCR == 1)
            DATA_OUT <= DATA_OUT + 1;
        else if(DECR == 1)
            DATA_OUT <= DATA_OUT - 1; 
    end
endmodule
