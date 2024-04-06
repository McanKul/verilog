`timescale 1ns / 1ps

module AddressRegisterFile(
input [15:0]I,
input [1:0] OutCSel,
input [1:0] OutDSel, 
input [2:0] FunSel,
input [2:0] RegSel,
input Clock, 
output reg [15:0] OutC,
output reg [15:0] OutD);
  wire [15:0] q1,q2,q3;
    Register PC(.I(I), .E(!RegSel[2]), .FunSel(FunSel), .Clock(Clock), .Q(q1));
    Register AR(.I(I), .E(!RegSel[1]), .FunSel(FunSel), .Clock(Clock), .Q(q2));
    Register SP(.I(I), .E(!RegSel[0]), .FunSel(FunSel), .Clock(Clock), .Q(q3));
    
    always @(*)
    begin
        case(OutCSel)
        2'b00: OutC <= q1;
        2'b01: OutC <= q1;
        2'b10: OutC <= q2;
        2'b11: OutC <= q3;
        endcase
    end
    
    always @(*)
        begin
            case(OutDSel)
            2'b00: OutD <= q1;
            2'b01: OutD <= q1;
            2'b10: OutD <= q2;
            2'b11: OutD <= q3;
            endcase
        end

endmodule
