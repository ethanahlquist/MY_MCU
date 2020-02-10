`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// Create Date: 02/09/2019 11:55:23 AM
// Module Name: C
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////


module C(
    input LD, IN, CLK, SET, CLR,
    output logic OUT
    );
        
    always_ff @(posedge CLK) begin
        if(LD == 1)begin
            OUT <= IN;
        end
        if(CLR == 1)begin
            OUT = 0;
        end
        else if(SET == 1)begin
            OUT = 1;
        end
        else begin
        
        end
    end      

endmodule
