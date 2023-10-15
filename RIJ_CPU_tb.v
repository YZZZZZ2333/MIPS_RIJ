// RIJ_CPU_tb.v
`timescale 1ns / 1ps
module RIJ_CPU_tb;

    // Inputs
    reg clk_low;
    reg clk_high;
    reg rst;

    // Outputs
    wire [31:0] PC;
    wire FR_ZF;
    wire FR_OF;
    wire [31:0] F;
    wire [31:0] Inst_code;
    wire [31:0] M_R_Data;

    // Instantiate the Unit Under Test (UUT)
    RIJ_CPU uut (
        .clk_low(clk_low), 
        .clk_high(clk_high), 
        .rst(rst), 
        .PC(PC), 
        .FR_ZF(FR_ZF), 
        .FR_OF(FR_OF), 
        .F(F), 
        .Inst_code(Inst_code), 
        .M_R_Data(M_R_Data)
    );

    initial begin
        // Initialize Inputs
        clk_low = 0;
        clk_high = 0;
        rst = 1;

        // Wait 50 ns for global reset to finish
        #50;
        
        // Add stimulus here
        rst = 0;
    end
    always
        #10 clk_low = ~clk_low;
    always
        #2.5    clk_high = ~clk_high;
endmodule
