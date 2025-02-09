(* use_dsp = "yes" *) module butterfly 
#(
    parameter DATA_WIDTH = 12,

    localparam PRODUCT_DATA_WIDTH = DATA_WIDTH << 1
)
(
    input clk,
    input rst,

    // ------------------- INPUTS -------------------

    input signed [DATA_WIDTH - 1:0] a_real,
    input signed [DATA_WIDTH - 1:0] a_imag,

    input signed [DATA_WIDTH - 1:0] b_real,
    input signed [DATA_WIDTH - 1:0] b_imag,

    // Twiddle factor values
    input signed [DATA_WIDTH - 1:0] w_real,
    input signed [DATA_WIDTH - 1:0] w_imag,

    input valid_in,

    // ------------------- OUTPUTS -------------------

    output signed [DATA_WIDTH - 1:0] out_A_real,
    output signed [DATA_WIDTH - 1:0] out_A_imag,

    output signed [DATA_WIDTH - 1:0] out_B_real,
    output signed [DATA_WIDTH - 1:0] out_B_imag,

    output valid_out
);

    reg signed [DATA_WIDTH - 1:0] A_real_reg, A_imag_reg;
    reg signed [DATA_WIDTH - 1:0] B_real_reg, B_imag_reg;

    wire signed [PRODUCT_DATA_WIDTH - 1:0] a_real_product, a_imag_product; 
    wire signed [PRODUCT_DATA_WIDTH - 1:0] b_real_product, b_imag_product; 

    reg valid_out_r; 

    assign b_real_product = (b_real * w_real) - (b_imag * w_imag);
    assign b_imag_product = (b_imag * w_real) + (b_real * w_imag);

    assign out_A_real = $signed(A_real_reg) >>> DATA_WIDTH;
    assign out_A_imag = $signed(A_imag_reg) >>> DATA_WIDTH;

    always @( posedge clk )
    begin
        if (rst)
        begin
            A_real_reg <= '0;
            A_imag_reg <= '0;
            B_real_reg <= '0;
            B_imag_reg <= '0;
        end
        else
        begin
            if (valid_in)
            begin
                A_real_reg <= a_real + b_real_product;
                A_imag_reg <= a_imag + b_imag_product;
                B_real_reg <= a_real - b_real_product;
                B_imag_reg <= a_imag - b_imag_product;
            end
            else begin
                A_real_reg <= '0;
                A_imag_reg <= '0;
                B_real_reg <= '0;
                B_imag_reg <= '0;
            end        
        end
    end

    always @( posedge clk )
    begin
        if (rst)
        begin
            valid_out_r <= '0;
        end
        else
        begin
            if (valid_in)
            begin
                valid_out_r <= '1;
            end
            else begin
                valid_out_r <= '0;
            end
        end
    end
    
endmodule