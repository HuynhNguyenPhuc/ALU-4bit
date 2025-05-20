// Module: adder
module adder (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       CI,
    output wire [3:0] S,
    output wire       CO
);
    // Internal carry chain
    wire [3:0] C;

    // LSB full adder
    full_adder fa0_inst (
        .a(A[0]),
        .b(B[0]),
        .c_in(CI),
        .s_out(S[0]),
        .c_out(C[0])
    );

    // Remaining full adders
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : fa_chain
            full_adder fa_inst (
                .a(A[i]),
                .b(B[i]),
                .c_in(C[i-1]),
                .s_out(S[i]),
                .c_out(C[i])
            );
        end
    endgenerate

    // Final carry output
    assign CO = C[3];
endmodule
