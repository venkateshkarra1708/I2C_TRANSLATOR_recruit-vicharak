module tb;
 reg clk,rst,en;
 reg [6:0] addr;
 reg sd_m_dr;
 reg sc_m_dr;
 wire RW_indicator;
 wire match_indicator;
 wire start;
 wire [2:0]state;
 wire sd_m,sd_t,sc_m,sc_t;
 wire rising;
 wire [7:0] add_reg;
 wire [2:0] counter;
 wire [6:0] r_add;
 wire stop;
 

 
 i2c_translator dut (.clk(clk), .rst(rst), .addr(addr), .sd_m(sd_m), .stop(stop),
                     .sd_t(sd_t), .sc_t(sc_t), .sc_m(sc_m), .RW_indicator(RW_indicator),
                     .match_indicator(match_indicator), .start(start), .r_add(r_add),
                     .state(state), .rising(rising), .add_reg(add_reg), .counter(counter));
                         
 initial
 begin 
 clk=1;
 forever #5 clk=~clk;
 end
 pullup(sd_m);
 pullup(sd_t);
 pullup(sc_m);
 pullup(sc_t);
 assign sd_m = sd_m_dr ? 1'b0:1'bz;
 assign sc_m = sc_m_dr ? 1'b0:1'bz;
 initial begin
     rst = 1;
     en = 0;
     addr = 7'b1001001;
     sd_m_dr = 0;
     sc_m_dr = 0;
     #10;
     rst = 0;
     en = 1;
     #380;
     end
     
     initial 
     begin
     
     
     sd_m_dr =0;//1
     #15;//1st start
     sd_m_dr =1;//2
     #30;
     sd_m_dr =0;//3
     #10;
     sd_m_dr =1;//4
     #20;
     sd_m_dr =0;//5
     #10;
     sd_m_dr =1;//6
     #20;
     sd_m_dr =0;//7
     #20;
     sd_m_dr =1;//8
     #10;
     sd_m_dr =0;
     #120;
     sd_m_dr =1;//2
     #25;
     sd_m_dr =0;//3
     #10;
     sd_m_dr =1;//4
     #20;
     sd_m_dr =0;//5
     #10;
     sd_m_dr =1;//6
     #30;
     sd_m_dr =0;//7
     #10;
     sd_m_dr =1;//8
     #10;
     sd_m_dr =0;
     #10;//1st stop  
    $finish;
     end
     
     
     initial
     begin
     sc_m_dr = 0;//1
     #20;
     sc_m_dr =1;//2
     #20;
     sc_m_dr =0;//3
     #5;
     sc_m_dr =1;//4
     #5;
     sc_m_dr =0;//5
     #5;
     sc_m_dr =1;//6
     #5;     
     sc_m_dr =0;//7
     #5;
     sc_m_dr =1;//8
     #5;     
     sc_m_dr =0;//9
     #5;
     sc_m_dr =1;//10
     #5;     
     sc_m_dr =0;//11
     #5;
     sc_m_dr =1;//12
     #5;     
     sc_m_dr =0;//13
     #5;
     sc_m_dr =1;//14
     #5;     
     sc_m_dr =0;//15
     #5;
     sc_m_dr =1;//16
     #5;     
     sc_m_dr =0;//17
     #5;
     sc_m_dr =1;//18
     #5;  
     sc_m_dr =0;//17
     #5;
     sc_m_dr =1;//18
     #5;   
     sc_m_dr =0;//19
     #135;
     sc_m_dr =1;//2
     #20;
     sc_m_dr =0;//3
     #5;
     sc_m_dr =1;//4
     #5;
     sc_m_dr =0;//5
     #5;
     sc_m_dr =1;//6
     #5;     
     sc_m_dr =0;//7
     #5;
     sc_m_dr =1;//8
     #5;     
     sc_m_dr =0;//9
     #5;
     sc_m_dr =1;//10
     #5;     
     sc_m_dr =0;//11
     #5;
     sc_m_dr =1;//12
     #5;     
     sc_m_dr =0;//13
     #5;
     sc_m_dr =1;//14
     #5;     
     sc_m_dr =0;//15
     #5;
     sc_m_dr =1;//16
     #5;     
     sc_m_dr =0;//17
     #5;
     sc_m_dr =1;//18
     #5;  

     sc_m_dr =0;//19
     #20;
     
     end
endmodule
