module adder (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       c_in,
    output wire [3:0] s_out,
    output wire       c_out
);
    wire [3:0] carry;

    generate
        genvar i;
        full_adder fa0 (
            .a(a[0]),
            .b(b[0]),
            .c_in(c_in),
            .s_out(s_out[0]),
            .c_out(carry[0])
        );
        for (i = 1; i < 4; i = i + 1) begin
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .c_in(carry[i-1]),
                .s_out(s_out[i]),
                .c_out(carry[i])
            );
        end
    endgenerate

    assign c_out = carry[3];
endmodule
