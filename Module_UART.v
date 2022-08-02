//UART Transmitter design
//Input   : clk_50M : 50 MHz clock
//Output  : tx : UART transmit output


module Module_UART(
	input clk_50,	//50 MHz clock
	input [1:0] char,
	output txout
);


reg [8:0] counter = 9'd0;				
reg clks = 0;
reg outs = 1;
reg [3:0] counter2 = 4'd0;
reg [7:0] data;
reg start_bit = 0;
reg stop_bit = 1;
reg [3:0]state = 4'd0;

//reg [1:0]char=2'd0;


parameter clk_per_bit = 9'd216;	//433
parameter frame = 4'd11;			
parameter _S = 8'b01010011, 
			 _I = 8'b01001001,
			 _M = 8'b01001101,
			 _D = 8'b01000100,
			 _Z = 8'b01011010,
			 _1 = 8'b00110001,
			 
			 _hyphen = 8'b00101101,
			 _hash = 8'b00100011,
			 _CR = 8'b00001010,
			 
			  _P = 8'b01010000,
			  _N = 8'b01001110,
			  _W = 8'b01010111;
			 
			
			
reg [7:0] SP[12:0];		//S-P-DZN1-N-#
reg [7:0] SD[12:0];		//S-D-DZN1-N-#
reg [7:0] SI[11:0];		//SI-SIN1-N-#
reg [4:0] i;

initial 
begin
data = _S;
state = 4'd0;
i=5'd1;

SP[0]=_S;
SP[1]=_hyphen;
SP[2]=_P;
SP[3]=_hyphen;
SP[4]=_D;
SP[5]=_Z;
SP[6]=_N;
SP[7]=_1;
SP[8]=_hyphen;
SP[9]=_N;
SP[10]=_hyphen;
SP[11]=_hash;
SP[12]=_CR;

SD[0]=_S;
SD[1]=_hyphen;
SD[2]=_D;
SD[3]=_hyphen;
SD[4]=_D;
SD[5]=_Z;
SD[6]=_N;
SD[7]=_1;
SD[8]=_hyphen;
SD[9]=_N;
SD[10]=_hyphen;
SD[11]=_hash;
SD[12]=_CR;

SI[0]=_S;
SI[1]=_I;
SI[2]=_hyphen;
SI[3]=_S;
SI[4]=_I;
SI[5]=_N;
SI[6]=_1;
SI[7]=_hyphen;
SI[8]=_N;
SI[9]=_hyphen;
SI[10]=_hash;
SI[11]=_CR;



end

always @(posedge clk_50)
begin
		  if (counter < clk_per_bit) 
		  begin
           counter <= counter + 1;
        end 
		  else 
		  begin
            counter <= 0;
            clks = ~clks;
        end
end


always @(negedge clks)
begin
		
      if (counter2 < frame) 
		  begin
            counter2 <= counter2 + 1;
        end 
		else 
		  begin
            counter2 <= 1;				
        end

end

reg [3:0]done=4'd0;
reg [1:0]ch=2'd0;

reg [3:0] count = 4'd1;

always @(negedge clks)
begin
		
		if(ch!=char)
		begin
			case(count)
			
			4'd1  :  begin
					   outs <= start_bit;
						count<=4'd2;
						end
			4'd2  :  begin
						outs <= data[0];
						count<=4'd3;
						end
			4'd3  :  begin
						outs <= data[1];
						count<=4'd4;
						end
			4'd4  :  begin
						outs <= data[2];
						count<=4'd5;
						end
			4'd5  :  begin
						outs <= data[3];
						count<=4'd6;
						end
			4'd6  :  begin
						outs <= data[4];
						count<=4'd7;
						end
			4'd7  :  begin
						outs <= data[5];
						count<=4'd8;
						end
			4'd8  :  begin
						outs <= data[6];
						count<=4'd9;
						end
			4'd9  :  begin
						outs <= data[7];
						count<=4'd10;
						end
			4'd10 :  begin
						outs <= stop_bit;
						count<=4'd11;
						end
			4'd11 :  begin
						outs <= stop_bit;
						
						case(char)
						2'd1 : begin
									if(i<=5'd11)
									begin
									data <= SI[i];
									i<=i+1;
									end
									else
									begin
									ch<=char;
									data <= _S;
									i<=5'd1;
									end
								 end
						2'd2 : begin
									if(i<=5'd12)
									begin
									data <= SP[i];
									i<=i+1;
									end
									else
									begin
									ch<=char;
									data <= _S;
									i<=5'd1;
									end
								 end
						2'd3 : begin
									if(i<=5'd12)
									begin
									data <= SD[i];
									i<=i+1;
									end
									else
									begin
									ch<=char;
									data <= _S;
									i<=5'd1;
									end
								 end
						endcase
						count<=4'd1;
						
						end
	
			endcase
			
			end
	
	
end

assign txout = outs;

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////