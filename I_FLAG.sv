`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2019 01:36:25 PM
// Design Name: 
// Module Name: I_FLAG
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module I_FLAG(
    input I_SET,
    input CLK,
    input I_CLR,
    output logic I_OUT
    );
    
    always_ff @ (posedge CLK) begin
        if(I_SET == 1)
            I_OUT <= 1;
        else if (I_CLR == 1) 
            I_OUT <= 0;
    end
endmodule
