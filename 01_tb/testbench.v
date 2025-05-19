module tb_synth_wrapper;
    // Khai báo tín hiệu
    reg        clk;
    reg        rst_n;
    reg [3:0]  a;
    reg [3:0]  b;
    reg [2:0]  op;
    wire [3:0] result;
    wire       carry;

    // Biến để kiểm tra PASS/FAIL
    reg [3:0] expected_result;
    reg       expected_carry;
    integer   testcase_count = 0;

    // Instance module synth_wrapper
    synth_wrapper uut (
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .carry(carry)
    );

    initial begin
        $shm_open("waves.shm");
        $shm_probe("ASM");
    end

    // Tạo clock (chu kỳ 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Hàm kiểm tra PASS/FAIL
    task check_result;
        input [3:0] exp_result;
        input       exp_carry;
        input [31:0] testcase_num;
        input [255:0] testcase_desc;
        begin
            if (result === exp_result && carry === exp_carry) begin
                $display("[PASS] Testcase %0d: %0s", testcase_num, testcase_desc);
                $display("  Result = %b, Carry = %b (Expected: %b, %b)", result, carry, exp_result, exp_carry);
            end else begin
                $display("[FAIL] Testcase %0d: %0s", testcase_num, testcase_desc);
                $display("  Result = %b, Carry = %b (Expected: %b, %b)", result, carry, exp_result, exp_carry);
                #10
                $finish;
            end
        end
    endtask
    initial begin
        // Khởi tạo
        rst_n = 0;
        a = 4'b0000;
        b = 4'b0000;
        op = 3'b000;
        expected_result = 4'b0000;
        expected_carry = 1'b0;

        // Testcase 1: Reset
        testcase_count = testcase_count + 1;
        #10;
        check_result(4'b0000, 1'b0, testcase_count, "Reset (rst_n = 0)");

        // Bỏ reset
        rst_n = 1;
        #10;

        // Testcase 2: ADD (a = 7, b = 8 → 15)
        testcase_count = testcase_count + 1;
        op = 3'b000; a = 4'd7; b = 4'd8;
        expected_result = 4'd15; expected_carry = 1'b0;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "Add (a = 7, b = 8)");

        // Testcase 3: ADD overflow (a = 9, b = 8 → 1 with carry)
        testcase_count = testcase_count + 1;
        op = 3'b000; a = 4'd9; b = 4'd8;
        expected_result = 4'd1; expected_carry = 1'b1;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "Add with overflow (a = 9, b = 8)");

        // Testcase 4: SUB (a = 12, b = 5 → 7)
        testcase_count = testcase_count + 1;
        op = 3'b001; a = 4'd12; b = 4'd5;
        expected_result = 4'd7; expected_carry = 1'b1;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "Subtract (a = 12, b = 5)");

        // Testcase 5: SUB borrow (a = 1, b = 6 → -5 = 1011)
        testcase_count = testcase_count + 1;
        op = 3'b001; a = 4'd1; b = 4'd6;
        expected_result = 4'b1011; expected_carry = 1'b0;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "Subtract with borrow (a = 1, b = 6)");

        // Testcase 6: AND (1101 & 0111 = 0101)
        testcase_count = testcase_count + 1;
        op = 3'b010; a = 4'b1101; b = 4'b0111;
        expected_result = 4'b0101; expected_carry = 1'b0;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "AND (a = 1101, b = 0111)");

        // Testcase 7: OR (0101 | 0011 = 0111)
        testcase_count = testcase_count + 1;
        op = 3'b011; a = 4'b0101; b = 4'b0011;
        expected_result = 4'b0111; expected_carry = 1'b0;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "OR (a = 0101, b = 0011)");

        // Testcase 8: XOR (1111 ^ 1010 = 0101)
        testcase_count = testcase_count + 1;
        op = 3'b100; a = 4'b1111; b = 4'b1010;
        expected_result = 4'b0101; expected_carry = 1'b0;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "XOR (a = 1111, b = 1010)");
        // Testcase 9: NOT (~0001 = 1110)
        testcase_count = testcase_count + 1;
        op = 3'b101; a = 4'b0001; b = 4'b0000;
        expected_result = 4'b1110; expected_carry = 1'b0;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "NOT (a = 0001)");

        // Testcase 10: Shift Left (0011 << 1 = 0110)
        testcase_count = testcase_count + 1;
        op = 3'b110; a = 4'b0011; b = 4'd1;
        expected_result = 4'b0110; expected_carry = 1'b0;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "Shift Left (a = 0011, b = 1)");

        // Testcase 11: Shift Left (0001 << 3 = 1000)
        testcase_count = testcase_count + 1;
        op = 3'b110; a = 4'b0001; b = 4'd3;
        expected_result = 4'b1000; expected_carry = 1'b0;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "Shift Left (a = 0001, b = 3)");

        // Testcase 12: Shift Right (1110 >> 1 = 0111)
        testcase_count = testcase_count + 1;
        op = 3'b111; a = 4'b1110; b = 4'd1;
        expected_result = 4'b0111; expected_carry = 1'b0;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "Shift Right (a = 1110, b = 1)");

        // Testcase 13: Shift Right (1000 >> 3 = 0001)
        testcase_count = testcase_count + 1;
        op = 3'b111; a = 4'b1000; b = 4'd3;
        expected_result = 4'b0001; expected_carry = 1'b0;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "Shift Right (a = 1000, b = 3)");

        // Testcase 14: SUB (a = 8, b = 8 = 0)
        testcase_count = testcase_count + 1;
        op = 3'b001; a = 4'd8; b = 4'd8;
        expected_result = 4'd0; expected_carry = 1'b1;
        #10;
        check_result(expected_result, expected_carry, testcase_count, "Subtract (a = 8, b = 8)");

        // Kết thúc mô phỏng
        #10;
        $display("Simulation completed. Total testcases: %0d", testcase_count);
        $finish;
    end
endmodule