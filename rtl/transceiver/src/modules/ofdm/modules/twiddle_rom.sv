module twiddle_rom 
#(
    parameter OFDM_WIDTH = 16,
    parameter DATA_WIDTH = 12,

    parameter TWIDDLE_FACTORS_FILE_PATH = "file.mem"
)
(
    input  [$clog2(OFDM_WIDTH)        - 1:0] index,
    output signed [DATA_WIDTH         - 1:0] w_real,
    output signed [DATA_WIDTH         - 1:0] w_imag
);

    (* rom_style = "block" *) reg [(DATA_WIDTH << 1) - 1:0] twiddle_factors_rom [(OFDM_WIDTH >> 1) - 1:0];

    initial
    begin
        $readmemh(TWIDDLE_FACTORS_FILE_PATH, twiddle_factors_rom);    
    end
    
    assign {w_real, w_imag} = twiddle_factors_rom[index];

endmodule