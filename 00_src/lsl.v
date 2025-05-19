module lsl(
  input   wire  [3:0] a,
  input   wire  [1:0] b,
  output  reg   [3:0] out
);
  reg [3:0] stage1;

  always @(*) begin
  
    if( b[1] == 1 ) stage1 = { stage1[1:0],2'b0 };
    else            stage1 = a;

    if( b[0] == 1 ) out = {stage1[2:0],1'b0};
    else            out = stage1;
  end

endmodule   