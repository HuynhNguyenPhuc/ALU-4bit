module synth_wrapper (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [3:0]  a,
    input  wire [3:0]  b,
    input  wire [2:0]  op,
    output wire [3:0]  result,
    output wire        carry
  );////////////////
  // Dây nối cho kết quả và carry từ các module con
  wire [3:0] add_out, sub_out, and_out, or_out, xor_out, not_out, lsl_out, lsr_out;
  wire add_carry, sub_carry;

  // Instance các module con
  adder u_adder (
          .a(a),
          .b(b),
          .c_in(1'b0),       // Carry đầu vào = 0 cho phép cộng
          .s_out(add_out),
          .c_out(add_carry)
        );

  subtract u_subtract (
             .a(a),
             .b(b),
             .c_in(1'b1),       // Carry đầu vào = 1 cho phép trừ
             .s_out(sub_out),
             .c_out(sub_carry)
           );

  and_gate u_and (
             .a(a),
             .b(b),
             .out(and_out)
           );

  or_gate u_or (
            .a(a),
            .b(b),
            .out(or_out)
          );

  xor_gate u_xor (
             .a(a),
             .b(b),
             .out(xor_out)
           );

  not_gate u_not (
             .a(a),
             .out(not_out)
           );

  lsl u_lsl (
        .a(a),
        .b(b[1:0]),
        .out(lsl_out)
      );

  lsr u_lsr (
        .a(a),
        .b(b[1:0]),
        .result(lsr_out)
      );

  // Thanh ghi lưu kết quả và carry
  reg [3:0] result_reg;
  reg carry_reg;

  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
    begin
      result_reg <= 4'b0000;
      carry_reg <= 1'b0;
    end
    else
    begin
      case (op)
        3'b000:
        begin // Cộng
          result_reg <= add_out;
          carry_reg <= add_carry;
        end
        3'b001:
        begin // Trừ
          result_reg <= sub_out;
          carry_reg <= sub_carry;
        end
        3'b010:
        begin // AND
          result_reg <= and_out;
          carry_reg <= 1'b0;
        end
        3'b011:
        begin // OR
          result_reg <= or_out;
          carry_reg <= 1'b0;
        end
        3'b100:
        begin // XOR
          result_reg <= xor_out;
          carry_reg <= 1'b0;
        end
        3'b101:
        begin // NOT
          result_reg <= not_out;
          carry_reg <= 1'b0;
        end
        3'b110:
        begin // Dịch trái
          result_reg <= lsl_out;
          carry_reg <= 1'b0;
        end
        3'b111:
        begin // Dịch phải
          result_reg <= lsr_out;
          carry_reg <= 1'b0;
        end
        default:
        begin
          result_reg <= 4'b0000;
          carry_reg <= 1'b0;
        end
      endcase
    end
  end

  // Gán đầu ra
  assign result = result_reg;
  assign carry = carry_reg;
endmodule
