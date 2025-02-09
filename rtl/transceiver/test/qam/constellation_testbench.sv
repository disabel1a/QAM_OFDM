`timescale 10ns/1ns

module constellation_testbench;

    parameter POINTS = 128;
    parameter INTEGER_PART = 5;
    parameter SIMULATION = 1;

    reg signed [(INTEGER_PART << 1) - 1:0] constellation_points [POINTS - 1:0];

    constellation_former #(
        .POINTS(POINTS),
        .INTEGER_PART(INTEGER_PART),
        .SIMULATION(SIMULATION)
    )
    constellation_former_inst (
        .constellation_points(constellation_points)
    );

    initial begin
        #10;
        $stop;
    end
    
endmodule