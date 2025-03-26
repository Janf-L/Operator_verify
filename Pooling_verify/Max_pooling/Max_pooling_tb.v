`timescale 1ns/1ps

module Max_pooling_tb;
    // Parameters
    parameter H = 3;
    parameter W = 4;
    parameter POOL_SIZE = 2;
    parameter S = 1;
    parameter OUTPUT_H = ((H - POOL_SIZE) / S + 1);
    parameter OUTPUT_W = ((W - POOL_SIZE) / S + 1);
    parameter DATA_WIDTH = 4;
    
    // Signals
    reg clk;
    reg rst_n;
    reg start;
    reg [0:(DATA_WIDTH*H*W-1)] input_data;
    wire [0:(DATA_WIDTH*OUTPUT_H*OUTPUT_W-1)] output_data;
    wire done;

    integer i, j;
    
    // Instantiate the max_pooling module
    Max_pooling #(
        .H(H),
        .W(W),
        .POOL_SIZE(POOL_SIZE),
        .S(S),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .input_data(input_data),
        .output_data(output_data),
        .done(done)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end
    
    // Function to set value in the input array
    task set_input;
        input [0:DATA_WIDTH-1] row;
        input [0:DATA_WIDTH-1] col;
        input [0:DATA_WIDTH-1] value;
        begin
            input_data[((row*W+col)*DATA_WIDTH) +: DATA_WIDTH] = value;
        end
    endtask
    
    // Function to get value from the output array
    function [0:DATA_WIDTH-1] get_output;
        input [0:DATA_WIDTH-1] row;
        input [0:DATA_WIDTH-1] col;
        begin
            get_output = output_data[((row*OUTPUT_W+col)*DATA_WIDTH) +: DATA_WIDTH];
        end
    endfunction
    
    // Test sequence
    initial begin
        // Initialize inputs
        rst_n = 0;
        start = 0;
        input_data = 0;
        
        // Initialize the input data array with values from the C++ example
        set_input(0, 0, 1); set_input(0, 1, 2); set_input(0, 2, 3); set_input(0, 3, 4);
        set_input(1, 0, 6); set_input(1, 1, 5); set_input(1, 2, 6); set_input(1, 3, 5);
        set_input(2, 0, 7); set_input(2, 1, 8); set_input(2, 2, 9); set_input(2, 3, 5);
        
        // Reset the system
        #20 rst_n = 1;
        
        // Start processing
        #10 start = 1;
        #10 start = 0;
        
        // Wait for completion
        wait(done);
        
        // Display results
        $display("Input Matrix:");
        for (i = 0; i < H; i = i + 1) begin
            for (j = 0; j < W; j = j + 1) begin
                $write("%d ", input_data[((i*W+j)*DATA_WIDTH) +: DATA_WIDTH]);
            end
            $write("\n");
        end
        
        $display("Output Matrix after Max Pooling:");
        for (i = 0; i < OUTPUT_H; i = i + 1) begin
            for (j = 0; j < OUTPUT_W; j = j + 1) begin
                $write("%d ", get_output(i, j));
            end
            $write("\n");
        end
        
        #100 $finish;
    end

    initial begin
        $dumpfile("./output/Max_pooling_tb.vcd");
        $dumpvars(0, Max_pooling_tb);
    end

endmodule