

module Module_Main(
		input clk_50,
		
		//////////////for color detecting
		input color_in,
		output s2,
		output s3,
		output s0,
		output s1,
		
		///////////// For color LEDs
		output red,
		output green,
		output blue,
		
		//////////////for ADC Analog to Digital Converter Module
		input  dout,				
		output adc_cs_n,
		output din,					
		output adc_sck,	
		
		////////////for Motors control
		output lef,
		output rig,
		output lp,
		output rp,
		
		//////////////for UART message transmission
		
		output txout,
		
		////////////////for Electromagnet
		output em
		
	
		
		
);

wire r;
wire b;
wire g;
wire [1:0]clr;

wire lvl;

wire left1;
wire left2;
wire right1;
wire right2;

wire [11:0]ch5;
wire [11:0]ch6;
wire [11:0]ch7;

wire [5:0]start_n;
wire [5:0]end_n;

wire [2:0]dirs[9:0] ;
wire [3:0]length;
wire fin;

wire [1:0]msg;

wire msg_from_clr;


Module_ADC adc_des(
		.clk_50(clk_50),
		.dout(dout),
		.adc_cs_n(adc_cs_n),
		.din(din),
		.adc_sck(adc_sck),
		
		.d_out_ch5(ch5),
		.d_out_ch6(ch6),
		.d_out_ch7(ch7)
		
		);
		
Module_Motors mot_des(
		.clk_50(clk_50),
		
		.SensLeft(ch6),
		.SensCenter(ch7),
		.SensRight(ch5),
		
		.lef(lef),
		.rig(rig),
		.lp(lp),
		.rp(rp)
		
		
		/*.start_(start_n),
		.end_(end_n),
		
		.len(length)*/
		
		
		
		);

		
Module_ColorSensor  color_des(
		.clk_50(clk_50),
		.sq(color_in),
		.s2(s2),
		.s3(s3),
		.s0(s0),
		.s1(s1),
		
		.red(r),
		.green(g),
		.blue(b),
		
		.clr(msg),
		.lvl(lvl)		
		
		);
		
		
Module_UART uart_des(
		.clk_50(clk_50),
		.char(clr),
		.txout(txout)
		);
	

		
assign red=r;
assign green=g;
assign blue=b;

		
endmodule 

