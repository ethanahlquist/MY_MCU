`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: ETHAN AHLQUIST
// Create Date: 02/21/2019 02:25:39 PM
// Module Name: SCR_MUX_4
//////////////////////////////////////////////////////////////////////////////////

module SCR_MUX_2(

    output logic [9:0] MUX_OUT,
    input MUX_SEL,
    input [7:0] IN_0,
    input [9:0] IN_1
    );
    
    
    always_comb
    begin
        if(MUX_SEL == 0)
            MUX_OUT = {2'h0, IN_0};
        else if(MUX_SEL == 1)
            MUX_OUT = IN_1;
        else
            MUX_OUT = IN_0;
    end
endmodule

