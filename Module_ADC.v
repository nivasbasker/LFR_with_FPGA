//ADC Controller design 	v10
//Inputs  : clk_50 : 50 MHz clock, dout : digital output from ADC128S022 (serial 12-bit)
//Output  : adc_cs_n : Chip Select, din : Ch. address input to ADC128S022, adc_sck : 2.5 MHz ADC clock,
//				d_out_ch5, d_out_ch6, d_out_ch7 : 12-bit output of ch. 5,6 & 7,
//				data_frame : To represent 16-cycle frame (optional)


module Module_ADC(
	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
	output [11:0]d_out_ch5,	//12-bit output of ch. 5 (parallel)
	output [11:0]d_out_ch6,	//12-bit output of ch. 6 (parallel)
	output [11:0]d_out_ch7	//12-bit output of ch. 7 (parallel)

);
	

reg [4:0] counter = 5'd0;
reg out_25hz = 0;
reg skip = 1;

always @(negedge clk_50)
begin
        if(skip == 1)
			skip <= 0;
        else if (counter < 5'd9) 
		  begin
            counter <= counter + 1;
        end 
		  else 
		  begin
            counter <= 0;
            out_25hz = ~out_25hz;
        end

end

reg dins = 0;
reg [4:0] din_count = 5'd0;
reg [2:0] addr = 3'b101 ;
reg frame = 0;
reg [11:0] outs ;
reg [11:0] chan5 = 0;
reg [11:0] chan6 = 0;
reg [11:0] chan7 = 0;
reg [2:0] current_chan = 3'd7; 

reg chip=1;

always @(negedge adc_sck)
begin
	
		case(din_count)
		default :begin
					din_count <= din_count + 1;
					dins <= 0;	
					end
		5'd0  :  begin
				   chip<=0;
					din_count <= din_count + 1;
					dins <= 0;	
					end
		5'd16 : 	begin
					din_count <= 1;
					frame <= frame + 1;
					chip <=0;
					case(current_chan)
					
					3'd5: begin
							chan5 = outs;
							current_chan <= 3'd6;
							end
					3'd6: begin
							chan6 = outs;
							current_chan <= 3'd7;
							end
					3'd7: begin
							chan7 = outs;
							current_chan <= 3'd5;
							end
					
					endcase
					
					case(addr)
					
					3'b101 : addr <= 3'b110;
					3'b110 : addr <= 3'b111;
					3'b111 : addr <= 3'b101;
					endcase
					
					end
		5'd2 	: 	begin
					dins <= addr[2];
					din_count <= din_count + 1;
					end
		5'd3 	: 	begin
					dins <= addr[1];
					din_count <= din_count + 1;
					end
		5'd4 	: 	begin
					dins <= addr[0];
					din_count <= din_count + 1;
					end
	
	
		endcase
	//end

end

always @(posedge adc_sck)
begin

	case(din_count)
	
	5'd5 : outs[11] <= dout;
	5'd6 : outs[10] <= dout;
	5'd7 : outs[9] <= dout;
	5'd8 : outs[8] <= dout;
	5'd9 : outs[7] <= dout;
	5'd10: outs[6] <= dout;
	5'd11: outs[5] <= dout;
	5'd12: outs[4] <= dout;
	5'd13: outs[3] <= dout;
	5'd14: outs[2] <= dout;
	5'd15: outs[1] <= dout;
	5'd16: begin
			 outs[0] <= dout;
			 end
	endcase
	
end


assign adc_sck = out_25hz;
assign adc_cs_n = chip ;

assign din = dins;
assign data_frame = frame ;
assign d_out_ch5 = chan5;
assign d_out_ch6 = chan6;
assign d_out_ch7 = chan7;


////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////


