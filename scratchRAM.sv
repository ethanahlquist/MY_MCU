`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2019 03:15:21 PM
// Design Name: 
// Module Name: scratchRAM
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


module scratchRAM(
    input WE,CLK,
    input [9:0] DATA_IN,
    input [7:0] ADDR,
    output logic [9:0] DATA_OUT
    );
    
    
    logic [10:0] ram [0:255];
    
    initial
    begin
      int i;
      for (i=0; i<256; i++) begin
        ram[i] = 0;
      end
    end
    
    always_comb
    begin
        DATA_OUT = ram[ADDR];
    end
    
    always_ff @(posedge CLK)
    begin
        if (WE == 1)begin
            ram[ADDR] <= DATA_IN;
        end
    end
endmodule
