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

  
    Register PC(.I(I), .E(!RegSel[2]), .FunSel(FunSel), .Clock(Clock), .Q());
    Register AR(.I(I), .E(!RegSel[1]), .FunSel(FunSel), .Clock(Clock), .Q());
    Register SP(.I(I), .E(!RegSel[0]), .FunSel(FunSel), .Clock(Clock), .Q());
    
    always @(*)
    begin
        case(OutCSel)
        2'b00: OutC <= PC.Q;
        2'b01: OutC <= PC.Q;
        2'b10: OutC <= AR.Q;
        2'b11: OutC <= SP.Q;
        endcase
    end
    
    always @(*)
        begin
            case(OutDSel)
            2'b00: OutD <= PC.Q;
            2'b01: OutD <= PC.Q;
            2'b10: OutD <= AR.Q;
            2'b11: OutD <= SP.Q;
            endcase
        end

endmodule
