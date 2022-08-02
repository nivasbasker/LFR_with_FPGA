////////////////////////////v3

module Module_Dijkstra_Algo(

  input [5:0]start_node,
  input [5:0]end_node,
  
  output [2:0]direction0 ,
  output [2:0]direction1 ,
  output [2:0]direction2 ,
  output [2:0]direction3 ,
  output [2:0]direction4 ,
  output [2:0]direction5 ,
  output [2:0]direction6 ,
  output [2:0]direction7 ,
  output [2:0]direction8 ,
  output [2:0]direction9 ,
  
  output [3:0]length,
  output finish,
  
  output [1:0] t_dir
  
);
  
  reg [5:0] start_n;
  reg [5:0] end_n;
  
  reg [1:0] temp_dir = 2'b11;
  
  reg [5:0] min_dist;
  reg [5:0] temp_node;
  reg [5:0] path [9:0];
  reg [2:0] dir[9:0];
  reg [2:0] final_dir[9:0];
  
  reg visited_node[36:0];
  
  reg [5:0] distance[36:0]; 
  reg [5:0] from_node[36:0];
  
  //always constants
  reg [7:0] X_co[36:0];
  reg [7:0] Y_co [36:0];
  reg [5:0] graph [36:0][36:0];
  //reg [7:0] g[1369:0];
  
  reg[3:0] len;
  
  integer nxt;
  integer x2,x1,y2,y1;
  integer count;
  integer i;
  integer j;
  
  //always constant
  integer inf;
  integer limit;
  
  
initial
begin
	

	temp_dir =   2'b11;
	min_dist = 6'd50;
	inf = 50;
  	len=4'd0;
	
		
	///////////////////CONSTANT VALUE INITIALIZATION OVER//////////////////////////
	
 				
end
always @(start_node)
begin
//start_n<=start_node;
end

always @( end_node)
begin

	for (i = 0; i <= 36; i=i+1)
	begin
		distance[i] = 6'd50;
		visited_node[i] = 0;
		from_node[i]=6'd37;
      for (j = 0; j <= 36; j=j+1)
      begin
        //g[(37*i)+j]=inf;
        graph[i][j]=inf;
      end
		
	end
	for (i = 0; i <= 9; i=i+1)
	begin
	path[i]=6'd50;
	dir[i]=3'd5;
	final_dir[i]=3'd5;
	end
	
  	begin
	// NODE GRAPH
	graph[0][1]=1;
	graph[0][2]=2;
	graph[0][8]=3;
	graph[1][0]=1;
	graph[2][0]=2;
	graph[2][3]=3;
	graph[2][4]=2;
	graph[3][2]=3;
	graph[3][6]=2;
	graph[3][17]=4;
	graph[4][2]=2;
	graph[4][5]=1;
	graph[4][11]=2;
	graph[5][4]=1;
	graph[6][3]=2;
	graph[6][7]=1;
	graph[6][14]=3;
	graph[7][6]=1;
	graph[8][0]=3;
	graph[8][10]=2;
	graph[8][33]=4;
	graph[9][10]=1;
	graph[10][8]=2;
	graph[10][9]=1;
	graph[10][11]=1;
	graph[11][4]=2;
	graph[11][10]=1;
	graph[11][12]=3;
	graph[11][18]=1;
	graph[12][11]=3;
	graph[12][13]=1;
	graph[12][14]=1;
	graph[12][23]=2;
	graph[13][12]=1;
	graph[14][6]=3;
	graph[14][12]=1;
	graph[14][15]=2;
	graph[15][14]=2;
	graph[15][16]=1;
	graph[15][17]=1;
	graph[16][15]=1;
	graph[17][3]=4;
	graph[17][15]=1;
	graph[17][26]=2;
	graph[18][11]=1;
	graph[18][19]=1;
	graph[18][21]=1;
	graph[19][18]=1;
	graph[20][21]=1;
	graph[21][18]=1;
	graph[21][20]=1;
	graph[21][22]=1;
	graph[22][21]=1;
	graph[23][12]=2;
	graph[23][24]=1;
	graph[23][34]=3;
	graph[24][23]=1;
	graph[25][26]=1;
	graph[26][17]=2;
	graph[26][25]=1;
	graph[26][35]=4;
	graph[27][28]=1;
	graph[28][21]=1;
	graph[28][27]=1;
	graph[28][29]=1;
	graph[28][31]=1;
	graph[29][28]=1;
	graph[30][31]=1;
	graph[31][28]=1;
	graph[31][30]=1;
	graph[31][32]=1;
	graph[31][33]=1;
	graph[32][31]=1;
	graph[33][8]=4;
	graph[33][31]=1;
	graph[33][34]=3;
	graph[34][23]=3;
	graph[34][33]=3;
	graph[34][35]=2;
	graph[35][26]=4;
	graph[35][34]=2;
	graph[35][36]=1;
	graph[36][35]=1;
	
	 
    X_co[0]=0;		Y_co[0]=20;
    X_co[1]=5;		Y_co[1]=20;
    X_co[2]=0;		Y_co[2]=30;
    X_co[3]=0;		Y_co[3]=50;
    X_co[4]=10;	Y_co[4]=30;
    X_co[5]=10;	Y_co[5]=35;
    X_co[6]=10;	Y_co[6]=50;
    X_co[7]=10;	Y_co[7]=55;
    X_co[8]=20;	Y_co[8]=15;
    X_co[9]=15;	Y_co[9]=25;
    X_co[10]=20;	Y_co[10]=25;
    X_co[11]=20;	Y_co[11]=30;
    X_co[12]=20;	Y_co[12]=45;
    X_co[13]=15;	Y_co[13]=45;
    X_co[14]=20;	Y_co[14]=50;
    X_co[15]=20;	Y_co[15]=60;
    X_co[16]=15;	Y_co[16]=60;
    X_co[17]=20;	Y_co[17]=70;
    X_co[18]=25;	Y_co[18]=30;
    X_co[19]=25;	Y_co[19]=35;
    X_co[20]=30;	Y_co[20]=25;
    X_co[21]=30;	Y_co[21]=30;
    X_co[22]=30;	Y_co[22]=35;
    X_co[23]=35;	Y_co[23]=45;
    X_co[24]=35;	Y_co[24]=55;
    X_co[25]=35;	Y_co[25]=65;
    X_co[26]=35;	Y_co[26]=70;
    X_co[27]=40;	Y_co[27]=25;
    X_co[28]=40;	Y_co[28]=30;
    X_co[29]=40;	Y_co[29]=35;
    X_co[30]=45;	Y_co[30]=25;
    X_co[31]=45;	Y_co[31]=30;
    X_co[32]=45;	Y_co[32]=35;
    X_co[33]=55;	Y_co[33]=30;
    X_co[34]=55;	Y_co[34]=45;
    X_co[35]=55;	Y_co[35]=55;
    X_co[36]=50;	Y_co[36]=55;
    
	 
	distance[0] = 6'd50;
	distance[1] = 6'd50;
	distance[2] = 6'd50;
	distance[3] = 6'd50;
	distance[4] = 6'd50;
	distance[5] = 6'd50;
	distance[6] = 6'd50;
	distance[7] = 6'd50;
	distance[8] = 6'd50;
	distance[9] = 6'd50;
	distance[10] = 6'd50;
	distance[11] = 6'd50;
	distance[12] = 6'd50;
	distance[13] = 6'd50;
	distance[14] = 6'd50;
	distance[15] = 6'd50;
	distance[16] = 6'd50;
	distance[17] = 6'd50;
	distance[18] = 6'd50;
	distance[19] = 6'd50;
	distance[21] = 6'd50;
	distance[22] = 6'd50;
	distance[23] = 6'd50;
	distance[24] = 6'd50;
	distance[25] = 6'd50;
	distance[26] = 6'd50;
	distance[27] = 6'd50;
	distance[28] = 6'd50;
	distance[29] = 6'd50;
	distance[30] = 6'd50;
	distance[31] = 6'd50;
	distance[32] = 6'd50;
	distance[33] = 6'd50;
	distance[34] = 6'd50;
	distance[35] = 6'd50;
	distance[36] = 6'd50;

    //GRAPH
      
	end
  					
			
			start_n = start_node;
			temp_node = start_n;
  			distance[start_n] = 0;
			
			end_n=end_node;
			nxt = end_n;
			temp_dir=2'b11;
			len=4'd0;
			limit=10;
			
	/////////// ALL INITIALIZATION IS DONE//////////////	


	begin
		for (count = 0; count <= 36; count=count+1) 
		begin
			
			min_dist=6'd50;
			for (j = 0; j <= 36;j=j+1)
			begin
				if (visited_node[j]==0 && distance[j] < min_dist)
				begin
					min_dist = distance[j]; 
					i = j;
				end
			
			end
		  //$display("picked up  = %0d", u);
		  visited_node[i] = 1;
			
			for (j = 0; j <= 36; j=j+1)
			begin
               //$display("updated dist = %0d, pos %0d visited_node %0d, graph %0d",distance[v],v,visited_node[v],  graph[u][v]);
					if (visited_node[j]==0 && graph[i][j]!= inf && distance[i] != 6'd50 && (distance[i] + graph[i][j] < distance[j]) )
					begin
							distance[j] = distance[i] + graph[i][j];
							from_node[j]=i;
							//$display("updated dist = %0d, pos %0d visited_node %0d",distance[v],v,visited_node[v]);
					end
					
			end
			
			
		end	
					
		
	end
	
	//$display("Vertex \t Distance from_node Source") ;
	  //for (i = 0; i < 37; i=i+1)
		//$display("position = %0d, distance %0d from_node %0d",i, distance[i],from_node[i]);
	
	////////// GOT THE SHORTEST DISTANCE TO EACH NODE///////////
	
	begin
			
      	for (i = 0; i<limit; i=i+1)
			begin
				if(distance[nxt]!=0)
				begin
					 path[i]=nxt;
					 nxt=from_node[nxt];
                  $display("path = %0d", path[i]);
				end
				else path[i]=6'd50;
			end 
		  
			//Turn to take
			 //0 >> Do not turn
			 //1 >> Reverse
			 //2 >> Right
			 //3 >> Left
			 //4 >> stop
		
			 //temp_dir
			 //00 >> North
			 //01 >> South
			 //10 >> East
			 //11 >> West
	
      for(i=limit-1; i>=0; i=i-1)
			begin
			if(path[i]!=6'd50)
			begin
			
				x2 = X_co[path[i]];
				x1 = X_co[temp_node];
				y2 = Y_co[path[i]];
				y1 = Y_co[temp_node];
				
				if(x2 - x1 > 0) begin
				  
					 if(y2 - y1 == 0) begin 
						
							case(temp_dir)
							2'b00 : dir[i] = 3'b010;
							2'b01 : dir[i] = 3'b011;
							2'b10 : dir[i] = 3'b000;
							2'b11 : dir[i] = 3'b001;
							endcase
							temp_dir = 2'b10;
					 end
                  	else if(y2 - y1 > 0) begin //north east and west south
                      if(temp_node==6'd8)
                           begin
                              case(temp_dir)
                                2'b00 : dir[i] = 3'b010;
                                2'b01 : dir[i] = 3'b011;
                                2'b10 : dir[i] = 3'b000;
                                2'b11 : dir[i] = 3'b001;
                              endcase  
                              temp_dir = 2'b01;//south
                           end
                         else
                            begin
                              case(temp_dir)
                                2'b00 : dir[i] = 3'b001;
                                2'b01 : dir[i] = 3'b000;
                                2'b10 : dir[i] = 3'b010;
                                2'b11 : dir[i] = 3'b011;
                              endcase  
                              temp_dir = 2'b10;//east
                           end
					 end
                 	 else if(y2 - y1 < 0) begin //west North and south east
                       if(temp_node==6'd0)
                           begin
                              case(temp_dir)
                                2'b00 : dir[i] = 3'b000;
                                2'b01 : dir[i] = 3'b001;
                                2'b10 : dir[i] = 3'b011;
                                2'b11 : dir[i] = 3'b010;
                              endcase  
                              temp_dir = 2'b10;//east
                           end
                         else
                            begin
                              case(temp_dir)
                                2'b00 : dir[i] = 3'b010;
                                2'b01 : dir[i] = 3'b011;
                                2'b10 : dir[i] = 3'b000;
                                2'b11 : dir[i] = 3'b001;
                              endcase  
                              temp_dir = 2'b00;//north
                           end
					 end
					 
				end
				else if(x2 - x1 < 0) begin
				  
					 if(y2 - y1 == 0) begin 
							case(temp_dir)
							2'b00 : dir[i] = 3'b011;
							2'b01 : dir[i] = 3'b010; 
							2'b10 : dir[i] = 3'b001;
							2'b11 : dir[i] = 3'b000;
							endcase
							temp_dir = 2'b11;
					 end
                  else if(y2 - y1 > 0) begin //North west and east south
                       if(temp_node==6'd8)
                         begin
							case(temp_dir)
                              2'b00 : dir[i] = 3'b011;
                              2'b01 : dir[i] = 3'b010;
                              2'b10 : dir[i] = 3'b001;
                              2'b11 : dir[i] = 3'b000;
							endcase  
							temp_dir = 2'b01;//south
                         end
                       else
                          begin
							case(temp_dir)
                              2'b00 : dir[i] = 3'b001;
                              2'b01 : dir[i] = 3'b000;
                              2'b10 : dir[i] = 3'b010;
                              2'b11 : dir[i] = 3'b011;
							endcase  
							temp_dir = 2'b11;//west
                         end
					 end
                  else if(y2 - y1 < 0) begin //East North and SW corner
							case(temp_dir)
                            2'b00 : dir[i] = 3'b000;
                            2'b01 : dir[i] = 3'b001;
                            2'b10 : dir[i] = 3'b011;
									 2'b11 : dir[i] = 3'b010;
							endcase
							temp_dir = 2'b11;
					 end
					 
				end
				else if(x2 - x1 == 0) begin
				  
					 if(y2 - y1 > 0) begin
							case(temp_dir)
							2'b00 : dir[i] = 3'b001;
							2'b01 : dir[i] = 3'b000;
							2'b10 : dir[i] = 3'b010;
							2'b11 : dir[i] = 3'b011;
							endcase
							temp_dir = 2'b01;
					 end
					 else if(y2 - y1 < 0) begin
							case(temp_dir)
							2'b00 : dir[i] = 3'b000;
							2'b01 : dir[i] = 3'b001;
							2'b10 : dir[i] = 3'b011;
							2'b11 : dir[i] = 3'b010;
							endcase
							temp_dir = 2'b00;
					 end
					 else if(y2 - y1 == 0) begin //same spot
                       dir[i]=3'b100;
					 end
					 
				end
			  
			  final_dir[len] = dir[i];
			  len=len+1;
			  temp_node=path[i];
			  
			end
		end
     
      final_dir[len]=3'b100;
		start_n=end_n;
			
	end
	
end


assign direction0 = final_dir[0];
assign direction1 = final_dir[1];
assign direction2 = final_dir[2];
assign direction3 = final_dir[3];
assign direction4 = final_dir[4];
assign direction5 = final_dir[5];
assign direction6 = final_dir[6];
assign direction7 = final_dir[7];
assign direction8 = final_dir[8];
assign direction9 = final_dir[9];

assign length = len;
assign t_dir=temp_dir;
endmodule 
