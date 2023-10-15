// ALU.v
module ALU
#(parameter AND=0,OR=1,XOR=2,NOR=3,ADD=4,SUB=5,SLT=6,SLL=7)
(ALU_OP, A, B, F, OF, ZF);
    input[2:0] ALU_OP;
    input[31:0] A, B;
    output reg[31:0] F;
    output reg OF, ZF;
    reg C32;
    
    always@*
    begin
        OF = 0;
        C32 = 0;
        case(ALU_OP)
            AND: F = A & B;
            OR : F = A | B;
            XOR: F = A ^ B;
            NOR: F = ~(A | B);
            ADD: begin {C32,F} = A + B; OF = A[31] ^ B[31] ^ C32 ^ F[31]; end
            SUB: begin {C32,F} = A - B; OF = A[31] ^ B[31] ^ C32 ^ F[31]; end
            SLT: F = A<B? 1 : 0;
            SLL: F = B << A;
            default: F = A & B;
        endcase
        ZF = F==0? 1 : 0;
    end
endmodule
