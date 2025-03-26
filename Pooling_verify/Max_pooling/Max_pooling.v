module Max_pooling #(
    parameter H = 3,             // Input height
    parameter W = 4,             // Input width
    parameter POOL_SIZE = 2,     // Pooling window size
    parameter S = 1,             // Stride
    parameter OUTPUT_H = ((H - POOL_SIZE) / S + 1),  // Output height
    parameter OUTPUT_W = ((W - POOL_SIZE) / S + 1),  // Output width
    parameter DATA_WIDTH = 8     // Data width in bits
)(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [0:(DATA_WIDTH*H*W-1)] input_data,
    output reg [0:(DATA_WIDTH*OUTPUT_H*OUTPUT_W-1)] output_data,
    output reg done
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam PROCESSING = 2'b01;
    localparam COMPLETE = 2'b10;
    
    reg [1:0] state, next_state;
    reg [0:$clog2(OUTPUT_H)] oh;
    reg [0:$clog2(OUTPUT_W)] ow;
    reg [0:$clog2(POOL_SIZE)] i, j;
    reg [0:(DATA_WIDTH-1)] max_val;
    reg [0:(DATA_WIDTH-1)] curr_val;
    reg store_flag;
    
    // Control state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? PROCESSING : IDLE;
            PROCESSING: next_state = (oh == OUTPUT_H-1 && ow == OUTPUT_W-1 && i == POOL_SIZE-1 && store_flag) ? COMPLETE : PROCESSING;
            COMPLETE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    // Get value from 1D input array representing 2D data
    function [0:DATA_WIDTH-1] get_input;
        input [0:DATA_WIDTH-1] row;
        input [0:DATA_WIDTH-1] col;
        begin
            get_input = input_data[((row*W+col)*DATA_WIDTH) +: DATA_WIDTH];
        end
    endfunction
    
    // Main processing logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            oh <= 0;
            ow <= 0;
            i <= 0;
            j <= 0;
            done <= 0;
            max_val <= 0;
            output_data <= 0;
            store_flag <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        oh <= 0;
                        ow <= 0;
                        i <= 0;
                        j <= 0;
                        done <= 0;
                        max_val <= 0;
                    end
                end
                PROCESSING: begin
                    // Handle the store flag first
                    if (store_flag) begin
                        // Store result in output
                        output_data[((oh*OUTPUT_W+ow)*DATA_WIDTH) +: DATA_WIDTH] <= max_val;
                        store_flag <= 0;
                        
                        // Move to next output position
                        if (ow < OUTPUT_W-1) begin
                            ow <= ow + 1;
                        end else begin
                            ow <= 0;
                            if (oh < OUTPUT_H-1) begin
                                oh <= oh + 1;
                            end
                        end
                        
                        // Reset i and j and initialize max_val for next window
                        i <= 0;
                        j <= 0;
                        max_val <= {1'b1, {(DATA_WIDTH-1){1'b0}}};
                    end else begin
                        // Processing logic for each output position
                        if (i == 0 && j == 0 && !store_flag) begin
                            // Initialize max_val at the start of each pooling window
                            max_val <= {1'b1, {(DATA_WIDTH-1){1'b0}}};
                        end
                        
                        // Calculate position in the input array
                        if ((oh*S + i) < H && (ow*S + j) < W) begin
                            // Extract current input value
                            curr_val = get_input(oh*S + i, ow*S + j);
                            
                            // Update max value if current value is larger
                            if (curr_val > max_val || (i == 0 && j == 0)) begin
                                max_val <= curr_val;
                            end
                        end                
                        // Update pooling window position
                        if (j < POOL_SIZE-1) begin
                            j <= j + 1;
                        end else begin
                            j <= 0;
                            if (i < POOL_SIZE-1) begin
                                i <= i + 1;
                            end else begin
                                // We've processed the entire pooling window
                                // Set flag to store the result in the next cycle
                                store_flag <= 1;
                            end
                        end
                    end
                end
                
                COMPLETE: begin
                    done <= 1;
                end
            endcase
        end
    end

endmodule