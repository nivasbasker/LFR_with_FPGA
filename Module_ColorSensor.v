//////////COLOR. v 
///////// reads data from TCS 3200 sensor and determines by comparing


module Module_ColorSensor (
		input clk_50,
		input sq,
		input lvl,
		
		output s2,
		output s3,
		output s0,
		output s1,
		
		output red,
		output green,
		output blue,
		
		output [1:0]clr
		
);

reg [7:0]counter = 8'd0;
reg [7:0]valr = 8'd0;
reg [7:0]valg = 8'd0;
reg [7:0]valb = 8'd0;

reg flag = 0;

reg clk_1m=0;
reg [5:0]count = 6'd0;
reg [5:0]frame = 6'b110010;


reg [1:0]state = 2'd0;
reg _s2 = 0;
reg _s3 = 0;

reg flagr = 0;
reg flagb = 0;
reg flagg = 0;

reg re = 0;
reg gr = 0;
reg bl = 0;

reg [1:0] clr_out;
reg [18:0] t_lim = 19'd250000; //250000 18 bit b111101000010010000
reg [18:0]timer = 19'd0;

reg ready=0;


always @(posedge clk_50)
begin

	if(count < frame)
	begin
	count <= count + 1;
	end
	else
	begin
	count <= 0;
	clk_1m <= ~clk_1m;
	end
	
end

always @(posedge clk_1m)
begin 
	
	if(flag == 0)
	counter <= 0;
	else
	counter <= counter + 1;
	
	
	if(timer < t_lim)
	timer<=timer+1;
	else
	begin
	timer<=0;
	ready<=~ready;
	end

	
	
end


always @(posedge sq)
begin

	if(flag == 0)
	begin
		flag <= 1;
	end
	else
	begin
		case(state)
		2'd0 : begin
				 valr <= counter;			//Red value		 
				 _s2 = 1; _s3 = 1;
				 state <= 2'd1;
				 end
		2'd1 : begin
				 valg <= counter;			//green value
				 _s2 = 0; _s3 = 1;
				 state <= 2'd2;
				 end
		2'd2 : begin
				 valb <= counter;			//blue value
				 _s2 = 0; _s3 = 0;
				 state <= 2'd3;
				 end
		2'd3 : begin
				
					if(ready==1)
					begin
					
						if( (valr<50 && valb<50 && valg<50) ||  (valr>100 && valb>100 && valg>100) )
						begin
						flagr=0;flagg=0;flagb=0;		//white or black
						end
						else if(valr<valg && valr<valb  && valb >= valg  && valr<50 && valb-valr>50 && valb>80)
						begin		
						flagr=1;flagg=0;flagb=0;		//red
						end
						else if(valb > valr && valb > valg && (valg-valr<10)  && valb>=100  && valg>90)
						begin		
						flagr=0;flagg=0;flagb=1;		//blue
						end
						else if(valg<valr && valg<valb && valb>=valr && valb<=100  && valb>50)
						begin		
						flagr=0;flagg=1;flagb=0;		//green
						end 

					end
					
					state <= 2'd0;
				
				end
				
		endcase
		flag <= 0;
	end

end

always @(posedge flagr or posedge flagg or posedge flagb or posedge lvl)
begin

		if(lvl==1)
		begin
		re<=0;gr<=0; bl<=0;	//end of run
		end
		
		else if(flagr==1)
		begin					
		re<=1;					//LED to glow
		clr_out<=2'd1;			//uart message
		end 
		else if(flagg==1)
		begin
		gr<=1;
		clr_out<=2'd1;
		end
		else if(flagb==1)
		begin
		bl<=1;
		clr_out<=2'd3;
		end
		

end

assign clr = clr_out;
assign s0 = 1;
assign s1 = 1;
	
assign s2 = _s2;
assign s3 = _s3;

assign red = re;
assign green = gr;
assign blue = bl;
 
endmodule 