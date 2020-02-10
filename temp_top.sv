`timescale 1ns / 1ps

module temp_top(
input [7:0] LED_IN,
input CLK,
output LED_OUT
    );
    
    RGB_LED_PERIFERAL RGB_LED_PERIFERAL(.*);
    
    //RAT_MCU MCU(.*);
    //FLAGS FLAGS(.*);
    //STACK_POINTER SP(.*);
    //RAT_WRAPPER TOP(.*);
    
endmodule
