module avalon (
    input wire clk,
    input wire resetn,
    output reg valid,
    input wire ready,
    output reg [7:0] data
);

	// definição dos estados como parâmetros
	parameter IDLE = 2'b00,
	        SEND_4 = 2'b01, 
	        SEND_5 = 2'b10,
	        SEND_6 = 2'b11;

	reg [1:0] estado, proximo_estado;

	// registro de estado atual
	always @(posedge clk or posedge resetn) begin
		estado = (resetn == 1) ? IDLE : proximo_estado;
	end

	// lógica de transição de estado
	always @(*) begin
		case (estado)
			IDLE: proximo_estado = (ready == 1) ? SEND_4 : IDLE;
			SEND_4: proximo_estado = (ready == 1) ? SEND_5 : SEND_4;
			SEND_5: proximo_estado = (ready == 1) ? SEND_6 : SEND_5;
			SEND_6: proximo_estado = (ready == 1) ? IDLE : SEND_6;
			default: proximo_estado = IDLE;
		endcase
	end
	
	// lógica de saída
	always @(*) begin
		// valores padrão
		valid = 0;
		data = 8'd0;
		
		case (estado)
			SEND_4: begin 
				valid = 1;
				data = 8'd4;
			end

			SEND_5: begin 
				valid = 1;
				data = 8'd5;
			end
			
			SEND_6: begin
				valid = 1;
				data = 8'd6;
			end
		endcase
	end

endmodule

