module integrated_designs #(parameter NUM_PROJECTS = 13) (
    `ifdef USE_POWER_PINS
        inout vccd1,	// User area 1 1.8V supply
        inout vssd1,	// User area 1 digital ground
    `endif

    input logic clk, 
    input logic rst,
    input logic [3:0] design_select, 

    //gpio ports
    input logic [33:0] gpio_in, 
    output logic [33:0] gpio_oeb,
    output logic [33:0] gpio_out,

    //logic aanlyzer ports
    input logic [1:0] la_data_in,
    output logic [1:0] la_data_out,
    input logic [1:0] la_oenb,

    //wishbone specific ports
    input logic wbs_stb_i,
    input logic wbs_cyc_i,
    input logic wbs_we_i,
    input logic [3:0] wbs_sel_i;
    input logic [31:0] wbs_dat_i,
    input logic [31:0] wbs_adr_i,
    output logic wbs_ack_o,
    output logic [31:0] wbs_dat_o,

    //interrupt port
    output logic irq,
);

    logic n_rst;
    logic [33:0] designs_gpio_out[1:NUM_PROJECTS]; // start counting from 1 b/c of the design_select behavior
    logic [33:0] designs_gpio_oeb[1:NUM_PROJECTS]; 
    logic [NUM_PROJECTS:1] designs_cs; // active low chip select input for the designs.
    logic [NUM_PROJECTS:1] designs_n_rst;  // active low reset for each design 

    //wishbone output signals
    logic [NUM_PROJECTS:1] wbs_ack_design; //signal for design to acknowledge the wishbone bus
    logic [31:0] wbs_dat_design [1: NUM_PROJECTS]; //data signals for wishbone

    //la output signal
    logic [1:0] la_dat_design [1:NUM_PROJECTS]; //output from logic analyzer

    //processor interrupt
    logic [NUM_PROJECTS:1] irq_design; //processor interrupt lines

    assign n_rst = ~rst;  // invert reset to active low

    //hold all chip selects highs except design in use
    generate
        for(genvar i = 1; i <= NUM_PROJECTS; i++) begin
            assign designs_cs[i] = !(design_select == 4'di);
        end
    endgenerate

    //output multiplexing
    assign gpio_out = (design_select > 4'd0 && design_select <= NUM_PROJECTS) ? designs_gpio_out[design_select] : 'b0; 
    assign gpio_oeb = (design_select > 4'd0 && design_select <= NUM_PROJECTS) ? designs_gpio_oeb[design_select] : 'b0;
    assign la_data_out = (design_select > 4'd0 && design_select <= NUM_PROJECTS) ? la_dat_design[design_select] : 'b0;
    assign wbs_ack_o = (design_select > 4'd0 && design_select <= NUM_PROJECTS) ? wbs_ack_design[design_select] : 'b0;
    assign wbs_dat_o = (design_select > 4'd0 && design_select <= NUM_PROJECTS) ? wbs_dat_design[design_select] : 'b0;
    assign irq = (design_select > 4'd0 && design_select <= NUM_PROJECTS) ? irq_design[design_select] : 'b0;

    reset_router design_reset (

    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .clk(clk),
        .n_rst(n_rst),
        .designs_cs(designs_cs),
        .designs_n_rst(designs_n_rst)
    );

    /*
    Find your team's design and uncomment it here.

    !!!!!!DO THIS FIRST!!!!!!
    Update your wrapper module to correctly map the pins according to the spreadsheet

    Then you can uncomment and make sure the module name matches
    */

    //comment this when its time to give to students
    //ports may change depending on what sort of wrapper is used on the project
    sample_team_proj_Wrapper design_1
    (

    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .wb_clk_i(clk),
        .wb_rst_i(designs_n_rst[1]),
        .ncs(designs_cs[1]),

        //wishbone specific ports
        .wbs_stb_i(wbs_stb_i),
        .wbs_cyc_i(wbs_cyc_i),
        .wbs_we_i(wbs_we_i),
        .wbs_sel_i(wbs_sel_i),
        .wbs_dat_i(wbs_dat_i),
        .wbs_adr_i(wbs_adr_i),
        .wbs_ack_o(wbs_ack_design[1]),
        .wbs_dat_o(wbs_dat_design[1]),

        //gpio ports
        .gpio_in(gpio_in),
        .gpio_out(designs_gpio_out[1]), 
        .gpio_oeb(designs_gpio_oeb[1]),

        //logic analyzer ports
        .la_data_in(la_dat_in),
        .la_oenb(la_oenb),
        .la_data_out(la_dat_design[1]),

        //interrupt lines
        .irq(irq_design[1])
    );

    //add student project wrappers here

endmodule