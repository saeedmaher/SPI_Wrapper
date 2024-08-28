module RAM(
input clk,rst_n,rx_valid,
input [9:0] din,
output reg tx_valid,
output reg [7:0] dout 
);

reg [7:0]ADD_read,ADD_write;
reg [7:0] mem [255:0];
integer i;

always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
begin
for(i=0;i<256;i=i+1)
mem[i]=0;
end
else
begin
if(rx_valid)
begin
tx_valid<=0;
case (din[9:8])
2'b0: ADD_write<=din[7:0];
2'b01: mem[ADD_write]<=din[7:0];
2'b10: ADD_read<=din[7:0];
endcase
end
if(din[9:8]==2'b11) begin
tx_valid<=1;
dout<=mem[ADD_read];
end
end
end
endmodule


