`timescale 1ns / 1ps

module CPUSystem (
input Clock,
input Reset,
output reg [7:0] T 
);

reg [2:0] RF_OutASel;
reg [2:0] RF_OutBSel; 
reg [2:0] RF_FunSel;    
reg [3:0] RF_RegSel;
reg [3:0] RF_ScrSel;     
reg [4:0] ALU_FunSel;
reg ALU_WF;           
reg [1:0] ARF_OutCSel;
reg [1:0] ARF_OutDSel;
reg [2:0] ARF_FunSel;
reg [2:0] ARF_RegSel;
reg IR_LH;
reg IR_Write;
reg Mem_WR;
reg Mem_CS;         
reg [1:0] MuxASel;
reg[1:0] MuxBSel;       
reg MuxCSel;

ArithmeticLogicUnitSystem _ALUSystem(
.RF_OutASel(RF_OutASel),//
.RF_OutBSel(RF_OutBSel), //
.RF_FunSel(RF_FunSel),    // 
.RF_RegSel(RF_RegSel),//
.RF_ScrSel(RF_ScrSel),  //   
.ALU_FunSel(ALU_FunSel),
.ALU_WF(ALU_WF),
.ARF_OutCSel(ARF_OutCSel),// 
.ARF_OutDSel(ARF_OutDSel),//
.ARF_FunSel(ARF_FunSel),//
.ARF_RegSel(ARF_RegSel),//   
.IR_LH(IR_LH),//
.IR_Write(IR_Write),//      
.Mem_WR(Mem_WR),//
.Mem_CS(Mem_CS),//           
.MuxASel(MuxASel),//
.MuxBSel(MuxBSel),//         
.MuxCSel(MuxCSel),//
.Clock(Clock)
);
reg S;
reg [2:0] DSTREG,SREG1,SREG2;
reg [5:0] decoding;
reg [63:0] D;
reg [2:0] RSEL;
reg [7:0] ADDRESS;
reg xd;
always @( posedge Clock) 
    begin  
        if(!T[7])begin
         T <= T * 2;
         end
         if(T[7])begin
              T <= 8'h01;
         end
   end
   
 always @(*) 
       begin  
           if(Reset)begin
            T <= 8'd1;
            _ALUSystem.RF.R1.Q <= 16'd10;
            _ALUSystem.RF.R2.Q <= 16'd0;
            _ALUSystem.RF.R3.Q <= 16'd0;
            _ALUSystem.RF.R4.Q <= 16'd0;
            _ALUSystem.RF.S1.Q <= 16'd0;
            _ALUSystem.RF.S2.Q <= 16'd0;
            _ALUSystem.RF.S3.Q <= 16'd0;
            _ALUSystem.RF.S4.Q <= 16'd0;
            _ALUSystem.ARF.PC.Q <= 16'd0;
            _ALUSystem.IR.Q <= 16'd0;
            ALU_WF = 1'b0;
            end            
      end
              
always @(posedge Clock) begin    
     if(xd) begin
     
      T <= 8'd1;
      _ALUSystem.RF.S1.Q <= 16'd0;
      _ALUSystem.RF.S2.Q <= 16'd0;
      _ALUSystem.RF.S3.Q <= 16'd0;
      _ALUSystem.RF.S4.Q <= 16'd0;
      
      RF_RegSel <= 4'b1111;
      RF_ScrSel  <= 4'b1111;     
      ALU_WF <= 1'b0;           
      ARF_RegSel <= 3'b111;
      IR_Write <= 1'b0;
      Mem_CS <= 1'b1;
      xd = 1'b0;
      
  end
  end
    
always @ (posedge T[0])
    begin
        ARF_OutDSel = 2'b00;
       
        Mem_WR = 0;
        Mem_CS = 0;
         
        IR_LH = 1'b0;
        IR_Write = 1'b1;
        
        ARF_RegSel = 3'b011;
        ARF_FunSel = 3'b001;
        //alu ayarla
        ALU_FunSel = 5'b10100;
        RF_OutBSel = 3'b101;
        RF_OutASel = 3'b100;

    end 
    
always @ (posedge T[1])
        begin
        
            //pc yi bir arttýr
            ARF_RegSel = 3'b011;
            ARF_FunSel = 3'b001;
            ARF_OutDSel = 2'b00;
            
            //memory ayarla
            IR_LH = 1'b1;
            IR_Write = 1'b1;
                      
        end 
        
always @ (posedge T[2]) begin 

            D = 64'd0;                  
            ARF_RegSel = 3'b111;
            IR_Write = 1'b0;
            D[_ALUSystem.IR.IROut[15:10]] = 1'b1;
            
            if(D[16:5]==13'd0 || D[29:21]==10'd0) begin
                {ALU_WF,DSTREG,SREG1,SREG2} = _ALUSystem.IR.IROut[9:0];
            end else begin
                {RSEL,ADDRESS} = _ALUSystem.IR.IROut[9:0];
            end
            
            if(D[2:0] != 3'd0) begin

                RF_ScrSel = 4'b0111; 
                MuxASel = 2'b11;
                RF_FunSel = 3'b010;
                
            //pop   
            end else if(D[3] == 1'b1) begin
                ARF_OutDSel = 2'b11;
                Mem_WR = 1'b0;
                MuxASel = 2'b10;
                RF_FunSel = 3'b101;
                case (RSEL)
                    2'b00: RF_RegSel = 4'b0111;
                    2'b01: RF_RegSel = 4'b1011;
                    2'b10: RF_RegSel = 4'b1101;
                    2'b11: RF_RegSel = 4'b1110;
                endcase
                ARF_RegSel = 3'b110;
                ARF_FunSel = 3'b001;
                //psh
            end else if(D[4] == 1'b1) begin
                ARF_OutDSel = 2'b11;
                Mem_WR = 1'b1;
                ALU_FunSel = 5'b10000;
                case (RSEL)
                     2'b00: RF_OutASel = 3'b000;
                     2'b01: RF_OutASel = 3'b001;
                     2'b10: RF_OutASel = 3'b010;
                     2'b11: RF_OutASel = 3'b011;
               endcase
               MuxCSel = 1'b1;
               ARF_RegSel = 3'b110;
               ARF_FunSel = 3'b000;
               
               //dec and inc and movs 
            end else if((D[6:5] != 0)||D[18]) begin
                ALU_FunSel = 5'b10000;
                if(D[18]==1) ALU_WF = 1'b1;
                case(SREG1)
                    3'b000: ARF_OutDSel = 2'b00;
                    3'b001: ARF_OutDSel = 2'b01;
                    3'b010: ARF_OutDSel = 2'b10;
                    3'b011: ARF_OutDSel = 2'b11;
                    3'b100: RF_OutASel = 3'b000;
                    3'b100: RF_OutASel = 3'b001;
                    3'b100: RF_OutASel = 3'b010;
                    3'b100: RF_OutASel = 3'b011;
                endcase
                case(DSTREG)
                    3'b000: ARF_RegSel = 3'b011;
                    3'b001: ARF_RegSel = 3'b011;
                    3'b010: ARF_RegSel = 3'b101;
                    3'b011: ARF_RegSel = 3'b110;
                    3'b100: RF_RegSel = 4'b0111;
                    3'b101: RF_RegSel = 4'b1011;
                    3'b110: RF_RegSel = 4'b1101;
                    3'b111: RF_RegSel = 4'b1110;
                endcase
                if(DSTREG<4 && SREG1<4) begin
                    MuxBSel = 2'b01;
                    ARF_FunSel = 3'b010;
                end else if(DSTREG<4 && SREG1>3) begin
                    MuxBSel = 2'b00;
                    ARF_FunSel = 3'b010;
                end else if(DSTREG>3 && SREG1<4) begin
                    MuxASel = 2'b01;
                    RF_FunSel = 3'b010;
                end else begin
                    MuxASel = 2'b00;
                    RF_FunSel = 3'b010;
                end
                if(D[18]) begin
                    xd = 1'b1;
                end
                
                
            end else if((D[11:7]!=0)||D[14])begin
                 RF_ScrSel = 4'b0111;
                 RF_FunSel = 3'b010;
                 ALU_FunSel = 5'b10000;
                 case(SREG1)
                       3'b000: ARF_OutDSel = 2'b00;
                       3'b001: ARF_OutDSel = 2'b01;
                       3'b010: ARF_OutDSel = 2'b10;
                       3'b011: ARF_OutDSel = 2'b11;
                       3'b100: RF_OutASel = 3'b000;
                       3'b101: RF_OutASel = 3'b001;
                       3'b110: RF_OutASel = 3'b010;
                       3'b111: RF_OutASel = 3'b011;
                  endcase
                  case(SREG1<4)
                    1'b1: MuxASel = 2'b01;
                    1'b0: MuxASel = 2'b00;
                  endcase  
                  
                  //2 li sourcelilar
            end else if((D[13:12] !=0)&&(D[16:15] !=0) && (D[29:25] !=0) &&(D[23:21!=0]))begin
                  RF_ScrSel = 4'b0111;
                  RF_FunSel = 3'b010;
                  ALU_FunSel = 5'b10000;
                  if((D[29:25] !=0) &&(D[23:21!=0]))
                  begin 
                    ALU_WF = 1'B1;
                  end
                  case(SREG1)
                      3'b000: ARF_OutDSel = 2'b00;
                      3'b001: ARF_OutDSel = 2'b01;
                      3'b010: ARF_OutDSel = 2'b10;
                      3'b011: ARF_OutDSel = 2'b11;
                      3'b100: RF_OutASel = 3'b000;
                      3'b101: RF_OutASel = 3'b001;
                      3'b110: RF_OutASel = 3'b010;
                      3'b111: RF_OutASel = 3'b011;
                   endcase
                   case(SREG1<4)
                        1'b1: MuxASel = 2'b01;
                        1'b0: MuxASel = 2'b00;
                   endcase
                   
                   
            end else if(D[17] && D[20]) begin
                if(D[20] ==1 )begin
                      RF_FunSel = 3'b101;
                end else if (D[17] ==1) begin
                      RF_FunSel = 3'b101;
                end
                MuxASel = 2'b11;
                case (RSEL)
                    2'b00: RF_RegSel = 4'b0111;
                    2'b01: RF_RegSel = 4'b1011;
                    2'b10: RF_RegSel = 4'b1101;
                    2'b11: RF_RegSel = 4'b1110;
                 endcase 
                 xd = 1'b1;
                 
                 
            end else if(D[18]) begin
                Mem_CS = 0;
                Mem_WR = 0;
                ARF_OutDSel = 2'b10;
                ARF_FunSel = 3'b001;
                ARF_RegSel = 3'b101;
                MuxASel = 2'b11;
                case (RSEL)
                      2'b00: RF_RegSel = 4'b0111;
                      2'b01: RF_RegSel = 4'b1011;
                      2'b10: RF_RegSel = 4'b1101;
                      2'b11: RF_RegSel = 4'b1110;
                endcase
                RF_FunSel = 3'b101;
                
                
            end else if(D[19]) begin
                Mem_CS = 1'b0;
                Mem_WR = 1'b1;
                ALU_FunSel = 5'b10000;
                case (RSEL)
                     2'b00: RF_OutASel = 3'b000;
                     2'b01: RF_OutASel = 3'b001;
                     2'b10: RF_OutASel = 3'b010;
                     2'b11: RF_OutASel = 3'b011;
                 endcase
                 MuxCSel = 1'b0;
                 ARF_OutDSel = 2'b10;
                 ARF_RegSel = 3'b101;
                 ARF_FunSel = 3'b001;
                 
                 
            end else if(D[30] == 1) begin
                Mem_CS = 1'b0;
                Mem_WR = 1'b1;
                ALU_FunSel = 5'b10000;
                ARF_OutDSel = 2'b11;
                ARF_OutCSel = 2'b00;
                ARF_RegSel = 3'b110;
                ARF_FunSel = 3'b001;
                MuxASel = 2'b01;
                RF_ScrSel = 4'b0111;
                RF_FunSel = 3'b010;
                RF_OutASel = 3'b100;
                MuxCSel = 1'b0; 
            end
            
        end

 
 
 
 
 
          
always @ (posedge T[3])
   begin 
       
       if(D[2:0]!=3'd0)
       begin
            ARF_OutCSel = 2'b00;
            RF_ScrSel = 4'b1011;
            MuxASel = 2'b01;
            
       end else if(D[3] == 1'b1) begin
           RF_FunSel = 3'b110;
           ARF_RegSel = 3'b111;
           ARF_FunSel = 3'b001;
           xd = 1'b1;
           
        end else if(D[4] == 1'b1) begin
            MuxCSel = 1'b1;
            xd = 1'b1;
            
        end else if(D[6:5] != 0) begin
            if(DSTREG<4 && D[5]) begin
                ARF_FunSel = 3'b001;
            end else if(DSTREG<4 && D[6]) begin
                ARF_FunSel = 3'b000;
            end else if(DSTREG>3 && D[5]) begin
                RF_FunSel = 3'b001;
            end else begin 
                RF_FunSel = 3'b000;
            end
            xd = 1'b1;
            
            
        end else if((D[11:7]!=0)||D[14])begin
            RF_ScrSel = 4'b1111;
            RF_OutASel = 3'b100;
            case(DSTREG)
                 3'b000: ARF_RegSel = 3'b011;
                 3'b001: ARF_RegSel = 3'b011;
                 3'b010: ARF_RegSel = 3'b101;
                 3'b011: ARF_RegSel = 3'b110;
                 3'b100: RF_RegSel = 4'b0111;
                 3'b101: RF_RegSel = 4'b1011;
                 3'b110: RF_RegSel = 4'b1101;
                 3'b111: RF_RegSel = 4'b1110;
             endcase
             case(DSTREG<4)
                  1'b1:begin
                   MuxBSel = 2'b00;
                   ARF_FunSel = 3'b010;
                   end
                  1'b0:begin
                   MuxASel = 2'b00;
                   RF_FunSel = 3'b010;
                   end
             endcase
             case ({D[14],D[11:7]})
                    6'b000001: ALU_FunSel = 5'b11011;
                    6'b000010: ALU_FunSel = 5'b11100;
                    6'b000100: ALU_FunSel = 5'b11101;
                    6'b001000: ALU_FunSel = 5'b11110;
                    6'b010000: ALU_FunSel = 5'b11111;
                    6'b100000: ALU_FunSel = 5'b10010;
              endcase
              xd = 1'b1;
              
              
        end else if((D[13:12] !=0)&&(D[16:15] !=0) && (D[29:25] !=0) &&(D[23:21!=0]))begin
           
            RF_ScrSel = 4'b1011;
            RF_FunSel = 3'b010;           
            ALU_FunSel = 5'b10000;
            case(SREG2)
                3'b000: ARF_OutDSel = 2'b00;
                3'b001: ARF_OutDSel = 2'b01;
                3'b010: ARF_OutDSel = 2'b10;
                3'b011: ARF_OutDSel = 2'b11;
                3'b100: RF_OutASel = 3'b000;
                3'b100: RF_OutASel = 3'b001;
                3'b100: RF_OutASel = 3'b010;
                3'b100: RF_OutASel = 3'b011;
             endcase
             case(SREG2<4)
                   1'b1: MuxASel = 2'b01;
                   1'b0: MuxASel = 2'b00;
             endcase
             
        end else if(D[18]) begin
               ARF_FunSel = 3'b000;
               RF_FunSel = 3'b110;
               xd = 1'b1;
               
        end else if(D[19]) begin
            MuxCSel = 1'b1;
            ARF_FunSel = 3'b000;
            xd = 1'b1;
            
        end else if(D[30] == 1) begin
              ARF_FunSel = 3'b000;
              MuxCSel = 1'b1;
        end
   end
   
   
   
   
   
   
   
   
always @ (posedge T[4])
      begin 
         if(D[2:0]!=3'd0)
            begin                   
              ARF_FunSel = 3'b010;
              ARF_RegSel = 3'b011;
              MuxBSel = 2'b00;
              RF_ScrSel = 4'b1111;
              xd = 1'b1;
              
            end else if((D[13:12] !=0)&&(D[16:15] !=0) && (D[29:25] !=0) &&(D[23:21!=0]))begin
                RF_OutASel = 3'b100;
                RF_OutBSel = 3'b101;
                
                 case({D[29:25],D[23:21],D[16:15],D[13:12]})
                    12'b000000000001: ALU_FunSel = 5'b10111;
                    12'b000000000010: ALU_FunSel = 5'b11000;
                    12'b000000000100: ALU_FunSel = 5'b11001;
                    12'b000000001000: ALU_FunSel = 5'b11010;
                    12'b000000010000: ALU_FunSel = 5'b10100;
                    12'b000000100000: ALU_FunSel = 5'b10101;
                    12'b000001000000: ALU_FunSel = 5'b10110;
                    12'b000010000000: ALU_FunSel = 5'b10100;
                    12'b000100000000: ALU_FunSel = 5'b10110;
                    12'b001000000000: ALU_FunSel = 5'b10111;
                    12'b010000000000: ALU_FunSel = 5'b11000;
                    12'b100000000000: ALU_FunSel = 5'b11001;
                endcase
                case(DSTREG<4)
                    1'b1:begin
                    MuxBSel = 2'b00;
                    ARF_FunSel = 3'b010;
                    end
                    1'b0:begin
                    MuxASel = 2'b00;
                    RF_FunSel = 3'b010;
                    end
                endcase
                xd = 1'b1;
                
            end else if(D[30] == 1) begin
                Mem_CS = 1'b1;
                ARF_RegSel = 3'b011;
                case (RSEL)
                       2'b00: RF_OutASel = 3'b000;
                       2'b01: RF_OutASel = 3'b001;
                       2'b10: RF_OutASel = 3'b010;
                       2'b11: RF_OutASel = 3'b011;
                endcase
                MuxBSel = 2'b00;
                ARF_FunSel = 3'b010;
                xd = 1'b1;
            end
      end        
endmodule



