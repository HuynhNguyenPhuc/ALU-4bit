module lsr(
  input   wire [3:0] a,
  input   wire [1:0]  b,
  output  reg [3:0] result
);

  reg [3:0] stage1;

  always @(*) begin 

    if( b[1] == 1 )     stage1 = { 2'b0, a[3:2] };
    else                stage1 = a;

    if( b[0] == 1 )     result = { 1'b0, stage1[3:1] };
    else                result = stage1;
  end

endmodule 