module c17_trojan (N1, N2, N3, N6, N7, N22, N23);

input N1, N2, N3, N6, N7;
output N22, N23;

wire N10, N11, N16, N19;
wire trojan_active;

nand NAND2_1 (N10, N1, N3);
nand NAND2_2 (N11, N3, N6);
nand NAND2_3 (N16, N2, N11);
nand NAND2_4 (N19, N11, N7);
nand NAND2_5 (N22_normal, N10, N16);
nand NAND2_6 (N23_normal, N16, N19);

// Trojan condition: if all inputs are high (N1 = N2 = N3 = N6 = N7 = 1), activate Trojan
assign trojan_active = N1 & N2 & N3 & N6 & N7;

// Normal outputs when Trojan is inactive
assign N22 = (trojan_active) ? 1'b0 : N22_normal;
assign N23 = (trojan_active) ? 1'b1 : N23_normal;

endmodule
