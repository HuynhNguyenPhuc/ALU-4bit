module full_adder (
    input  wire a,      // Đầu vào 1-bit
    input  wire b,      // Đầu vào 1-bit
    input  wire c_in,   // Carry đầu vào
    output wire s_out,  // Tổng 1-bit
    output wire c_out   // Carry đầu ra
);
    assign s_out = a ^ b ^ c_in;
    assign c_out = (a & b) | (c_in & (a ^ b));
endmodule