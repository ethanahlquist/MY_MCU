`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ethan Ahlquist 
// Create Date: 01/21/2019 02:51:38 PM
// Module Name: period_eval
// Description: 
// Dependencies: 
//////////////////////////////////////////////////////////////////////////////////

module period_eval(
    input [7:0] din,
    output logic [16:0] period // max period = 131071 useinbg bit-shift to approx actual period
    );
always_comb
begin
  case (din) 
    0 : begin  period = 0; end         
    1 : begin  period = 95556; end              //C
    2 : begin  period = 90193; end              //C# / Db
    3 : begin  period = 85131; end              //D
    4 : begin  period = 80353; end              //D# / Eb
    5 : begin  period = 75843; end              //E
    6 : begin  period = 71586; end              //F
    7 : begin  period = 67568; end              //F# / Gb
    8 : begin  period = 63776; end              //G
    9 : begin  period = 60196; end              //G# / Ab
    10 : begin  period = 56818; end             //A
    11 : begin  period = 53629; end             //A# / Bb
    12 : begin  period = 50619; end             //B
    13 : begin  period = 47778; end             //C
    14 : begin  period = 45096; end             //C# / Db
    15 : begin  period = 42565; end             //D
    16 : begin  period = 40176; end             //D# / Eb
    17 : begin  period = 37921; end             //E
    18 : begin  period = 35793; end             //F
    19 : begin  period = 33784; end             //F# / Gb
    20 : begin  period = 31888; end             //G
    21 : begin  period = 30098; end             //G# / Ab
    22 : begin  period = 28409; end             //A
    23 : begin  period = 26815; end             //A# / Bb
    24 : begin  period = 25310; end             //B
    25 : begin  period = 23889; end             //C
    26 : begin  period = 22548; end             //C# / Db
    27 : begin  period = 21283; end             //D
    28 : begin  period = 20088; end             //D# / Eb
    29 : begin  period = 18961; end             //E
    30 : begin  period = 17897; end             //F
    31 : begin  period = 16892; end             //F# / Gb
    32 : begin  period = 15944; end             //G
    33 : begin  period = 15049; end             //G# / Ab
    34 : begin  period = 14204; end             //A
    35 : begin  period = 13407; end             //A# / Bb
    36 : begin  period = 12655; end             //B
    default: period = 0;
  endcase
end
endmodule
