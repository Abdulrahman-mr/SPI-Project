module SPI_SLAVE (clk, rst_n, SS_n, MISO, MOSI, rx_valid, rx_data, tx_valid, tx_data);
/******************************************Signal Ports********************************************************/
   /******************************* States Parameter **********************************************/
    parameter IDLE = 3'b000;
    parameter CHK_CMD = 3'b001;
    parameter READ_ADD = 3'b010;
    parameter READ_DATA = 3'b011;
    parameter WRITE= 3'b100;

   /******************************* input_&_output ports**********************************************/
    input clk , rst_n , SS_n , MOSI , tx_valid  ;
    input [9:0] tx_data;
    output reg rx_valid , MISO ;
    output reg [9:0] rx_data ;

   /******************************* Internal Signals**********************************************/
    reg read_ready;
    reg [3:0] Counter;
    reg [9:0] data_reg;
    reg [2:0] current_state, next_state;

/******************************************State Memory********************************************************/
    always @(posedge clk) begin
        if (!rst_n) current_state <= IDLE;
        else current_state <= next_state;
    end
/******************************************Next State Logic****************************************************/ 
    always @(*) begin
        case (current_state)
            IDLE: next_state = (SS_n)? IDLE : CHK_CMD;
            CHK_CMD: next_state = (SS_n)? IDLE : (MOSI ==0)? WRITE: (read_ready)? READ_DATA : READ_ADD;                     
            READ_ADD:  next_state = (SS_n)? IDLE : READ_ADD;
            READ_DATA:  next_state = (SS_n)? IDLE : READ_DATA;
            WRITE: next_state = (SS_n)? IDLE : WRITE;
            default: next_state = IDLE;
        endcase
    end
/******************************************Output Logic********************************************************/       always @(posedge clk) begin
        if(!rst_n) begin
            MISO <= 0 ; rx_valid <= 0 ; rx_data <= 0 ; 
            read_ready <= 0 ; Counter <= 0 ; data_reg <= 0 ;
        end
        else begin
         case (current_state)
            IDLE : rx_valid <= 0 ;
  
            CHK_CMD : Counter <= 10 ;
  
            WRITE : begin 
                if (Counter > 0) begin
                  data_reg [Counter - 1] <= MOSI ;
                  Counter <= Counter -1 ;
                end   
                    else begin 
                      rx_valid <= 1 ;
                      rx_data <= data_reg ;      
                    end  
             end

            READ_ADD : begin 
                if (Counter > 0) begin
                  data_reg [Counter - 1] <= MOSI ;
                  Counter <= Counter -1 ;
                end   
                    else begin 
                      read_ready <= 1;
                      rx_valid <= 1 ;
                      rx_data <= data_reg ;      
                    end                     
                end    

            READ_DATA : begin 
                if (tx_valid == 1) begin
                    rx_valid <= 0 ;
                    if (Counter == 0) begin
                        read_ready <= 0 ;
                    end  
                    else begin
                            MISO <= tx_data [Counter-1] ;
                            Counter <= Counter - 1 ;      
                         end
                   end         
                else begin 
                 if (Counter > 0) begin
                  data_reg [Counter - 1] <= MOSI ;
                  Counter <= Counter -1 ;
                  end   
                      else begin
                        rx_valid <= 1 ;
                        rx_data <= data_reg ;  
                        Counter <= 10 ;                     
                         end  
                    end   
             end 
             endcase   
        end
 end           
endmodule