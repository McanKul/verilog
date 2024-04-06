`timescale 1ns / 1ps

module Register(
    input [2:0] FunSel,
    input [15:0] I,
    input Clock,
    input E,
    output reg [15:0] Q
);
    always @(posedge Clock) begin
            if (E) begin
                case(FunSel)
                3'b000: Q <= Q - 1;
                3'b001: Q <= Q + 1;
                3'b010: Q <= I;
                3'b011: Q <= 16'd0;
                3'b100: Q[15:0] <= {{8{1'b0}},I[7:0]};
                3'b101: Q[7:0] <= I[7:0];
                3'b110: Q[15:8] <= I[15:8];
                3'b111: Q[15:0] <= {{8{I[7]}},I[7:0]};
                endcase
            end
        end
endmodule
    

    

