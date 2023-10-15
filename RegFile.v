// RegFile.v
module RegFile(clk, rst, R_Addr_A, R_Addr_B, W_Addr, W_Data, Write_Reg, R_Data_A, R_Data_B);
    input[4:0] R_Addr_A, R_Addr_B, W_Addr;
    input[31:0] W_Data;
    input Write_Reg, clk, rst;
    output[31:0] R_Data_A, R_Data_B;
    reg[31:0] REG_Files[0:31];
    integer i;
    
    assign R_Data_A = REG_Files[R_Addr_A];
    assign R_Data_B = REG_Files[R_Addr_B];
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            for(i=0; i<32; i=i+1)
                REG_Files[i] <= 0;
        else
        begin
            if(Write_Reg)
                REG_Files[W_Addr] <= W_Data;
        end
    end
endmodule
