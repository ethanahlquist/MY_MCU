`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2019 08:51:57 PM
// Design Name: 
// Module Name: DUTY_CALC
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
module DUTY_CALC(
    input  logic      CLK,
    input  logic[7:0] SW,
    output logic      SIGNAL
    );
    
    int maxCount = 256;
    int count = 0;
    always_ff@(posedge CLK)
    begin
        if(count < maxCount)
        begin
            if(count < SW)
            begin
                SIGNAL = 0;
            end
            else
            begin
                SIGNAL = 1;
            end
        
            count = count + 1;
        end
        else
        begin
            count = 0;
        end
    end
endmodule