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


module REG_FILE(
    input WR,CLK,
    input [4:0] ADRX,
    input [4:0] ADRY,
    input [7:0] DIN,
    output logic [7:0] DX_OUT,
    output logic [7:0] DY_OUT
    );
    
    
    logic [7:0] ram [0:31];
    
    initial
    begin
      int i;
      for (i=0; i<32; i++) begin
        ram[i] = 0;
      end
    end
    
      always_comb
    begin
        DX_OUT = ram[ADRX];
        DY_OUT = ram[ADRY];
    end
    
    always_ff @(posedge CLK)
    begin
        if (WR == 1)begin
            ram[ADRX] <= DIN;
        end
    end
endmodule
