module subtract (
    input  wire [3:0] a     ,
    input  wire [3:0] b     ,
    input  wire       c_in  ,
    output wire [3:0] s_out ,
    output wire       c_out
);
    wire [3:0] b_neg        ;
    assign b_neg = ~b       ;

    adder u_adder (
        .a(a)               ,
        .b(b_neg)           ,
        .c_in(c_in)         ,
        .s_out(s_out)       ,
        .c_out(c_out)
    );
endmodule

