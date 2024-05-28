module integrated_designs #(parameter NUM_PROJECTS = 13) (
    `ifdef USE_POWER_PINS
        inout vccd1,	// User area 1 1.8V supply
        inout vssd1,	// User area 1 digital ground
    `endif

    input logic clk, 
    input logic rst,

    input logic [3:0] design_select, 
    /* 
    if design select == 0, no design is selected.
    If design_select == 1, design_1 is selected 
    If design_select == 2, design_2 is selected
    ...
    Up to design_15
    */

    input logic [33:0] gpio_in, 
    
    output logic [33:0] gpio_oeb,
    output logic [33:0] gpio_out
);

    logic n_rst;
    logic [33:0] designs_gpio_out[1:NUM_PROJECTS]; // start counting from 1 b/c of the design_select behavior
    logic [33:0] designs_gpio_oeb[1:NUM_PROJECTS]; 
    logic [NUM_PROJECTS:1] designs_cs; // active low chip select input for the designs.
    logic [NUM_PROJECTS:1] designs_n_rst;  // active low reset for each design

    assign n_rst = ~rst;  // invert reset to active low

    //these values will be based on the assumption of 15 designs, may need to be changed
    assign gpio_out = (design_select > 4'd0 && design_select <= 4'd13) ? designs_gpio_out[design_select] : 'b0; 
    assign gpio_oeb = (design_select > 4'd0 && design_select <= 4'd13) ? designs_gpio_oeb[design_select] : 'b1;

    assign designs_cs[1] = !(design_select == 4'd1);
    assign designs_cs[2] = !(design_select == 4'd2);
    assign designs_cs[3] = !(design_select == 4'd3);
    assign designs_cs[4] = !(design_select == 4'd4);
    assign designs_cs[5] = !(design_select == 4'd5);
    assign designs_cs[6] = !(design_select == 4'd6);
    assign designs_cs[7] = !(design_select == 4'd7);
    assign designs_cs[8] = !(design_select == 4'd8);
    assign designs_cs[9] = !(design_select == 4'd9);
    assign designs_cs[10] = !(design_select == 4'd10);
    assign designs_cs[11] = !(design_select == 4'd11);
    assign designs_cs[12] = !(design_select == 4'd12);
    assign designs_cs[13] = !(design_select == 4'd13);
    //assign designs_cs[14] = !(design_select == 4'd14);
    //assign designs_cs[15] = !(design_select == 4'd15);

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
    Miguels_Wrapper design_1
    (

    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .clk(clk),
        .n_rst(designs_n_rst[1]),
        .ncs(designs_cs[1]), 

        .gpio_in(gpio_in),
        .gpio_out(designs_gpio_out[1]), 
        .gpio_oeb(designs_gpio_oeb[1])
    );

    //add student project wrappers here

endmodule