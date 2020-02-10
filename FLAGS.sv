`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// Create Date: 02/09/2019 11:55:23 AM
// Module Name: FLAGS
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////

module FLAGS(
    input Z_IN, C_IN, FLG_C_SET, FLG_C_CLR, FLG_C_LD, FLG_Z_LD, FLG_LD_SEL, FLG_SHAD_LD, CLK, 
    output Z_FLAG, C_FLAG
    );
    
    logic Z_MUX;
    logic C_MUX;
    
    logic SHAD_Z_OUT;
    logic SHAD_C_OUT;
    
    Z Z(.LD(FLG_Z_LD), .IN(Z_MUX), .OUT(Z_FLAG), .CLK(CLK));
    
    SHAD_Z SHAD_Z(.LD(FLG_SHAD_LD), .IN(Z_FLAG), .OUT(SHAD_Z_OUT), .CLK(CLK));
    
    C C(.LD(FLG_C_LD), .SET(FLG_C_SET), .CLR(FLG_C_CLR), .IN(C_MUX), .OUT(C_FLAG), .CLK(CLK));
    
    SHAD_C SHAD_C(.LD(FLG_SHAD_LD), .IN(C_FLAG), .OUT(SHAD_C_OUT), .CLK(CLK));
    
    always_comb begin
        if(FLG_LD_SEL == 0) begin
            Z_MUX = Z_IN;
            C_MUX = C_IN; 
        end
        else begin
            Z_MUX = SHAD_Z_OUT;
            C_MUX = SHAD_C_OUT;
        end
    end   
endmodule
