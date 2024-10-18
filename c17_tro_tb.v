module c17_trojan_tb;

reg N1, N2, N3, N6, N7;
wire N22, N23;

// Instantiate the Trojan-inserted c17 design
c17_trojan uut (
    .N1(N1), .N2(N2), .N3(N3), 
    .N6(N6), .N7(N7), 
    .N22(N22), .N23(N23)
);

initial begin
    // Test all possible input combinations
    $display("Trojan-inserted c17 Design");
    $monitor("Time=%0t, N1=%b, N2=%b, N3=%b, N6=%b, N7=%b => N22=%b, N23=%b", $time, N1, N2, N3, N6, N7, N22, N23);
    
    N1 = 0; N2 = 0; N3 = 0; N6 = 0; N7 = 0; #10;
    N1 = 0; N2 = 0; N3 = 0; N6 = 0; N7 = 1; #10;
    N1 = 0; N2 = 0; N3 = 0; N6 = 1; N7 = 0; #10;
    N1 = 0; N2 = 0; N3 = 0; N6 = 1; N7 = 1; #10;
    N1 = 0; N2 = 0; N3 = 1; N6 = 0; N7 = 0; #10;
    N1 = 0; N2 = 0; N3 = 1; N6 = 0; N7 = 1; #10;
    N1 = 0; N2 = 0; N3 = 1; N6 = 1; N7 = 0; #10;
    N1 = 0; N2 = 0; N3 = 1; N6 = 1; N7 = 1; #10;
    N1 = 1; N2 = 0; N3 = 0; N6 = 0; N7 = 0; #10;
    N1 = 1; N2 = 0; N3 = 0; N6 = 0; N7 = 1; #10;
    N1 = 1; N2 = 0; N3 = 0; N6 = 1; N7 = 0; #10;
    N1 = 1; N2 = 0; N3 = 0; N6 = 1; N7 = 1; #10;
    N1 = 1; N2 = 0; N3 = 1; N6 = 0; N7 = 0; #10;
    N1 = 1; N2 = 0; N3 = 1; N6 = 0; N7 = 1; #10;
    N1 = 1; N2 = 0; N3 = 1; N6 = 1; N7 = 0; #10;
    N1 = 1; N2 = 0; N3 = 1; N6 = 1; N7 = 1; #10;
    N1 = 1; N2 = 1; N3 = 0; N6 = 0; N7 = 0; #10;
    N1 = 1; N2 = 1; N3 = 0; N6 = 0; N7 = 1; #10;
    N1 = 1; N2 = 1; N3 = 0; N6 = 1; N7 = 0; #10;
    N1 = 1; N2 = 1; N3 = 0; N6 = 1; N7 = 1; #10;
    N1 = 1; N2 = 1; N3 = 1; N6 = 0; N7 = 0; #10;
    N1 = 1; N2 = 1; N3 = 1; N6 = 0; N7 = 1; #10;
    N1 = 1; N2 = 1; N3 = 1; N6 = 1; N7 = 0; #10;
    N1 = 1; N2 = 1; N3 = 1; N6 = 1; N7 = 1; #10;  // Activate Trojan

    $finish;
end

endmodule
