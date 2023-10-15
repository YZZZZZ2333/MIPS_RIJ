// Controller.v
module Controller(OP, func, ZF, w_r_s, imm_s, rt_imm_s, wr_data_s, ALU_OP, Write_Reg, Mem_Write, PC_s);
    input[5:0] OP, func;
    input ZF;
    output reg imm_s, rt_imm_s, Write_Reg, Mem_Write;
    output reg[1:0] w_r_s, wr_data_s, PC_s;
    output reg[2:0] ALU_OP;
    
    always @(*)
    begin
        w_r_s = 2'b00;
        imm_s = 0;
        rt_imm_s = 0;
        wr_data_s = 2'b00;
        ALU_OP = 3'b000;
        Write_Reg = 0;
        Mem_Write = 0;
        PC_s = 2'b00;
        case(OP)
            6'b000000:
            begin
                case(func)
                    6'b100000: begin ALU_OP = 3'b100; Write_Reg = 1; end
                    6'b100010: begin ALU_OP = 3'b101; Write_Reg = 1; end
                    6'b100100: begin ALU_OP = 3'b000; Write_Reg = 1; end
                    6'b100101: begin ALU_OP = 3'b001; Write_Reg = 1; end
                    6'b100110: begin ALU_OP = 3'b010; Write_Reg = 1; end
                    6'b100111: begin ALU_OP = 3'b011; Write_Reg = 1; end
                    6'b101011: begin ALU_OP = 3'b110; Write_Reg = 1; end
                    6'b000100: begin ALU_OP = 3'b111; Write_Reg = 1; end
                    6'b001000: PC_s = 2'b01; //jr
                endcase
            end
            6'b001000: //addi
            begin
                w_r_s = 2'b01;
                imm_s = 1;
                rt_imm_s = 1;
                ALU_OP = 3'b100;
                Write_Reg = 1;
            end
            6'b001100: //andi
            begin
                w_r_s = 2'b01;
                rt_imm_s = 1;
                ALU_OP = 3'b000;
                Write_Reg = 1;
            end
            6'b001110: //xori
            begin
                w_r_s = 2'b01;
                rt_imm_s = 1;
                ALU_OP = 3'b010;
                Write_Reg = 1;
            end
            6'b001011: //sltiu
            begin
                w_r_s = 2'b01;
                rt_imm_s = 1;
                ALU_OP = 3'b110;
                Write_Reg = 1;
            end
            6'b100011: //lw
            begin
                w_r_s = 2'b01;
                imm_s = 1;
                rt_imm_s = 1;
                wr_data_s = 2'b01;
                ALU_OP = 3'b100;
                Write_Reg = 1;
            end
            6'b101011: //sw
            begin
                imm_s = 1;
                rt_imm_s = 1;
                ALU_OP = 3'b100;
                Mem_Write = 1;
            end
            6'b000100: //beq
            begin
                imm_s = 1;
                ALU_OP = 3'b101;
                PC_s = ZF ? 2'b10 : 2'b00;
            end
            6'b000101: //bne
            begin
                imm_s = 1;
                ALU_OP = 3'b101;
                PC_s = ZF ? 2'b00 : 2'b10;
            end
            6'b000010: //j
            begin
                PC_s = 2'b11;
            end
            6'b000011: //jal
            begin
                w_r_s = 2'b10;
                wr_data_s = 2'b10;
                Write_Reg = 1;
                PC_s = 2'b11;
            end
        endcase
        
    end
    
endmodule
