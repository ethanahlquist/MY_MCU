`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// Create Date: 02/28/2019 02:24:18 PM
// Module Name: KEYPAD_DRIVER
//////////////////////////////////////////////////////////////////////////////////


module KEYPAD_DRIVER(
    input CLK,
    input [2:0] columns,    //input C, A, E, //Columns
    input [3:0] rows,       //input B, G, F, D, //rows
    output DATA[7:0],
    output INTR
    );
    
    logic [1:0] FSM_counter;
    logic [7:0] counter;
    logic RowCycleCLK;
    
    always_ff @ (posedge CLK) begin
        
        if(counter == 255) begin
            FSM_counter <= FSM_counter +1;
            if(FSM_counter == 3) begin
                FSM_counter = 0;
            end
        end
        counter <= counter + 1;
        
        
    end
    
    
endmodule
