`timescale 1ns / 1ps

module ArithmeticLogicUnit(
input [15:0] A,
input [15:0] B,
input [4:0] FunSel,
input WF,
input Clock,
output reg [15:0] ALUOut,
output reg [3:0] FlagsOut);

reg carry;
    always @(*)
        begin
            case(FunSel)
                5'b00000: ALUOut[7:0] = A[7:0];
                5'b00001: ALUOut[7:0] = B[7:0];
                5'b00010: ALUOut[7:0] = ~A[7:0];
                5'b00011: ALUOut[7:0] = ~B[7:0];
                5'b00100: {carry,ALUOut[7:0]} = A[7:0]+B[7:0];   
                5'b00101: {carry,ALUOut[7:0]} = A[7:0]+B[7:0]+FlagsOut[2];
                5'b00110: {carry,ALUOut[7:0]} = A[7:0]-B[7:0];
                5'b00111: ALUOut[7:0] = A[7:0]&B[7:0];
                5'b01000: ALUOut[7:0] = A[7:0]|B[7:0];
                5'b01001: ALUOut[7:0] = A[7:0]^B[7:0];
                5'b01010: ALUOut[7:0] = ~(A[7:0]&B[7:0]);
                5'b01011: {carry,ALUOut[7:0]} = {A[7:0],1'b0}; 
                5'b01100: {ALUOut[7:0],carry} = {1'b0,A[7:0]};
                5'b01101: {ALUOut[7:0],carry} = {A[7],A[7:0]};
                5'b01110: {carry,ALUOut[7:0]} = {A[7:0],FlagsOut[2]}; 
                5'b01111: {ALUOut[7:0],carry} = {FlagsOut[2],A[7:0]}; 
     
                5'b10000: ALUOut[15:0] = A[15:0];
                5'b10001: ALUOut[15:0] = B[15:0];
                5'b10010: ALUOut[15:0] = ~A[15:0];
                5'b10011: ALUOut[15:0] = ~B[15:0];
                5'b10100:{carry,ALUOut} = A+B; 
                5'b10101:{carry,ALUOut[15:0]} = A[15:0]+B[15:0]+FlagsOut[2];
                5'b10110:{carry,ALUOut[15:0]} = A-B;
                5'b10111:ALUOut[15:0] = A[15:0]&B[15:0];
                5'b11000:ALUOut[15:0] = A[15:0]|B[15:0];
                5'b11001:ALUOut[15:0] = A[15:0]^B[15:0];
                5'b11010:ALUOut[15:0] = ~(A[15:0]&B[15:0]);
                5'b11011:{carry,ALUOut[15:0]} = {A[15:0],1'b0}; 
                5'b11100:{ALUOut[15:0],carry} = {1'b0,A[15:0]};
                5'b11101:{ALUOut[15:0],carry} = {A[15],A[15:0]};
                5'b11110:{carry,ALUOut[15:0]} = {A[15:0],FlagsOut[2]}; 
                5'b11111:{ALUOut[15:0],carry} = {FlagsOut[2],A[15:0]};
                
                
            endcase
    end
    always @(posedge Clock)
    begin
        if(WF) 
        begin
            case(FunSel)
                5'b00000: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[7],FlagsOut[0]};
                5'b00001: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[7],FlagsOut[0]};
                5'b00010: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[7],FlagsOut[0]};
                5'b00011: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[7],FlagsOut[0]};
                5'b00100: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[7],(carry ^ (A[7] ^ B[7] ^ ALUOut[7]))};
                5'b00101: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[7],(carry  ^ (A[7] ^ B[7] ^ ALUOut[7]))};
                5'b00110: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[7],(carry  ^ (A[7] ^ B[7] ^ ALUOut[7]))};
                5'b00111: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[7],FlagsOut[0]};
                5'b01000: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[7],FlagsOut[0]};
                5'b01001: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[7],FlagsOut[0]};
                5'b01010: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[7],FlagsOut[0]};
                5'b01011: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[7],FlagsOut[0]};
                5'b01100: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[7],FlagsOut[0]};
                5'b01101: FlagsOut = {ALUOut==0?1:0,carry,FlagsOut[1],FlagsOut[0]};
                5'b01110: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[7],FlagsOut[0]};
                5'b01111: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[7],FlagsOut[0]};
                
                5'b10000: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[15],FlagsOut[0]};
                5'b10001: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[15],FlagsOut[0]};
                5'b10010: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[15],FlagsOut[0]};
                5'b10011: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[15],FlagsOut[0]};
                5'b10100: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[15],(carry  ^ (A[15] ^ B[15] ^ ALUOut[15]))};
                5'b10101: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[15],(carry  ^ (A[15] ^ B[15] ^ ALUOut[15]))};
                5'b10110: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[15],(carry  ^ (A[15] ^ B[15] ^ ALUOut[15]))};
                5'b10111: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[15],FlagsOut[0]};
                5'b11000: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[15],FlagsOut[0]};
                5'b11001: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[15],FlagsOut[0]};
                5'b11010: FlagsOut = {ALUOut==0?1:0,FlagsOut[2],ALUOut[15],FlagsOut[0]};
                5'b11011: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[15],FlagsOut[0]};
                5'b11100: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[15],FlagsOut[0]};
                5'b11101: FlagsOut = {ALUOut==0?1:0,carry,FlagsOut[1],FlagsOut[0]};
                5'b11110: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[15],FlagsOut[0]};
                5'b11111: FlagsOut = {ALUOut==0?1:0,carry,ALUOut[15],FlagsOut[0]};
            endcase
        end
    end

endmodule