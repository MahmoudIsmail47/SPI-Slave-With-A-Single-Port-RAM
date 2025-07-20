module RAM #( parameter MEM_DEPTH = 256 , ADDR_SIZE = 8)
(
    input clk , rst , rx_valid ,
    input [0:9] din , 
    output reg tx_valid , 
    output reg [0:7] dout
);


reg [0 : ADDR_SIZE -1 ] mem [0 : MEM_DEPTH -1];


reg [0:7] internal_address_write;
reg [0:7] internal_address_read;
reg tx_ctrl;

integer k;

always @ (posedge clk or negedge rst) begin
    if (!rst) begin
        for (k=0 ; k<MEM_DEPTH ; k = k+1) begin 
            mem [k] <= 1'd0;
        end
        internal_address_read <= 1'd0;
        internal_address_write <= 1'd0;
        tx_valid <= 1'd0;
        dout <= 1'd0;
        k <= 0;
        tx_ctrl <= 1'b0;
    end
    else if (rx_valid) begin
        case (din[0:1])
            2'b00: begin
                internal_address_write <= din[2:9];
                tx_valid <= 1'b0;
                k <= 0;
            end
            2'b01: begin
                mem [internal_address_write] <= din[2:9];
                tx_valid <= 1'b0;
                k <= 0;
            end
            2'b10: begin
                internal_address_read <= din[2:9];
                k <= 0;
            end
            2'b11: begin
                dout <= mem [internal_address_read];
                tx_valid <= 1'b1;
                tx_ctrl <= 1'b1;
            end
        endcase
    end
    else if ( k < 8 && tx_ctrl) begin
        tx_valid <= 1'b1;
        k <= k + 1;
    end
    else begin
        tx_valid <= 1'b0;
        k <= 0;
        tx_ctrl <= 1'b0;
    end

    end

endmodule
