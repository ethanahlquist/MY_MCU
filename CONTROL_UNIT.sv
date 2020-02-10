`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ethan Ahlquist
// Create Date: 02/05/2019 01:57:04 PM
// Module Name: CONTROL_UNIT
// Project Name: 
//////////////////////////////////////////////////////////////////////////////////

module CONTROL_UNIT(
    input C, Z, INTR, RESET, CLK,
    input [4:0] OPCODE_HI_5,
    input [1:0] OPCODE_LO_2,
    output logic I_SET, I_CLR, PC_LD, PC_INC, ALU_OPY_SEL, RF_WR, SP_LD, SP_INCR, SP_DECR, SCR_WE, SCR_DATA_SEL, FLG_C_SET,
                 FLG_C_CLR, FLG_C_LD, FLG_Z_LD, FLG_LD_SEL, FLG_SHAD_LD, RST, IO_STRB,
    output logic [1:0] PC_MUX_SEL, RF_WR_SEL, SCR_ADDR_SEL,
    output logic [3:0] ALU_SEL
    );
    
    logic [6:0] opcode;
    assign opcode = {OPCODE_HI_5, OPCODE_LO_2};
    
    typedef enum {ST_INIT, ST_FETCH, ST_EXEC, ST_INTR} STATE;
    STATE NS, PS = ST_INIT;
    
    always_ff @ (posedge CLK) begin
        if(RESET == 1)
            PS <= ST_INIT;
        else PS <= NS;
    end
    
    always_comb begin
    
/////////////////////////////////////////////////////////////////////    
//INITIALIZING OUTPUTS
I_SET = 0; I_CLR= 0; PC_LD= 0; PC_INC= 0; ALU_OPY_SEL = 0; RF_WR= 0; SP_LD= 0; SP_INCR= 0; SP_DECR= 0; SCR_WE= 0; SCR_DATA_SEL= 0; FLG_C_SET= 0; FLG_C_CLR= 0; FLG_C_LD= 0; FLG_Z_LD= 0; FLG_LD_SEL= 0; FLG_SHAD_LD= 0; RST = 0; IO_STRB= 0;
PC_MUX_SEL = 0; RF_WR_SEL = 0; SCR_ADDR_SEL = 0;
ALU_SEL = 4'b1111;
/////////////////////////////////////////////////////////////////////
        case(PS)
    
        ST_INIT : begin
            RST = 1;
            NS = ST_FETCH;
        end
    
        ST_FETCH : begin
            PC_INC = 1;
            NS = ST_EXEC;
        end
        
        ST_INTR : begin
        
            // pause interupts
            I_CLR = 1;
            
            // Current PC is stored
            SP_DECR = 1;
            SCR_WE = 1;
            SCR_ADDR_SEL = 3; 
            SCR_DATA_SEL = 1; 
            
            // Save Flags
            FLG_SHAD_LD = 1;
            
            // Load 0x3FF:
            PC_LD = 1;
            PC_MUX_SEL = 2; 
            
            // Next State
            NS = ST_FETCH;
        end
    
        ST_EXEC : begin
//IN
//////////////////////////////////////////////////////////////////////////////
            case(opcode)
                7'b1100100, //rx,imm 
                7'b1100101, 
                7'b1100110, 
                7'b1100111 : begin
                    RF_WR_SEL = 3;
                    RF_WR = 1;
                    end
//////////////////////////////////////////////////////////////////////////////                    
//MOV //GOOD
//////////////////////////////////////////////////////////////////////////////     
                7'b0001001: begin //rx,ry 
                    RF_WR_SEL = 0;
                    RF_WR = 1;
                    ALU_SEL = 4'b1110;  // OK
                    ALU_OPY_SEL = 0;
                    end
                
                7'b1101100, //rx,imm 
                7'b1101101,
                7'b1101110,
                7'b1101111 : begin 
                    RF_WR_SEL = 0;
                    RF_WR = 1;
                    ALU_SEL = 4'b1110;  // OK
                    ALU_OPY_SEL = 1;
                    end
//////////////////////////////////////////////////////////////////////////////     
//EXOR //GOOD
//////////////////////////////////////////////////////////////////////////////     
                7'b0000010: begin //rx,ry
                    RF_WR_SEL = 0;      // OK
                    RF_WR = 1;          // OK
                    ALU_SEL = 4'b0111;  // OK
                    ALU_OPY_SEL = 0;
                    FLG_C_CLR = 1; 
                    FLG_Z_LD = 1;  
                    end
                
                7'b1001000, //rx,imm
                7'b1001001,
                7'b1001010,
                7'b1001011 : begin 
                    RF_WR_SEL = 0;      //OK
                    RF_WR = 1;          //OK
                    ALU_SEL = 4'b0111;  //OK
                    ALU_OPY_SEL = 1;
                    FLG_C_CLR = 1; 
                    FLG_Z_LD = 1;  
                    
                    end
//////////////////////////////////////////////////////////////////////////////                   
//OUT //GOOD
//////////////////////////////////////////////////////////////////////////////     
                7'b1101000, //rx,imm
                7'b1101001,
                7'b1101010,
                7'b1101011 : begin 
                    IO_STRB = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////     
//BRN //GOOD
//////////////////////////////////////////////////////////////////////////////
                7'b0010000 : begin //imm type
                    PC_LD = 1;
                    PC_MUX_SEL = 0; // not necessary...
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//AND //so far, so good
//////////////////////////////////////////////////////////////////////////////     
                7'b0000000: begin //rx,ry   //OK
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0101;  // OK
                    ALU_OPY_SEL = 0;
                    FLG_C_CLR = 1; 
                    FLG_Z_LD = 1;  
                    end
                
                7'b1000000, //rx,imm    //OK
                7'b1000001,
                7'b1000010,
                7'b1000011 : begin 
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0101; // OK
                    ALU_OPY_SEL = 1;
                    FLG_C_CLR = 1; 
                    FLG_Z_LD = 1;  
                    
                    end
//////////////////////////////////////////////////////////////////////////////               
//OR //so far, so good
//////////////////////////////////////////////////////////////////////////////     
                7'b0000001: begin //rx,ry   //OK
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0110;  // OK
                    ALU_OPY_SEL = 0;
                    FLG_C_CLR = 1;
                    FLG_Z_LD = 1;
                    end
                
                7'b1000100, //rx,imm    //OK
                7'b1000101,
                7'b1000110,
                7'b1000111 : begin 
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0110;  //OK
                    ALU_OPY_SEL = 1;
                    FLG_C_CLR = 1;
                    FLG_Z_LD = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//LSL //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0100000 : begin //reg type
                    RF_WR = 1;
                    RF_WR_SEL = 0;
                    ALU_SEL = 4'b1001; // OK
                    FLG_C_LD = 1;
                    FLG_Z_LD = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//LSR //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0100001 : begin //reg type
                    RF_WR = 1;
                    RF_WR_SEL = 0;
                    ALU_SEL = 4'b1010; // OK
                    FLG_C_LD = 1;
                    FLG_Z_LD = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//BREQ //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0010010 : begin //imm type
                    if(Z == 1) begin 
                        PC_LD = 1; 
                        PC_MUX_SEL = 0; // not necessary...
                        end
                    else begin end
                        
                    end
//////////////////////////////////////////////////////////////////////////////   
//BRNE //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0010011 : begin //imm type
                    if(Z == 0) begin 
                        PC_LD = 1; 
                        PC_MUX_SEL = 0; // not necessary...
                        end
                    else begin end
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//BRCS //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0010100 : begin //imm type
                    if(C == 1) begin 
                        PC_LD = 1; 
                        PC_MUX_SEL = 0; // not necessary...
                        end
                    else begin end
                    end
//////////////////////////////////////////////////////////////////////////////   
//BRCC //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0010101 : begin //imm type
                    if(C == 0) begin 
                        PC_LD = 1; 
                        PC_MUX_SEL = 0; // not necessary...
                        end
                    else begin end
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//ADD //so far, so good
//////////////////////////////////////////////////////////////////////////////     
                7'b0000100: begin //rx,ry   //OK
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0000;  // OK
                    ALU_OPY_SEL = 0;
                    FLG_C_LD = 1;
                    FLG_Z_LD = 1;
                    end
                
                7'b1010000, //rx,imm    //OK
                7'b1010001,
                7'b1010010,
                7'b1010011 : begin 
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0000;  // OK
                    ALU_OPY_SEL = 1;
                    FLG_C_LD = 1; 
                    FLG_Z_LD = 1; 
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//ADDC //so far, so good
//////////////////////////////////////////////////////////////////////////////     
                7'b0000101: begin //rx,ry   //OK
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0001;  // OK
                    ALU_OPY_SEL = 0;
                    FLG_C_LD = 1; 
                    FLG_Z_LD = 1; 
                    
                    end
                
                7'b1010100, //rx,imm    //OK
                7'b1010101,
                7'b1010110,
                7'b1010111 : begin 
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0001;  // OK
                    ALU_OPY_SEL = 1;                   
                    FLG_C_LD = 1; 
                    FLG_Z_LD = 1; 
                    
                    end 
//////////////////////////////////////////////////////////////////////////////                    
//SUB //so far, so good
//////////////////////////////////////////////////////////////////////////////     
                7'b0000110: begin //rx,ry   //OK
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0010;  // OK
                    ALU_OPY_SEL = 0;
                    FLG_C_LD = 1; 
                    FLG_Z_LD = 1; 
                    end
                
                7'b1011000, //rx,imm    //OK
                7'b1011001,
                7'b1011010,
                7'b1011011 : begin 
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0010;  // OK
                    ALU_OPY_SEL = 1;
                    FLG_C_LD = 1; 
                    FLG_Z_LD = 1; 
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//SUBC //so far, so good
//////////////////////////////////////////////////////////////////////////////     
                7'b0000111: begin //rx,ry   //OK
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0011;  // OK
                    ALU_OPY_SEL = 0;
                    FLG_C_LD = 1; 
                    FLG_Z_LD = 1; 
                    end
                
                7'b1011100, //rx,imm    //OK
                7'b1011101,
                7'b1011110,
                7'b1011111 : begin 
                    RF_WR_SEL = 0;      
                    RF_WR = 1;          
                    ALU_SEL = 4'b0011;  // OK
                    ALU_OPY_SEL = 1;
                    FLG_C_LD = 1; 
                    FLG_Z_LD = 1; 
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//TEST //so far, so good
//////////////////////////////////////////////////////////////////////////////     
                7'b0000011: begin //rx,ry   //OK
                    ALU_SEL = 4'b1000;  // OK
                    ALU_OPY_SEL = 0;
                    FLG_C_CLR = 1;
                    FLG_Z_LD = 1;
                    end
                                    
                7'b1001100, //rx,imm    //OK
                7'b1001101,
                7'b1001110,
                7'b1001111 : begin 
                    ALU_SEL = 4'b1000;  // OK
                    ALU_OPY_SEL = 1;
                    FLG_C_CLR = 1; 
                    FLG_Z_LD = 1; 
                                        
                    end
//////////////////////////////////////////////////////////////////////////////                     
//CMP //so far, so good
//////////////////////////////////////////////////////////////////////////////     
                7'b0001000: begin //rx,ry   //OK
                    ALU_SEL = 4'b0100;  // OK
                    ALU_OPY_SEL = 0;
                    FLG_C_LD = 1;
                    FLG_Z_LD = 1;
                    end
                                    
                7'b1100000, //rx,imm    //OK
                7'b1100001,
                7'b1100010,
                7'b1100011 : begin 
                    ALU_SEL = 4'b0100;  // OK
                    ALU_OPY_SEL = 1;
                    FLG_C_LD = 1; 
                    FLG_Z_LD = 1; 
                                        
                    end              
//////////////////////////////////////////////////////////////////////////////  
//CALL // THIS IS WHAT SHE GAVE US
//////////////////////////////////////////////////////////////////////////////
                7'b0010001 : begin //imm type
                
                    SP_DECR = 1;
                    SCR_WE = 1;
                    SCR_ADDR_SEL = 3; //CUZ from SP decrments after not before write.
                    SCR_DATA_SEL = 1; //writes current SP down for later.
                    //
                    PC_MUX_SEL = 0; 
                    PC_LD = 1;
                    
                    
                    //PC_LD = 1;
                    //PC_MUX_SEL = 0; 
                    //SCR_WE = 1;
                    //SCR_DATA_SEL = 0;
                    //SCR_ADDR_SEL = 3;
                    //SP_DECR = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////      
//ROL //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0100010 : begin //reg type
                    RF_WR_SEL = 0;
                    RF_WR = 1;    
                    ALU_SEL = 4'b1011;  // OK
                    FLG_C_LD = 1;
                    FLG_Z_LD = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//ROR //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0100011 : begin //reg type
                    RF_WR_SEL = 0;
                    RF_WR = 1;    
                    ALU_SEL = 4'b1100;  // OK
                    FLG_C_LD = 1;
                    FLG_Z_LD = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////  
//ASR //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0100100 : begin //reg type
                    ALU_SEL = 4'b1101;  // OK
                    RF_WR_SEL = 0;
                    RF_WR = 1;  
                    FLG_C_LD = 1; 
                    FLG_Z_LD = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//PUSH // WE'LL SEE
//////////////////////////////////////////////////////////////////////////////
                7'b0100101 : begin //reg type
                    SP_DECR = 1;
                    SCR_WE = 1;
                    SCR_ADDR_SEL = 3; //CUZ from SP decrments after not before write.
                    SCR_DATA_SEL = 0; 
                   
                    end
//////////////////////////////////////////////////////////////////////////////    
//POP // WE'LL SEE
//////////////////////////////////////////////////////////////////////////////
                7'b0100110 : begin //reg type
                    RF_WR_SEL = 1;
                    RF_WR = 1;
                    SP_INCR = 1;
                    SCR_ADDR_SEL = 2;
                    
                    end
//////////////////////////////////////////////////////////////////////////////  
//WSP 
//////////////////////////////////////////////////////////////////////////////
                7'b0101000 : begin //reg type // STACK POINTER STUFF
                    SP_LD = 1;
                   
                    end
//////////////////////////////////////////////////////////////////////////////  
//RSP  // WE'll SEE
//////////////////////////////////////////////////////////////////////////////
                7'b0101001 : begin //reg type
                    RF_WR_SEL = 2;  // STACK POINTER
                    RF_WR = 1;    
                    
                    end
////////////////////////////////////////////////////////////////////////////// 
//ST // WE'LL SEE // NOiCE
//////////////////////////////////////////////////////////////////////////////     
                7'b0001011: begin //rx,ry   //OK
                    SCR_DATA_SEL = 0;
                    SCR_ADDR_SEL = 0;
                    SCR_WE = 1;
                    end
                
                7'b1110100, //rx,imm    //OK
                7'b1110101,
                7'b1110110,
                7'b1110111 : begin 
                    SCR_DATA_SEL = 0;
                    SCR_ADDR_SEL = 1;
                    SCR_WE = 1;
                    
                    end
////////////////////////////////////////////////////////////////////////////// 
//LD // WE'LL SEE
//////////////////////////////////////////////////////////////////////////////     
                7'b0001010: begin //rx,ry   //OK
                    RF_WR_SEL = 1;          //OK
                    RF_WR = 1;              //OK
                    SCR_ADDR_SEL = 0;        
                    end
                
                7'b1110000, //rx,imm    //OK
                7'b1110001,             //OK
                7'b1110010,
                7'b1110011 : begin 
                    RF_WR_SEL = 1;      
                    RF_WR = 1;          
                    SCR_ADDR_SEL = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//CLC //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0110000 : begin //imm type
                    FLG_C_CLR = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////    
//SEC //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0110001: begin //imm type
                    FLG_C_SET = 1;
                    
                    end
////////////////////////////////////////////////////////////////////////////// 
//RET // WE'LL FIX
//////////////////////////////////////////////////////////////////////////////
                7'b0110010: begin //imm type
                
                    //RF_WR_SEL = 1;
                    //RF_WR = 1;
                    SP_INCR = 1;
                    SCR_ADDR_SEL = 2;
                    PC_LD = 1;
                    PC_MUX_SEL = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////    
//SEI //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0110100 : begin //none type
                    I_SET = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//CLI //so far, so good
//////////////////////////////////////////////////////////////////////////////
                7'b0110101 : begin //none type
                    I_CLR = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////   
//RETID 
//////////////////////////////////////////////////////////////////////////////
                7'b0110110 : begin //none type
                    I_CLR = 1;
                    FLG_LD_SEL = 1;
                    SP_INCR = 1;
                    SCR_ADDR_SEL = 2;
                    PC_LD = 1;
                    PC_MUX_SEL = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////
//RETIE 
//////////////////////////////////////////////////////////////////////////////
                7'b0110111 : begin //none type
                    I_SET = 1;
                    FLG_LD_SEL = 1;
                    SP_INCR = 1;
                    SCR_ADDR_SEL = 2;
                    PC_LD = 1;
                    PC_MUX_SEL = 1;
                    
                    end
//////////////////////////////////////////////////////////////////////////////         

                default: RST = 0;   // NEVER GETS HERE
            endcase
            if(INTR == 1)
                NS = ST_INTR;
            else
                NS = ST_FETCH;  
        end                         // end STATE
    endcase
    end                             // end always_comb
endmodule
