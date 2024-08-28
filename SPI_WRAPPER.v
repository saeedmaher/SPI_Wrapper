module SPI_WRPPER (
input MOSI,clk,rst_n,SS_n,
output MISO);
wire [9:0] rx_data;
wire rx_valid,tx_valid;
wire [7:0]tx_data;

SPI s1(
.MOSI(MOSI),
.MISO(MISO),
.SS_n(SS_n),
.clk(clk),
.rst_n(rst_n),
.rx_data(rx_data),
.rx_valid(rx_valid),
.tx_data(tx_data),
.tx_valid(tx_valid)
);
RAM r1(
.clk(clk),
.rst_n(rst_n),
.rx_valid(rx_valid),
.tx_valid(tx_valid),
.din(rx_valid),
.dout(dx_data)
);
endmodule
