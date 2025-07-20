module SPI_SLAVE(
    input MOSI , clk , rst ,
    tx_valid , ss_n ,
    input [0:7] tx_data ,
    output reg MISO , rx_valid ,
    output reg [0:9] rx_data );

integer i;
reg [0:1] cs , ns;
reg flare;

localparam IDLE = 2'b00, CHK_CMD = 2'b01, WRITE = 2'b10, READ = 2'b11;

always @ (posedge clk or negedge rst) begin
    if (!rst)
        cs <= IDLE;
    else
        cs <= ns;
    if (flare)
        i <= i + 1;
    else
        i <= 0;
end
always @ (*) begin
    case (cs)
        IDLE: begin
            MISO = 1'b0;
            rx_valid = 1'b0;
            rx_data = 10'b0;
            if (tx_valid) begin
                MISO = tx_data[i];
                flare = 1'b1;
            end
            else if (ss_n) begin
                flare = 1'b0;
                ns = IDLE;
            end
            else begin
                flare = 1'b0;
                ns = CHK_CMD;
            end
        end
        CHK_CMD: begin
            MISO = 1'b0;
            rx_valid = 1'b0;
            rx_data = 10'b0;
            flare = 1'b0;
            if (MOSI)
                ns = READ;
            else
                ns = WRITE;
        end
        WRITE: begin
            MISO = 1'b0;
            flare = 1'b1;
            if (i < 9) begin
                rx_data[i] = MOSI;
                rx_valid = 1'b0;
                ns = WRITE;
            end
            else if (i == 9) begin
                rx_data[i] = MOSI;
                rx_valid = 1'b1;
                ns = WRITE;
            end
            else begin
                rx_data = 10'b0;
                rx_valid = 1'b0;
                ns = IDLE;
            end
        end
        READ: begin
            MISO = 1'b0;
            flare = 1'b1;
            if (i < 9) begin
                rx_data[i] = MOSI;
                rx_valid = 1'b0;
                ns = READ;
            end
            else if (i == 9) begin
                rx_data[i] = MOSI;
                rx_valid = 1'b1;
                ns = READ;
            end
            else if (tx_valid) begin
                flare = 1'b0;
                rx_valid = 1'b0;
                rx_data = 10'b0;
                ns = IDLE;
            end
            else begin
                ns = IDLE;
                rx_valid = 1'b0;
                rx_data = 10'b0;                
            end
        end
    endcase
end
endmodule