module golife_tb#(parameter SIDEWIDTH = 16)();
    reg clk;
    reg rst;
    reg load;
    reg run;
    integer i;

    wire [SIDEWIDTH-1:0][SIDEWIDTH-1:0] ingrid;
    wire [SIDEWIDTH-1:0][SIDEWIDTH-1:0] grid;

    assign ingrid = {
                    16'b0000000000000000,
                    16'b0001000000000100,
                    16'b0000100000000010,
                    16'b0011100000001110,
                    16'b0000000000000000,
                    16'b0000000000000000,
                    16'b0000000010000000,
                    16'b0000000001000000,
                    16'b0000000111000000,
                    16'b0000000000000000,
                    16'b0000000000000000,
                    16'b0001000000000100,
                    16'b0000100000000010,
                    16'b0011100000001110,
                    16'b0000000000000000,
                    16'b0000000000000000};

    golife golife_inst(
        .clk(clk),
        .rst(rst),
        .load(load),
        .run(run),
        .ingrid(ingrid),
        .grid(grid));
        defparam golife_inst.SIDEWIDTH = SIDEWIDTH;


    always begin
        #1 clk = !clk;
    end
  
    initial begin
        clk = 0;
        rst = 0;
        load = 0;
        run = 0;
        $display("game of life");
        $dumpfile("game_cell_tb.vcd");

        $dumpvars();
        #5 reset();
        printGrid();
        loadGrid();
        printGrid();
        startRunGrid();
        printGrid();
        for (i=0; i<1000; i = i +1)
        begin
            startRunGrid();
            printGrid();
        end
        stopRunGrid();
        #10 $finish;
    end
  
    task reset;
        begin
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
        end
    endtask
  
    task loadGrid;
        begin
            $display("Loading");
            @(posedge clk);
            load = 1;
            @(posedge clk);
            load = 0;
        end
    endtask

    task startRunGrid;
        begin
            $display("Running");
            @(posedge clk);
            run = 1;
        end
    endtask

    task stopRunGrid;
        begin
            @(posedge clk);
            run = 0;
        end
    endtask

    task printGrid;
    integer i;
    begin
	    $display("");
	    for (i=0; i < SIDEWIDTH; i = i+1)
	    begin
           	$display("%b",grid[SIDEWIDTH-1-i]);
		end
	end
    endtask
  
endmodule