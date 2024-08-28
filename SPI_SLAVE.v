module SPI(
input MOSI,tx_valid,rst_n,clk,SS_n,
input [7:0] tx_data,
output reg rx_valid,MISO,
output reg [9:0] rx_data
);
reg [2:0] cs,ns;
reg rd_add;
reg [3:0]counter;
localparam IDLE = 3'b0,
	   CHK_CMD =3'b001,
  	   WRITE = 3'b010,
 	   READ_ADD = 3'b011,
	   READ =3'b100;

always@(posedge clk or negedge rst_n)
begin
if(!rst_n) begin
cs<=IDLE;
end
else begin
cs<=ns;
end
end

always@(*) 
begin
case (cs)
IDLE: begin
if(SS_n==0) ns=CHK_CMD;
else ns=IDLE;
end
CHK_CMD: begin 
if(SS_n==1) ns=IDLE; 
else if(MOSI==0) ns=WRITE;
else if(MOSI==1 && rd_add!=1) ns=READ_ADD;
else if(MOSI==1 && rd_add==1) ns=READ;
end
WRITE: begin
if(SS_n==1) ns=IDLE;
else ns=WRITE;
end
READ_ADD: begin
if(SS_n==1) ns=IDLE;
else ns=READ_ADD;
end
READ: begin
if(SS_n==1) ns=IDLE;
else ns=READ;
end
endcase
end

always@(posedge clk)
begin
case (cs)
IDLE: begin counter=0; end
CHK_CMD: begin rx_valid=0; counter=1; end
WRITE: begin
counter=counter+1;
if(counter<12) begin rx_data[11-counter]=MOSI; end
else if(counter==12) rx_valid=1;
end
READ_ADD: begin
counter=counter+1;
if(counter<12) begin rx_data[11-counter]=MOSI; end
else if(counter==12) begin rx_valid=1; rd_add=1; end
end
READ: begin
counter=counter+1;
if (counter < 12) begin  rx_data[11-counter]=MOSI; end
else if(counter==12) rx_valid=1;
else if(counter<21 && tx_valid==1) begin  MISO=tx_data[20-counter]; end
end
endcase
end
endmodule

