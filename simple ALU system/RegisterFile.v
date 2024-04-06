`timescale 1ns / 1ps

module RegisterFile (
input [15:0] I,
input [2:0] OutASel,
input [2:0] OutBSel,
input [2:0] FunSel,
input [3:0] RegSel,
input [3:0] ScrSel, 
input Clock,
output reg [15:0] OutA,
output reg [15:0] OutB);
    wire [15:0] Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8;
    Register R1(.I(I), .E(!RegSel[3]), .FunSel(FunSel), .Clock(Clock), .Q(Q1));
    Register R2(.I(I), .E(!RegSel[2]), .FunSel(FunSel), .Clock(Clock), .Q(Q2));
    Register R3(.I(I), .E(!RegSel[1]), .FunSel(FunSel), .Clock(Clock), .Q(Q3));
    Register R4(.I(I), .E(!RegSel[0]), .FunSel(FunSel), .Clock(Clock), .Q(Q4));
    
    Register S1(.I(I), .E(!ScrSel[3]), .FunSel(FunSel), .Clock(Clock), .Q(Q5));
    Register S2(.I(I), .E(!ScrSel[2]), .FunSel(FunSel), .Clock(Clock), .Q(Q6));
    Register S3(.I(I), .E(!ScrSel[1]), .FunSel(FunSel), .Clock(Clock), .Q(Q7));
    Register S4(.I(I), .E(!ScrSel[0]), .FunSel(FunSel), .Clock(Clock), .Q(Q8));

    always @(*) 
        begin
        OutA = 16'b0;
            case(OutASel)
                3'b000: OutA = Q1;
                3'b001: OutA = Q2;
                3'b010: OutA = Q3;
                3'b011: OutA = Q4;
                3'b100: OutA = Q5;
                3'b101: OutA = Q6;
                3'b110: OutA = Q7;
                3'b111: OutA = Q8;
            endcase
        end     
    always @(*) 

                begin
                    OutB = 16'b0;
                    case(OutBSel)
                        3'b000: OutB = Q1;
                        3'b001: OutB = Q2;
                        3'b010: OutB = Q3;
                        3'b011: OutB = Q4;
                        3'b100: OutB = Q5;
                        3'b101: OutB = Q6;
                        3'b110: OutB = Q7;
                        3'b111: OutB = Q8;
                    endcase
                end                
endmodule