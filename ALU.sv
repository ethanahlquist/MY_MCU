`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// Create Date: 01/29/2019 02:37:04 PM
// Module Name: ALU
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input  logic[3:0] SEL,
    input  logic[7:0] A,
    input  logic[7:0] B,
    input  logic      CIN,
    output logic[7:0] RESULT,
    output logic      C,
    output logic      Z
    );
    
    logic[8:0] res = 0;
    
    always_comb
    begin
        case(SEL)
            4'b0000 : begin //ADD
                res = {1'b0, A} + {1'b0, B};
                C = res[8];
                RESULT = res[7:0];
                Z = (res == 0)?1:0;
            end
            4'b0001 : begin //ADDC
                res = {1'b0, A} + {1'b0, B} + {7'b0000000, CIN};
                C = res[8];
                RESULT = res[7:0];
                Z = (res == 0)?1:0;
            end
            4'b0010 : begin //SUB
                res = {1'b0, A} - {1'b0, B};
                C = res[8];
                RESULT = res[7:0];
                Z = (res == 0)?1:0;            
            end
            4'b0011 : begin //SUBC
                res = {1'b0, A} - {1'b0, B} - {7'b0000000, CIN};
                C = res[8];
                RESULT = res[7:0];
                Z = (res == 0)?1:0;            
            end
            4'b0100 : begin //CMP
                res = {1'b0, A} - {1'b0, B};
                C = res[8];
                RESULT = res[7:0];
                Z = (res == 0)?1:0;
            end
            4'b0101 : begin //AND
                res = {1'b0, A} & {1'b0, B};
                C = 0;
                RESULT = res[7:0];
                Z = (res == 0)?1:0;
            end
            4'b0110 : begin //OR
                res = {1'b0, A} | {1'b0, B};
                C = 0;
                RESULT = res[7:0];
                Z = (res == 0)?1:0;
            end
            4'b0111 : begin //EXOR
                res = {1'b0, A} ^ {1'b0, B};
                C = 0;
                RESULT = res[7:0];
                Z = (res == 0)?1:0;
            end
            4'b1000 : begin //TEST
                res = {1'b0, A} & {1'b0, B};
                C = 0;
                RESULT = res[7:0];
                Z = (res == 0)?1:0;
            end
            4'b1001 : begin //LSL
                res = {A, CIN};
                C = res[8];
                RESULT = res[7:0];
                Z = (res == 0)?1:0;
            end
            4'b1010 : begin //LSR
                res = {CIN, A};
                C = res[0];
                RESULT = res[8:1];
                Z = (res == 0)?1:0;
            end
            4'b1011 : begin //ROL
                res = {1'b0, A[6:0], A[7]};
                C = A[7];
                RESULT = res[7:0];
                Z = (res == 0)?1:0;
            end
            4'b1100 : begin //ROR
                res = {1'b0, A[0], A[7:1]};
                C = A[0];
                RESULT = res[7:0];
                Z = (res == 0)?1:0;
            end
            4'b1101 : begin //ASR
                res = {1'b0, A[7], A[7:1]};
                C = A[0];
                RESULT = res[7:0];
                Z = (res == 0)?1:0;
            end
            4'b1110 : begin //MOV
                RESULT = B;
                C = 0;
                Z = 0;
            end
            default : begin
                RESULT = 0;
                C = 0;
                Z = 0;
            end
        endcase
    end
endmodule
