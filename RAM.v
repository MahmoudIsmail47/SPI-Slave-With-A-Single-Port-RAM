module RAM_FINAL #( parameter MEM_DEPTH = 256 , ADDR_SIZE = 8)
(
    input clk , rst , rx_valid ,
    input [0:9] din , 
    output reg tx_valid , 
    output reg [0:7] dout
);


reg [0 : ADDR_SIZE -1 ] mem [0 : MEM_DEPTH -1];


reg [0:7] internal_address_write;
reg [0:7] internal_address_read;

integer k;
integer i; // counter to control tx_valid

always @ (posedge clk or negedge rst)
begin

    if (!rst)
    begin
        for (i=0 ; i<MEM_DEPTH ; i = i+1)
        begin mem [i] <= 1'd0;
        end
        internal_address_read <= 1'd0;
        internal_address_write <= 1'd0;
        tx_valid <= 1'd0;
        dout <= 1'd0;
        k <= 0;
        i <= 0;
    end

    else if (rx_valid)
    begin
        
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
                i <= 1;
            end

        endcase

    end

    else if ( k<8 && i == 1)
    begin
    tx_valid <= 1'b1;
    k <= k+1;
    end

    else tx_valid <= 1'b0;

end

endmodule
