module RAM(
    input clk, rst,
    input [9:0] din,
    input rx_valid,
    output reg [9:0] dout,
    output reg tx_valid
);
    parameter MEM_DEPTH = 256, ADDR_SIZE = 8;
    reg [7:0] mem [0:MEM_DEPTH-1];
    reg [ADDR_SIZE-1:0] wr_addr, rd_addr;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            dout<=0;
            tx_valid<=0;
            wr_addr <= 0; rd_addr <= 0;
        end
        else if(rx_valid) begin
            case(din[9:8])
                2'b00: begin // write address
                    wr_addr <= din[7:0];
                    tx_valid <= 0;
                    dout <= 0;
                end
                2'b01: begin // write data
                    mem[wr_addr] <= din[7:0];
                    wr_addr <= wr_addr + 1; // auto-increment address
                    tx_valid <=0;
                    dout <= 0;
                end
                2'b10: begin //read address
                    rd_addr <= din[7:0];
                    tx_valid <= 0;
                    dout <= 0;
                end
                2'b11: begin // read data
                    dout <= {2'b11, mem[rd_addr]};
                    rd_addr <= rd_addr + 1;
                    tx_valid <= 1; // the only case
                end
            endcase
        end
         else begin
            tx_valid <= 0; // release the tx_valid after assertion
        end
    end
endmodule