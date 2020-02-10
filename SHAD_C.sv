`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// Create Date: 02/09/2019 11:55:23 AM
// Module Name: SHAD_C
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////


module SHAD_C(
    input LD, IN, CLK,
    output logic OUT
    );
        
    always_ff @(posedge CLK) begin
        if(LD == 1)begin
            OUT <= IN;
        end
    end
endmodule
