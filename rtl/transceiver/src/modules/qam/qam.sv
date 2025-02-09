`timescale 10ns/1ns

module qam 
#(
    parameter POINTS = 16,
    parameter OUTPUT_DATA_WIDTH = 18,  // Q5.13 Format
    parameter INTEGER_PART = 5,

    localparam INPUT_DATA_WIDTH = $clog2(POINTS),
    localparam FIX_POINT_PART = OUTPUT_DATA_WIDTH - INTEGER_PART
)
(
    input [INPUT_DATA_WIDTH    - 1:0] data,
    input [(INTEGER_PART << 1) - 1:0] constellation_points [POINTS - 1:0],

    output [OUTPUT_DATA_WIDTH - 1:0] out_real,
    output [OUTPUT_DATA_WIDTH - 1:0] out_imag
);

    //assign {out_imag[(OUTPUT_DATA_WIDTH - 1) -: INTEGER_PART], out_real[(OUTPUT_DATA_WIDTH - 1) -: INTEGER_PART]} = constellation_points[data];

    reg [FIX_POINT_PART - 1:0] zeros;
    initial zeros = '0;

    assign out_imag = {constellation_points[data][INTEGER_PART +: INTEGER_PART], zeros};
    assign out_real = {constellation_points[data][0            +: INTEGER_PART], zeros};

endmodule