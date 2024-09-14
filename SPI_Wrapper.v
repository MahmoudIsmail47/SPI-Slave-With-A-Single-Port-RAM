module SPI_Wrapper_FINAL (
    input MOSI , clk , rst , ss_n ,
    output MISO );

wire [0:9] w1_rx_data;
wire [0:7] w2_tx_data;
wire tx_valid_w3;
wire rx_valid_w4;

SPI_SLAVE_FINAL SPI ( .MOSI(MOSI) , 
.clk(clk) , 
.rst(rst) , 
.tx_valid(tx_valid_w3) ,
.ss_n(ss_n) ,
.tx_data(w2_tx_data) , 
.MISO(MISO) , 
.rx_valid(rx_valid_w4) , 
.rx_data(w1_rx_data) );

RAM_FINAL u_Ram ( .clk(clk) ,
.rst(rst) , 
.rx_valid(rx_valid_w4) , 
.din(w1_rx_data) , 
.dout(w2_tx_data) , 
.tx_valid(tx_valid_w3) );

endmodule


