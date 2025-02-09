`timescale 10ns/1ns

module constellation_former
#(
    parameter POINTS = 16,
    parameter INTEGER_PART = 5,
    parameter SIMULATION = 0,

    localparam INPUT_DATA_WIDTH = $clog2(POINTS)
)
(
    output signed [(INTEGER_PART << 1) - 1:0] constellation_points [POINTS - 1:0]
);

    (* rom_style = "block" *) reg signed [(INTEGER_PART << 1) - 1:0] constellation_points_r [POINTS - 1:0];

    reg [INPUT_DATA_WIDTH:0] addr;
    reg signed [INTEGER_PART - 1:0] real_val, imag_val;
    reg [INTEGER_PART - 1:0] border_value;

    assign constellation_points = constellation_points_r; 

    initial constellation_points_r = '{default: '0};

    initial
    begin
        if (INPUT_DATA_WIDTH % 2 == 0)
        begin
            even_pow_generator();
        end
        else begin
            odd_pow_generator();
        end
    end

    function [INPUT_DATA_WIDTH - 1:0] gray_code;
        input [INPUT_DATA_WIDTH - 1:0] bin;

        begin
            gray_code = bin ^ (bin >> 1);
        end
        
    endfunction

    task odd_pow_generator();
        border_value = (2 ** ((INPUT_DATA_WIDTH / 2) + 1)) - 1;

        real_val = (-border_value) + 'd2;
        imag_val = -border_value;

        if (SIMULATION)
        begin
            $display("QAM-%d constellation point with GRAY-code", POINTS);
        end

        for (addr = '0; addr < POINTS; addr = addr + 'b1)
        begin
            
            constellation_points_r[gray_code(addr)] = {imag_val, real_val};

            if (SIMULATION)
            begin
                $display("%b|\t%b|\t%d|\t%d|", addr, gray_code(addr), imag_val, real_val);
            end

            if (real_val == border_value)
            begin
                imag_val += 'd2;
                real_val = -border_value;
                continue;
            end
            else if (real_val == (border_value - 'd2))
            begin
                imag_val += 'd2;
                real_val = (-border_value) + 'd2;
                continue;
            end

            real_val += 'd4;
        end
    endtask

    task even_pow_generator();
        border_value = (2 ** (INPUT_DATA_WIDTH / 2)) - 1;

        real_val = -border_value;
        imag_val = -border_value;

        if (SIMULATION)
        begin
            $display("QAM-%d constellation point with GRAY-code", POINTS);
        end

        for (addr = '0; addr < POINTS; addr = addr + 'b1)
        begin
            
            constellation_points_r[gray_code(addr)] = {imag_val, real_val};

            if (SIMULATION)
            begin
                $display("%b|\t%b|\t%d|\t%d|", addr, gray_code(addr), imag_val, real_val);
            end

            if (real_val == border_value)
            begin
                imag_val += 'd2;
                real_val = -(border_value);

                continue;
            end

            real_val += 'd2;
        end
    endtask
    
endmodule