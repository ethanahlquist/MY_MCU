`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: ETHAN AHLQUIST
// Module Name: ALU_MUX
//////////////////////////////////////////////////////////////////////////////////


module ALU_MUX(
output logic [7:0] MUX_OUT,
    input MUX_SEL,
    input [7:0] IN_0,
    input [7:0] IN_1
    );
    
    always_comb
    begin
        if(MUX_SEL == 0)
            MUX_OUT = IN_0;
        else if(MUX_SEL == 1)
            MUX_OUT = IN_1;
        else
            MUX_OUT = IN_0;
    end
endmodule

