`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITU Computer Engineering Department
// Engineer: Kadir Ozlem
// Project Name: BLG222E Project 1 Simulation
//////////////////////////////////////////////////////////////////////////////////

module ArithmeticLogicUnitSimulation();
    reg[15:0] A, B;
    reg[4:0] FunSel;
    reg WF;
    wire[15:0] ALUOut;
    wire[3:0] FlagsOut;
    integer test_no;
    wire Z, C, N, O;
    CrystalOscillator clk();
    ArithmeticLogicUnit ALU( .A(A), .B(B), .FunSel(FunSel), .WF(WF), 
                            .Clock(clk.clock), .ALUOut(ALUOut), .FlagsOut(FlagsOut));
        
    FileOperation F();
    
    assign {Z,C,N,O} = FlagsOut;
    
    initial begin
        F.SimulationName ="ArithmeticLogicUnit";
        F.InitializeSimulation(0);
        clk.clock = 0;
        
        //Test 1
        test_no = 1;
        A = 16'h1234;
        B = 16'h4321;
        ALU.FlagsOut = 4'b1111;
        FunSel =5'b10100;
        WF =1;
        #5
        F.CheckValues(ALUOut,16'h5555, test_no, "ALUOut");
        F.CheckValues(Z,1, test_no, "Z");
        F.CheckValues(C,1, test_no, "C");
        F.CheckValues(N,1, test_no, "N");
        F.CheckValues(O,1, test_no, "O");
        //Test 2
        test_no = 2;
        clk.Clock();
        
        F.CheckValues(ALUOut,16'h5555, test_no, "ALUOut");
        F.CheckValues(Z,0, test_no, "Z");
        F.CheckValues(C,0, test_no, "C");
        F.CheckValues(N,0, test_no, "N");
        F.CheckValues(O,0, test_no, "O");

        //Test 3
        test_no = 3;
        A = 16'h7777;
        B = 16'h8889;
        ALU.FlagsOut = 4'b0000;
        FunSel =5'b10101;
        WF =1;
        #5
        clk.Clock();
        F.CheckValues(ALUOut,16'h0001, test_no, "ALUOut");
        F.CheckValues(Z,1, test_no, "Z");
        F.CheckValues(C,1, test_no, "C");
        F.CheckValues(N,0, test_no, "N");
        F.CheckValues(O,0, test_no, "O");
        
         //Test 4
               test_no = 4;
               A = 8'h77;
               B = 8'h89;
               ALU.FlagsOut = 4'b0000;
               FunSel =5'b00110;
               WF =1;
               #5
               clk.Clock();
               
               F.CheckValues(ALUOut,8'hee, test_no, "ALUOut");
               F.CheckValues(Z,0, test_no, "Z");
               F.CheckValues(C,1, test_no, "C");
               F.CheckValues(N,1, test_no, "N");
               F.CheckValues(O,1, test_no, "O");
//Test 5
                       test_no = 5;
                       A = 8'h77;
                       B = 16'h0;
                       ALU.FlagsOut = 4'b0000;
                       FunSel =5'b01111;
                       WF =1;
                       #5
                       clk.Clock();
                       F.CheckValues(ALUOut,8'hbb, test_no, "ALUOut");
                       F.CheckValues(Z,0, test_no, "Z");
                       F.CheckValues(C,1, test_no, "C");
                       F.CheckValues(N,0, test_no, "N");
                       F.CheckValues(O,0, test_no, "O");     
        test_no = 6;
        A = 16'h7777;
        B = 16'h8889;
        ALU.FlagsOut = 4'b0000;
        FunSel =5'b11111;
        WF =1;
        #5
        clk.Clock();
        F.CheckValues(ALUOut,16'hbbbb, test_no, "ALUOut");
        F.CheckValues(Z,0, test_no, "Z");
        F.CheckValues(C,1, test_no, "C");
        F.CheckValues(N,0, test_no, "N");
        F.CheckValues(O,0, test_no, "O");

        test_no = 7;
        A = 16'h7777;
        B = 16'h8889;
        ALU.FlagsOut = 4'b0000;
        FunSel =5'b11110;
        WF =1;
        #5
        clk.Clock();
        F.CheckValues(ALUOut,16'heeee, test_no, "ALUOut");
        F.CheckValues(Z,0, test_no, "Z");
        F.CheckValues(C,0, test_no, "C");
        F.CheckValues(N,1, test_no, "N");
        F.CheckValues(O,0, test_no, "O");
        
       test_no = 8;
       A = 16'h7777;
       B = 16'h8889;
       ALU.FlagsOut = 4'b0000;
       FunSel =5'b11101;
       WF =1;
       #5
       clk.Clock();
       F.CheckValues(ALUOut,16'h3bbb, test_no, "ALUOut");
       F.CheckValues(Z,0, test_no, "Z");
       F.CheckValues(C,1, test_no, "C");
       F.CheckValues(N,0, test_no, "N");
        F.CheckValues(O,0, test_no, "O");  
        
        test_no = 9;
       A = 16'h7777;
       B = 16'h8889;
       ALU.FlagsOut = 4'b0000;
       FunSel =5'b11011;
       WF =1;
       #5
       clk.Clock();
       F.CheckValues(ALUOut,16'heeee, test_no, "ALUOut");
       F.CheckValues(Z,0, test_no, "Z");
       F.CheckValues(C,0, test_no, "C");
       F.CheckValues(N,1, test_no, "N");
        F.CheckValues(O,0, test_no, "O");
       
        test_no = 10;
       A = 16'h7777;
       B = 16'h8889;
       ALU.FlagsOut = 4'b0000;
       FunSel =5'b11100;
       WF =1;
       #5
       clk.Clock();
       F.CheckValues(ALUOut,16'h3bbb, test_no, "ALUOut");
       F.CheckValues(Z,0, test_no, "Z");
       F.CheckValues(C,1, test_no, "C");
       F.CheckValues(N,0, test_no, "N");
F.CheckValues(O,0, test_no, "O");
 test_no = 11;
      A = 16'h49af;
      B = 16'h257c;
      ALU.FlagsOut = 4'b1111;
      FunSel =5'b10101;
      WF =1;
      #5
      
      F.CheckValues(ALUOut,16'h6f2c, test_no, "ALUOut");
      clk.Clock();
      F.CheckValues(Z,0, test_no, "Z");
      F.CheckValues(C,0, test_no, "C");
      F.CheckValues(N,0, test_no, "N");
F.CheckValues(O,0, test_no, "O");
test_no = 12;
      A = 16'h49af;
      B = 16'h257c;
      ALU.FlagsOut = 4'b1111;
      FunSel =5'b10110;
      WF =1;
      #5
      clk.Clock();
      F.CheckValues(ALUOut,16'h2433, test_no, "ALUOut");
      F.CheckValues(Z,0, test_no, "Z");
      F.CheckValues(C,0, test_no, "C");
      F.CheckValues(N,0, test_no, "N");
F.CheckValues(O,0, test_no, "O");
test_no = 13;
      A = 16'hffff;
      B = 16'hffff;
      ALU.FlagsOut = 4'b1111;
      FunSel =5'b10110;
      WF =1;
      #5
      clk.Clock();
      F.CheckValues(ALUOut,16'h0, test_no, "ALUOut");
      F.CheckValues(Z,1, test_no, "Z");
      F.CheckValues(C,0, test_no, "C");
      F.CheckValues(N,0, test_no, "N");
        F.CheckValues(O,0, test_no, "O"); 
test_no = 14;
              A = 8'haf;
              B = 8'h7c;
              ALU.FlagsOut = 4'b1111;
              FunSel =5'b01010;
              WF =1;
              #5
              clk.Clock();
              F.CheckValues(ALUOut,8'hd3, test_no, "ALUOut");
              F.CheckValues(Z,0, test_no, "Z");
              F.CheckValues(C,1, test_no, "C");
              F.CheckValues(N,1, test_no, "N");
F.CheckValues(O,1, test_no, "O"); 
test_no = 15;
              A = 16'h49af;
              B = 16'h257c;
              ALU.FlagsOut = 4'b1111;
              FunSel =5'b10010;
              WF =1;
              #5
              clk.Clock();
              F.CheckValues(ALUOut,16'hb650, test_no, "ALUOut");
              F.CheckValues(Z,0, test_no, "Z");
              F.CheckValues(C,1, test_no, "C");
              F.CheckValues(N,1, test_no, "N");
F.CheckValues(O,1, test_no, "O");
test_no = 16;
              A = 8'hbc;
              B =8'h00;
              ALU.FlagsOut = 4'b1111;
              FunSel =5'b01111;
              WF =1;
              #5
              clk.Clock();
              F.CheckValues(ALUOut[7:0],16'h5e, test_no, "ALUOut");
              F.CheckValues(Z,0, test_no, "Z");
              F.CheckValues(C,0, test_no, "C");
              F.CheckValues(N,1, test_no, "N");
F.CheckValues(O,1, test_no, "O"); 

test_no = 17;
              A = 8'h77;
              B =8'h00;
              ALU.FlagsOut = 4'b1111;
              FunSel =5'b01101;
              WF =1;
              #5
              clk.Clock();
              F.CheckValues(ALUOut[7:0],16'h3b, test_no, "ALUOut");
              F.CheckValues(Z,0, test_no, "Z");
              F.CheckValues(C,1, test_no, "C");
              F.CheckValues(N,1, test_no, "N");
F.CheckValues(O,1, test_no, "O"); 
      
test_no = 18;
              A = 8'hbc;
              B =8'h00;
              ALU.FlagsOut = 4'b1111;
              FunSel =5'b01110;
              WF =1;
              #5
              clk.Clock();
              F.CheckValues(ALUOut[7:0],16'h79, test_no, "ALUOut");
              F.CheckValues(Z,0, test_no, "Z");
              F.CheckValues(C,1, test_no, "C");
              F.CheckValues(N,0, test_no, "N");
F.CheckValues(O,1, test_no, "O"); 
test_no = 19;
              A = 8'hbc;
              B =8'h00;
              ALU.FlagsOut = 4'b1010;
              FunSel =5'b01011;
              WF =1;
              #5
              clk.Clock();
              F.CheckValues(ALUOut[7:0],16'h78, test_no, "ALUOut");
              F.CheckValues(Z,0, test_no, "Z");
              F.CheckValues(C,1, test_no, "C");
              F.CheckValues(N,0, test_no, "N");
F.CheckValues(O,0, test_no, "O"); 

test_no = 20;
              A = 16'h1111;
              B =16'h8888;
              ALU.FlagsOut = 4'b1010;
              FunSel =5'b10110;
              WF =1;
              #5
              clk.Clock();
              F.CheckValues(ALUOut,16'h8889, test_no, "ALUOut");
              F.CheckValues(Z,0, test_no, "Z");
              F.CheckValues(C,1, test_no, "C");
              F.CheckValues(N,1, test_no, "N");
F.CheckValues(O,1, test_no, "O");
         
        F.FinishSimulation();
    end
endmodule