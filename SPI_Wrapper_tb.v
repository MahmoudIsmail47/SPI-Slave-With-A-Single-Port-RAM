module SPI_Wrapper_tb ();

reg MOSI , clk , rst , ss_n , MISOexp;
wire MISO;

SPI_Wrapper_FINAL DUT ( .MOSI(MOSI) , .clk(clk) , .rst(rst) , .ss_n(ss_n) , .MISO(MISO) );

integer i;

always #5
clk = ~clk;

initial
begin

clk = 0;
rst = 0;

for (i=0 ; i<10 ; i=i+1)
begin
MOSI = $random;
if (MISO != MISOexp) $display ("error in rst");
@(negedge clk);
end

rst = 1; @(negedge clk);

// write address

ss_n = 0; @(negedge clk);
MOSI = 0; @(negedge clk);
MOSI = 0; @(negedge clk);
MOSI = 0; @(negedge clk);

MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; ss_n = 1; @(negedge clk);

MOSI = 'z; @(negedge clk);
ss_n = 1; @(negedge clk);

// write data

ss_n = 0; @(negedge clk);
MOSI = 0; @(negedge clk);
MOSI = 0; @(negedge clk);
MOSI = 1; @(negedge clk);

MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; ss_n = 1; @(negedge clk);

MOSI = 'z; @(negedge clk);
ss_n = 1; @(negedge clk);

// read address

ss_n = 0; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 0; @(negedge clk);

MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; ss_n = 1; @(negedge clk);

MOSI = 'z; @(negedge clk);
ss_n = 1; @(negedge clk);

// read data

ss_n = 0; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);

MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);
MOSI = 1; @(negedge clk);


for (i=0 ; i<8 ; i=i+1)
begin
@(negedge clk);
end

ss_n = 1;

end

endmodule