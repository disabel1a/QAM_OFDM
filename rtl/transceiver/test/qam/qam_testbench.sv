`timescale 10ns/1ns

module qam_testbench;

    localparam POINTS = 16;
    localparam OUTPUT_DATA_WIDTH = 18;  // Q5.13 Format
    localparam INTEGER_PART = 5;
    localparam SIMULATION = 1;

    localparam INPUT_DATA_WIDTH = $clog2(POINTS);

    reg clk;

    wire signed [(INTEGER_PART << 1) - 1:0] constellation_points [POINTS - 1:0];

    constellation_former #(
        .POINTS(POINTS),
        .INTEGER_PART(INTEGER_PART),
        .SIMULATION(SIMULATION)
    )
    constellation_16
    (
        .constellation_points(constellation_points)
    );

    reg  [INPUT_DATA_WIDTH  - 1:0] data;
    wire [OUTPUT_DATA_WIDTH - 1:0] out_real, out_imag; 

    qam #(
        .POINTS(POINTS),
        .OUTPUT_DATA_WIDTH(OUTPUT_DATA_WIDTH),
        .INTEGER_PART(INTEGER_PART)
    )
    qam_16 (
        .data(data),
        .constellation_points(constellation_points),
        .out_real(out_real),
        .out_imag(out_imag)
    );

    initial
    begin
        clk = 0;
        forever
        begin
            #1;
            clk = ~clk;     
        end    
    end

    initial
    begin
        data = '0;
    end

    always @( posedge clk )
    begin
        data <= data + 'b1;
    end
    
endmodule