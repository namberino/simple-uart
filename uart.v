module uart_rx(
    input clk,
    input rst,
    output reg[7:0] data, // received data
    input enable, // receive enable signal
    output reg ready // received data ready indicator
);

    reg[3:0] baud_counter = 4'd0;
    reg[9:0] bit_counter = 10'd0;
    reg rx_bit;
    reg[7:0] rx_data;

    always @ (posedge clk or posedge rst)
    begin
        if (rst)
        begin
            baud_counter <= 4'd0;
            bit_counter <= 10'd0;
            ready <= 1'b0;
        end else if (enable)
        begin
            // baud rate generation
            if (baud_counter == 4'd15)
            begin
                baud_counter <= 4'd0;

                // data reception
                if (bit_counter < 10'd9)
                begin
                    rx_bit <= data;
                    bit_counter <= bit_counter + 1'b1;
                    rx_data[bit_counter - 1] <= rx_bit;
                end else
                begin
                    // end of reception
                    bit_counter <= 10'd0;
                    ready <= 1'b1;
                end
            end else
            begin
                baud_counter <= baud_counter + 1'b1;
            end
        end
    end

endmodule

