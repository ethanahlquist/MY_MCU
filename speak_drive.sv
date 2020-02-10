`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ethan Ahlquist
// Module Name: speak_drive
//////////////////////////////////////////////////////////////////////////////////

module speak_drive(
    input [7:0] din,
    input CLK,  
    output logic PWM
    );
    
    logic [16:0] t2; // PC -> P_ROM // PC_COUNT_wire
        
    period_eval period_eval(.din(din), .period(t2));
    ClockDivider clock_div(.maxcount(t2), .sclk(PWM), .clk(CLK));

endmodule