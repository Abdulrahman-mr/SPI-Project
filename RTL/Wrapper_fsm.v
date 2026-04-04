module fsm(
    input clk, rst_n, SS_n,
    input rx_valid,
    //input [9:0] rx_data,
);
    reg [2:0] current_state, next_state;
    parameter IDLE = 3'b000, CHK_CMD = 3'b001,
              READ_ADD = 3'b010, READ_DATA = 3'b011, WRITE= 3'b100;
    reg read_ready;
    always @(posedge clk) begin
        if (!rst_n) begin current_state <= IDLE; read_ready <= 0; end
        else current_state <= next_state;
    end
    always @(*) begin
        case (current_state)
            IDLE: next_state = (SS_n)? IDLE : CHK_CMD;
            CHK_CMD: next_state = (SS_n)? IDLE :
                                  (MOSI ==0)? WRITE:
                                  (read_ready)? READ_DATA : READ_ADD;
            READ_ADD: begin next_state = (SS_n)? IDLE : READ_ADD; read_ready = 1; end
            READ_DATA: begin next_state = (SS_n)? IDLE : READ_DATA; read_ready = 0; end
            WRITE: next_state = (SS_n)? IDLE : WRITE;
            default: next_state = IDLE;
        endcase
    end
    //output logic (instruction decoding)
    //This part is left to Omar
    always @(posedge clk) begin
        if(!rst_n) begin
            
        end
        else begin
            //if(current_state == WRITE)
            //start counting up to 10 bits (clks), each time sampling the MOSI bit and shifting it into a register, then assert rx_valid for 1 clk cycle

            //if(current_state == READ_ADD)

            //if(current_state == READ_DATA)
        end
            
endmodule