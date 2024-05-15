`timescale 1ns / 1ps

module  ArithmeticLogicUnitSystem(
input [2:0] RF_OutASel,//
input [2:0] RF_OutBSel, //
input [2:0] RF_FunSel,    // 
input [3:0] RF_RegSel,//
input [3:0] RF_ScrSel,  //   
input [4:0] ALU_FunSel,//
input ALU_WF, //          
input [1:0] ARF_OutCSel,// 
input [1:0] ARF_OutDSel,//
input [2:0] ARF_FunSel,//
input [2:0] ARF_RegSel,//   
input IR_LH,//
input IR_Write,//      
input Mem_WR,//
input Mem_CS,//           
input [1:0] MuxASel,//
input [1:0] MuxBSel,//         
input MuxCSel,//
input Clock); 
    wire [15:0] OutC,OutA,OutB,ALUOut,Address,IROut;
    wire [7:0] MemOut;
    wire [3:0] Flags;
    reg [15:0] MuxBOut,MuxAOut;
    reg [7:0] MuxCOut;

    Memory MEM(.Address(Address), .Data(MuxCOut), .WR(Mem_WR), .CS(Mem_CS), .Clock(Clock), .MemOut(MemOut));
    
    AddressRegisterFile ARF(.I(MuxBOut), .OutCSel(ARF_OutCSel), .OutDSel(ARF_OutDSel), 
                        .FunSel(ARF_FunSel), .RegSel(ARF_RegSel), .Clock(Clock), 
                        .OutC(OutC), .OutD(Address));
    RegisterFile RF(.I(MuxAOut), .OutASel(RF_OutASel), .OutBSel(RF_OutBSel), 
                                            .FunSel(RF_FunSel), .RegSel(RF_RegSel), .ScrSel(RF_ScrSel), 
                                            .Clock(Clock), .OutA(OutA), .OutB(OutB));
                                            
    InstructionRegister IR(.I(MemOut), .Write(IR_Write), .LH(IR_LH), 
                           .Clock(Clock), .IROut(IROut));   
                           
     ArithmeticLogicUnit ALU( .A(OutA), .B(OutB), .FunSel(ALU_FunSel), .WF(ALU_WF), 
                                                      .Clock(Clock), .ALUOut(ALUOut), .FlagsOut(Flags));                               
   always @(*)
   begin
    case(MuxASel) 
        2'b00: MuxAOut = ALUOut;
        2'b01: MuxAOut = OutC;
        2'b10: MuxAOut = {{8{1'b0}},MemOut[7:0]};
        2'b11: MuxAOut = {{8{IROut[7]}},IROut[7:0]};
    endcase
    case(MuxBSel) 
        2'b00: MuxBOut = ALUOut;
        2'b01: MuxBOut = OutC;
        2'b10: MuxBOut = {{8{1'b0}},MemOut[7:0]};
        2'b11: MuxBOut = {{8{IROut[7]}},IROut[7:0]};
    endcase
    case(MuxCSel) 
        1'b0: MuxCOut = ALUOut[7:0];
        1'b1: MuxCOut = ALUOut[15:8];
    endcase
   end      
              
endmodule

