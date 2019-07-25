module control(clk, resetn, go, touched, flag, collision, cur_state, bird_curr, wall_curr);
	input clk, resetn, flag, collision, go;
	output reg [3:0] cur_state;
	output [3:0] bird_curr, wall_curr;
	reg [3:0] next, cur_par_state;
	reg gogo;
	
	always@(posedge clk)
	begin
		if (go == 1'b0) gogo <= 1'b1;
	end
	//localparam WALL = 4'b1111, BIRD = 4'b1110;
	control_bird bird_controller(
		.clk(clk),
		.flag(flag),
		.resetn(resetn),
		.press_key(gogo),
		.touched(collision),
		.current(bird_curr));
	
	control_wall wall_controller(
		.go(gogo),
		.touched(collision),
		.clk(clk),
		.resetn(resetn),
		.current(wall_curr));
	
	always@(posedge clk)
        begin: state_table
        case(cur_par_state)
			/*
			BACKGROUND: begin
				next = wall_curr;
			end
			*/
			3'b000: begin
				cur_par_state <= 3'b001;
				next <= bird_curr;
			end
			3'b001: begin 
				cur_par_state <= 3'b000;
				next <= wall_curr;
			end
			default next <= wall_curr;
        endcase
        end
        
    //state register
    always@(posedge clk)
        begin: state_FFS
                if (!resetn)
                        cur_state <= wall_curr;
                else
                        cur_state <= next;
        end
endmodule
