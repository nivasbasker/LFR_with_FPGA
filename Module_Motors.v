

//Motor for controlling the two motors according to the putputs from 3 line sensorsn v13
//

module Module_Motors(
	input clk_50,	//50 MHz clock
	input [11:0]SensRight,  
	input [11:0]SensLeft,
	input [11:0]SensCenter,
	
	output lef,
	output rig,
	output lp,
	output rp,
	
	output lvl,
	input fin,
	output em,
	output [1:0]clr_msg,
	input [1:0]msg_from_clr

	
	
		
);


//////////////////////////start of motor//////////////////

reg clk_1k=0;
parameter [11:0]range = 12'd300;

reg [19:0]limit = 20'd5000 ; //50000 for 1khz
reg [19:0]counter1 = 20'd0 ;

reg left=0;
reg right=0;
reg lpw=0;
reg rpw=0;

reg a1=0;
reg a2=0;
reg a3=0;
reg a4=0;


reg [4:0]state = 5'd0;



reg flag=0;
reg flag2=1;

reg [1:0]run=2'd0;
reg e_m;

reg run_out;
reg [2:0]dir[9:0];

reg rev;

reg [1:0]msg;

reg [4:0]i;
reg [4:0]k=0;

reg [5:0] s_node;
reg [5:0] e_node;
reg [5:0] current;

reg [1:0] j;
reg [1:0] color[2:0];
reg [5:0] dz[2:0];
reg [5:0] supply_node[6:0];
reg [5:0] find_result;
reg at_wh=0;
reg [3:0] n;
reg [1:0] supplies[6:0];



parameter [17:0] array={6'd2, 6'd11, 6'd0};

initial
begin

s_node = 6'd31;
e_node = 6'd2;
//current = 6'd6;


run_out = 1;
rev=0;
e_m=1;
i=0;
k=0;

end

always @(dir0)
begin

	dir[0] = dir0;
	dir[1] = dir1;
	dir[2] = dir2;
	dir[3] = dir3;
	dir[4] = dir4;
	dir[5] = dir5;
	dir[6] = dir6;
	dir[7] = dir7;
	dir[8] = dir8;
	dir[9] = dir9;

end

always @(posedge clk_50)
begin
	
	if(counter1 < limit)
		counter1 = counter1 + 1;
	else 
	begin
		counter1 <= 0;
		clk_1k = ~clk_1k;
	end

end



always @(posedge clk_1k)
begin

		begin
				
	
				if(flag2==1 )
				begin
				
						if( SensRight<range && SensCenter<range && SensLeft<range )
						begin
						//stop
						stop();
						end
						else if(SensRight<range && SensCenter>range && SensLeft<range )
						begin
						//go forward
						forward();
						
						if(flag==1)
						begin
						flag<=0;
						i<=i+1;
						state <= state +1;
						
						end
						end
						else if(SensRight>range && SensCenter<range && SensLeft<range )
						begin
						//go right
						
						turnright(); 
						end
						else if(SensRight<range && SensCenter<range && SensLeft>range )
						begin
						//go left
						
						turnleft();
						end
						
						else if(SensRight<range && SensCenter>range && SensLeft>range )
						begin
						//turn left
						
						turnleft();
						end
						else if(SensRight>range && SensCenter>range && SensLeft<range )
						begin
						//turn right
						
						turnright();
						end
						
						else if ( SensRight>range && SensCenter>range && SensLeft>range  )
						begin
								stop();
								flag<=1;
								flag2<=0;
																
						end
				end
				else
				begin
						if (!( SensRight<range && SensCenter>range && SensLeft<range) 
							|| ( SensRight>range && SensCenter>range && SensLeft>range ))
							
						begin
							
							if(i<=len)
							begin
								
								//got dir and follow
								case(dir[i])
								3'd0:forward();
								3'd1:uturn();
								3'd2:turnright();
								3'd3:turnleft();
								3'd4:stop();
								default:stop();
								endcase
							end
							
							else if(k<=6'd1)
							begin
							
							s_node=array[k*6+:6];
							e_node=array[(k+1)*6+:6];
							current=e_node;
							k=k+1;
							i=0;
							
							end
							
							else if(color[j]!=0 && j<=2)
							begin
							
								if(at_wh==1)
								begin
									e_m=0;//pick and supply
									
									s_node=current;
									e_node=dz[j];
									current=e_node;
									i=0;
									
									j=j+1;
									at_wh=0;
								end
								else
								begin
									e_m=1;//deposit and next
									
									for(n=0; n<6; n=n+1)
									begin
									if(supplies[n]==color[j])
									find_result=supply_node[n];
									end
							
									s_node=current;
									e_node=find_result;
									current=e_node;
									i=0;
									at_wh=1;
								
								end
							
							end

						end
						
						else
						begin 
							flag2<=1;
							
						end
						
				end
		
		end
		

end


assign lef = left;
assign rig = right;
assign lp = lpw;
assign rp = rpw;


assign lvl=run_out;

assign em=e_m;
assign clr_msg=msg;

Module_Dijkstra_Algo  dij( //.start_node(s_node),
                 //.end_node(e_node),
                 .direction0(dir0),
                 .direction1(dir1),
                 .direction2(dir2),
                 .direction3(dir3),
                 .direction4(dir4),
                 .direction5(dir5),
                 .direction6(dir6),
                 .direction7(dir7),
                 .direction8(dir8),
                 .direction9(dir9),
                 .length(len)
					 );
		

task uturn();
begin
	left<=0 ; right<=1;
	lpw<=1 ; rpw<=0;
end
endtask

task turnleft();
begin
	left<=1 ; right<=0;
	lpw<=1 ; rpw<=1;
end
endtask

task hardleft();
begin
	left<=1 ; right<=0;
	lpw<=0 ; rpw<=1;
end
endtask

task turnright();
begin
	left<=0 ; right<=1;
	lpw<=1 ; rpw<=1;
end
endtask

task hardright();
begin
	left<=0 ; right<=1;
	lpw<=1 ; rpw<=0;
end
endtask

task forward();
begin
	left<=0 ; right<=0;
	lpw<=1 ; rpw<=1;
end
endtask

task stop();
begin
	left<=1 ; right<=1;
	lpw<=1 ; rpw<=1;
end
endtask

task reverse();
begin
	left<=1 ; right<=1;
	lpw<=0 ; rpw<=0;
end
endtask


//////////////////////////////////////////////end of motor///////////////////////////////////

endmodule 

