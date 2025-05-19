module  xor_gate (
    input   wire   [3:0]    a     , 
    input   wire   [3:0]    b     ,
    output  wire   [3:0]    out
);

assign  out = a ^ b               ;

endmodule