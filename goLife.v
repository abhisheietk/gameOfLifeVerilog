module golife #(
	parameter SIDEWIDTH = 10
)(
	clk,
	rst,
	load,
	run,
	ingrid,
	grid
);

    input	wire	clk;
    input	wire	rst;
    input	wire	load;
    input	wire	run;
    input	wire	[SIDEWIDTH-1:0][SIDEWIDTH-1:0]	ingrid;
    output	wire	[SIDEWIDTH-1:0][SIDEWIDTH-1:0]	grid;
    
    genvar i, j;
    generate
        for (i = 0; i < SIDEWIDTH; i = i + 1) begin: row
            for (j = 0; j < SIDEWIDTH; j = j + 1) begin: column

                game_cell game_cell_inst(
                    .clk(clk),
                    .rst(rst),
                    .load(load),
                    .run(run),
                    .right_upper(grid[(SIDEWIDTH+(i+1))%SIDEWIDTH][(SIDEWIDTH+(j+1))%SIDEWIDTH]),
                    .right      (grid[(SIDEWIDTH+(i  ))%SIDEWIDTH][(SIDEWIDTH+(j+1))%SIDEWIDTH]),
                    .right_lower(grid[(SIDEWIDTH+(i-1))%SIDEWIDTH][(SIDEWIDTH+(j+1))%SIDEWIDTH]),
                    .lower      (grid[(SIDEWIDTH+(i-1))%SIDEWIDTH][(SIDEWIDTH+(j  ))%SIDEWIDTH]),
                    .left_lower (grid[(SIDEWIDTH+(i-1))%SIDEWIDTH][(SIDEWIDTH+(j-1))%SIDEWIDTH]),
                    .left       (grid[(SIDEWIDTH+(i  ))%SIDEWIDTH][(SIDEWIDTH+(j-1))%SIDEWIDTH]),
                    .left_upper (grid[(SIDEWIDTH+(i+1))%SIDEWIDTH][(SIDEWIDTH+(j-1))%SIDEWIDTH]),
                    .upper      (grid[(SIDEWIDTH+(i+1))%SIDEWIDTH][(SIDEWIDTH+(j  ))%SIDEWIDTH]),
                    .self       (grid[(SIDEWIDTH+(i  ))%SIDEWIDTH][(SIDEWIDTH+(j  ))%SIDEWIDTH]),
                    .inself     (ingrid[i][j]));
            end
        end
    endgenerate

endmodule    
  
module game_cell(
    clk,
    rst,
    load,
    run,
    right_upper,
    right,
    right_lower,
    lower,
    left_lower,
    left,
    left_upper,
    upper,
    self,
    inself
);
  
    input wire clk;
    input wire rst;
    input wire load;
    input wire run;
    input wire right_upper;
    input wire right;
    input wire right_lower;
    input wire lower;
    input wire left_lower;
    input wire left;
    input wire left_upper;
    input wire upper;
    output reg self;
    input wire inself;
  
    parameter LIVE = 1'b1;
    parameter DEAD = 1'b0;

    reg state;
    wire [3:0] liveCells;

    assign liveCells = right_upper + right + right_lower + lower + left_lower + left + left_upper + upper;
  
    always @(posedge clk) begin
        if (rst) begin
            self <= DEAD;
        end
        else begin
            if (load) begin
                self <= inself;
            end
            else if (run) begin
                //Any live cell with fewer than two live neighbors dies, as if by under population.
                if (liveCells < 2) begin
                    self <= DEAD;
                end

                //Any live cell with two or three live neighbors lives on to the next generation.
                //else if (liveCells = 2 | liveCells = 3) begin
                //  if (self == LIVE) begin
                //    self <= LIVE;
                //  end
                //end

                //Any live cell with more than three live neighbors dies, as if by overpopulation.
                else if (liveCells > 3) begin
                    self <= DEAD;
                end

                //Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.
                else if (liveCells == 3) begin
                    self <= LIVE;
                end
            end
        end
    end
    
endmodule
