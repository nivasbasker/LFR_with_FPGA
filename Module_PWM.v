//PWM Generator
//Inputs : Clk, DUTY_CYCLE
//Output : PWM_OUT



module Module_PWM(
 
	input clk_50,             // Clock input
	//input [7:0]DUTY_CYCLE, // Input Duty Cycle
	
	input l1,
	input l2,
	input r1,
	input r2,
	
	output lef,
	output rig,
	output lp,
	output rp       // Output PWM
	
);
 

reg[6:0] counter= 7'd0;		//to keep a count or a secondary clock
reg [6:0]DUTY_CYCLE = 7'd90;	// pwm to assign

reg _l1=0;
reg _l2=0;
reg _r1=0;
reg _r2=0;

reg clk=0;
reg [12:0]limit = 13'b1001110001000 ; //5000 for 1khz
reg [12:0]counter1 = 13'b0 ;

always @(posedge clk_50)
begin
	
	if(counter1 < limit)
		counter1 = counter1 + 1;
	else 
	begin
		counter1 <= 0;
		clk = ~clk;
	end

end

always @(posedge clk_50)
begin
 
 counter <= ( counter >= 7'd99 ) ? 7'd0 : counter + 7'd1 ;
 
 _l1 <= (counter < DUTY_CYCLE ) ? l1:0;
 _l2 <= (counter < DUTY_CYCLE ) ? l2:0;
 _r1 <= (counter < DUTY_CYCLE ) ? r1:0;
 _r2 <= (counter < DUTY_CYCLE ) ? r2:0;
	
end

assign lef = _l1;
assign rig = _r1;
assign lp = _l2;
assign rp = _r2;


////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////