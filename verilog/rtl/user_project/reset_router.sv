module reset_router #(parameter NUM_PROJECTS = 13) (

`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    input clk,
    input n_rst,
    input [NUM_PROJECTS:1] designs_cs,
    output wire [NUM_PROJECTS:1] designs_n_rst
);

    logic [NUM_PROJECTS:1] cs_n_rst;
    assign cs_n_rst[1] = n_rst & ~designs_cs[1];
    async_reset_sync designs_sync_rst_1 (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif
        .clk,
        .asyncrst_n(cs_n_rst[1]),
        .n_rst(designs_n_rst[1])
    );

    //add student projects here:

endmodule

module async_reset_sync (

`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    input logic clk,
    input logic asyncrst_n,
    output logic n_rst
);
    logic rff;
    logic next_n_rst;
    assign next_n_rst = rff;

    always_ff @ (posedge clk, negedge asyncrst_n) begin
        if(!asyncrst_n) begin
            n_rst <= 1'b0;
            rff <= 1'b0;
        end else begin
            n_rst <= next_n_rst;
            rff <= 1'b1;
        end
    end
endmodule