module SPI_SLAVE_FINAL(
    input MOSI , clk , rst ,
    tx_valid , ss_n ,
    input [0:7] tx_data ,
    output reg MISO , rx_valid ,
    output reg [0:9] rx_data );

integer i;
reg [1:0] cs;

localparam IDLE = 2'b00, 
CHK_CMD = 2'b01, 
WRITE = 2'b10;


always @ (posedge clk or negedge rst)
begin

if (!rst)
    begin
        MISO <= 1'b0;
        rx_valid <= 1'b0;
        rx_data <= 10'b0;
        cs <= IDLE;
        i <= 0;
    end

else
    begin
        case(cs)
            IDLE:
            begin
                if (ss_n) begin
                cs <= IDLE;
                rx_valid <= 1'b0;
                rx_data <= 10'b0;
                i <= 0;
                MISO <= 1'b0;
                end
                
                else if (!ss_n)
                begin 
                cs <= CHK_CMD;
                rx_valid <= 1'b0;
                rx_data <= 10'b0;
                i <= 0;
                MISO <= 1'b0;
                end
            end
            CHK_CMD:
            begin
                if (ss_n) cs <= IDLE;

                else if (tx_valid)
                begin
                    
                    MISO <= tx_data[i];
                    if (i<8)
                    begin
                        i <= i+1;
                        cs <= CHK_CMD;
                    end
                    else cs <= IDLE;
                end
                
                else cs <= WRITE;
            end       

            WRITE:
            begin
                if (ss_n) 
                begin
                    if (i == 9)
                    begin
                    rx_data[i] <= MOSI;
                    rx_valid <= 1'b1;
                    cs <= IDLE;
                    end
            
                    else cs <= IDLE;
                end

                else
                begin
                
                    rx_data[i] <= MOSI;
                    if (i<9)
                    begin
                        i <= i+1;
                        cs <= WRITE;
                    end
                
                    else 
                    begin
                        rx_valid <= 1'b1;
                        i <= 0;
                        cs <= IDLE;
                    end
                end
            end
        endcase
    end
end
endmodule