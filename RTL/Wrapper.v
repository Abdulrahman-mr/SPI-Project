
module Wrapper(clk , rst_n , SS_n , MISO , MOSI );

input clk , rst_n , SS_n , MOSI ;
output MISO ; 
wire rx_valid , tx_valid ;
wire [9:0] rx_data , tx_data ;

SPI_SLAVE DUT_SPI (.clk(clk) , .rst_n(rst_n) , .SS_n(SS_n) , .MISO(MISO) , .MOSI(MOSI) ,
                    .rx_valid(rx_valid) , .rx_data(rx_data) , .tx_valid(tx_valid) , .tx_data(tx_data));


RAM #(.MEM_DEPTH(256) , .ADDR_SIZE(8)) DUT_RAM (.clk(clk) , .rst_n(rst_n) , 
                    .rx_valid(rx_valid) , .din(rx_data) , .tx_valid(tx_valid) , .dout(tx_data));

    
endmodule