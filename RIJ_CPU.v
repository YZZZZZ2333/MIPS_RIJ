// RIJ_CPU.v
module RIJ_CPU(clk_low, clk_high, rst, PC, FR_ZF, FR_OF, F, Inst_code, M_R_Data);
    input clk_low, clk_high, rst;
    output reg FR_ZF, FR_OF;
    output[31:0] PC, F, Inst_code, M_R_Data;
    
    reg[31:0] PC;
    wire[31:0] PC_new, W_Data, R_Data_A, R_Data_B, ALU_B, imm_data;
    wire[2:0] ALU_OP;
    wire ZF, OF, imm_s, rt_imm_s, Write_Reg, Mem_Write;
    wire[1:0] w_r_s, wr_data_s, PC_s;
    wire[15:0] imm;
    wire[25:0] address;
    wire[4:0] W_Addr, rs, rt, rd;
    
    assign PC_new = PC + 4;
    assign rs = Inst_code[25:21];
    assign rt = Inst_code[20:16];
    assign rd = Inst_code[15:11];
    assign imm = Inst_code[15:0];
    assign address = Inst_code[25:0];
    assign W_Addr = (w_r_s[1]) ? 5'b11111 : ((w_r_s[0]) ? rt : rd);
    assign W_Data = (wr_data_s[1]) ? PC_new : ((wr_data_s[0]) ? M_R_Data : F);
    assign imm_data = imm_s ? {{16{imm[15]}},imm} : {{16{1'b0}},imm};
    assign ALU_B = rt_imm_s ? imm_data : R_Data_B;
    
    Controller Controller0(
        .OP(Inst_code[31:26]),
        .func(Inst_code[5:0]),
        .ZF(ZF),
        .w_r_s(w_r_s),
        .imm_s(imm_s),
        .rt_imm_s(rt_imm_s),
        .wr_data_s(wr_data_s),
        .ALU_OP(ALU_OP),
        .Write_Reg(Write_Reg),
        .Mem_Write(Mem_Write),
        .PC_s(PC_s)
    );
    
    ALU ALU0(
        .ALU_OP(ALU_OP),
        .A(R_Data_A),
        .B(ALU_B),
        .F(F),
        .OF(OF),
        .ZF(ZF)
    );
    
    RegFile RegFile0(
        .clk(~clk_low),
        .rst(rst),
        .R_Addr_A(rs),
        .R_Addr_B(rt),
        .W_Addr(W_Addr),
        .W_Data(W_Data),
        .Write_Reg(Write_Reg),
        .R_Data_A(R_Data_A),
        .R_Data_B(R_Data_B)
    );
    
    RAM_B RAM_B0(
        .clka(clk_high),
        .wea(Mem_Write),
        .addra(F[7:2]),
        .dina(R_Data_B),
        .douta(M_R_Data)
    );
    
    Inst_ROM Inst_ROM0(
        .clka(clk_low),
        .addra(PC[7:2]),
        .douta(Inst_code)
    );

    
    always @(negedge clk_low or posedge rst)
    begin
        if(rst)
        begin
            PC <= 32'h00000000;
            FR_ZF <= 0;
            FR_OF <= 0;
        end
        else
        begin
            FR_ZF <= ZF;
            FR_OF <= OF;
            case(PC_s)
                2'b00: PC <= PC_new;
                2'b01: PC <= R_Data_A;
                2'b10: PC <= PC_new + (imm_data << 2);
                2'b11: PC <= {{PC_new[31:28]},{address},{2'b00}};
            endcase
        end
    end
endmodule
