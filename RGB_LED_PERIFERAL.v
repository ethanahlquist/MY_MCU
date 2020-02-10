`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ethan Ahlquist
// Create Date: 03/12/2019 08:45:10 PM
// Module Name: B_PERIFERAL
//////////////////////////////////////////////////////////////////////////////////


module RGB_LED_PERIFERAL(
    
    input [7:0] LED_IN,
    input CLK,
    output LED_OUT
    
    );
    
    DUTY_CALC DUTY_CALC(.CLK(CLK), .SW(LED_IN), .SIGNAL(LED_OUT));
    
    
endmodule
