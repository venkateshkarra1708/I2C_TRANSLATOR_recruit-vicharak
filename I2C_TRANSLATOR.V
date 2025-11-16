module i2c_translator(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [6:0] addr,
    inout wire sd_m,
    inout wire sc_m,
    inout wire sd_t,
    output wire sc_t,
    output reg RW_indicator, //for understanding only
    output reg match_indicator, // for umderstanding only
    output reg start,//  
    output reg [2:0]state,//
    output reg rising,//
    output reg [7:0] add_reg,//
    output reg [2:0] counter,//
    output reg [6:0]r_add,//
    output reg stop//
    );
    
    reg sd_m_dr;
    reg sd_t_dr;
    reg sc_t_dr;
    reg sc_m_dr;
    reg match;
    reg ack;
    reg bridge;
    
    assign sd_m = sd_m_dr ? 1'b0:1'bz;
    assign sc_m = sc_m_dr ? 1'b0:1'bz;
    always@(negedge sd_m)
    begin
    if(sc_m)
    begin
    start <= 1'b1;
    stop <= 1'b0;
    end
    end
    always@(posedge sd_m)
    begin
    if(sc_m)
    begin
    start <= 1'b0;
    stop <= 1'b1;
    end
    end
    always@(posedge sc_m)
    begin
    rising <= 1'b1;
    end
    
    
    parameter  IDLE = 3'b000,
               ADDR = 3'b001,
               DETE = 3'b010,
               PASS = 3'b011,
               R_BRIDGE = 3'b100,
               W_BRIDGE = 3'b101;
    always@(posedge clk)
    if (stop == 1)
    begin
    counter   <= 3'b111;
    add_reg <= 8'b00000000;
    match   <= 1'b0;
    bridge  <= 1'b0;
    rising  <= 1'b0;
    state   <= IDLE;
    end
               
               
    always@(posedge clk)
    begin
    if (rst ==1)
        begin
            sd_m_dr <= 1'b0;
            sc_m_dr <= 1'b0;
            sd_t_dr <= 1'b0;
            sc_m_dr <= 1'b0;
            counter   <= 3'b111;
            add_reg <= 8'b00000000;
            match   <= 1'b0;
            bridge  <= 1'b0;
            rising  <= 1'b0;
            state   <= IDLE;
         end
    else
        begin
            case(state)
                IDLE:
                    if (start==1)
                        begin
                        add_reg <= 8'b00000000;
                        counter <= 3'b111;
                        state <= ADDR;
                        end
                    else
                        state <= state;
                
                ADDR:
                    if(rising==1)
                        begin
                            add_reg[counter]<=sd_m;
                            counter <= counter-1;
                            if (counter == 0)
                            begin
                            counter <= 7;
                            r_add[6:0] <= add_reg [7:1];
                            state <= DETE;
                            end
                            else
                            state<=ADDR;
                        end
                  
           
                
                DETE:
                   if (addr == r_add)
                   begin
                       match <= 1'b1;
                       match_indicator <= 1'b1;
                       ack <= 1'b1;
                       bridge <= 1'b1;
                       sc_t_dr <= sc_m_dr;
                            
                                if (add_reg[0] == 1)
                                begin
                                    state <= R_BRIDGE;
                                    RW_indicator <= 1'b1;
                                end
                                else 
                                    begin
                                    state <= W_BRIDGE;
                                    RW_indicator <= 1'b0;
                                    end
                        end
                        else
                            begin
                            match <= 1'b0;
                            ack <= 1'b0;
                            bridge <= 1'b0;
                            state <= PASS;
                            end
             
                    
                PASS:
                begin
                    if(stop)
                        state <= IDLE;
                    if(start)
                        begin
                        state <= IDLE;
                        counter <= 3'b111;
                        end
                end
                
                R_BRIDGE:
                begin
                    if(stop)
                        begin
                        bridge <= 1'b0;
                        state <= IDLE;
                        end
                end
                
                W_BRIDGE:
                begin
                    if(stop)
                    begin
                    bridge <= 1'b0;
                    state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
                
            endcase
        end
    end            
                
reg ack_indicator;
reg [2:0] ack_timer;

always@(posedge clk)
begin
    if (rst)
        begin
            ack_indicator <= 1'b0;
            ack_timer <= 3'b000;
            sd_m_dr <= 1'b0;
        end
    else
        begin
            if(ack)
                begin
                    ack_indicator <= 1'b1;
                    ack_timer <= 3'b000;
                    sd_m_dr <= 1'b1;
                end
        end
    if (ack_indicator)
        begin
           ack_timer <= ack_timer + 1;
            if (ack_timer == 3'b111)
                begin
                    sd_m_dr <= 1'b0;
                    ack_indicator <= 1'b0;
                    ack <= 1'b0;
                end
        end 
end
    
    
endmodule
