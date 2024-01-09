`timescale 1ns / 1ps

module RippleCarryAdder #(parameter InputWidth = 4) (
  input [InputWidth-1:0] A,
  input [InputWidth-1:0] B,
  output [InputWidth:0] Sum
);

  wire [InputWidth:0] carry;
  
  genvar i;
  generate
    for (i = 0; i < InputWidth; i=i+1) begin : gen_adders
      full_adder FA (
        .A(A[i]),
        .B(B[i]),
        .Cin(i == 0 ? 1'b0 : carry[i-1]),
        .Sum(Sum[i]),
        .Cout(carry[i])
      );
    end
  endgenerate

  // Overflow bit
  assign Sum[InputWidth] = carry[InputWidth-1];

endmodule

module full_adder (
  input A,
  input B,
  input Cin,
  output Sum,
  output Cout
);

  assign Sum = A ^ B ^ Cin;
  assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule


`timescale 1ns / 1ps

module tb_RippleCarryAdder;

  reg [3:0] A, B;
  reg Cin;
  wire [4:0] Sum; // Change wire to reg


  RippleCarryAdder #(4) RCA (
    .A(A),
    .B(B),

    .Sum(Sum)
  );

  initial begin
    // Test case 1
    A = 4'b0110;
    B = 4'b1011;
    Cin = 1'b0;

    #10;

    // Check the result
    if (Sum === 5'b10001)
      $display("Test case 1 passed");
    else
      $display("Test case 1 failed");

    // Test case 2
    A = 4'd5;
    B = 4'd2;
    Cin = 1'b0;

    #10;

    // Check the result
    if (Sum === 5'd7)
      $display("Test case 2 passed");
    else
      $display("Test case 2 failed");

    // Add more test cases as needed

    // Finish simulation
    $finish;
  end

endmodule
