module KlimaOtomasyonu(
    input wire clk, // clock sinyali
    input wire reset, // reset sinyali
    input wire sicaklik, // Sıcaklık sensöründen okunacak olan veri
    output reg blueLED, // Mavi LED 
    output reg greenLED, // Yeşil LED 
    output reg redLED  // Kırmızı LED 
    );

    // Durum tanımlamaları
    parameter [1:0] DEFAULT = 2'b00; // ışık yanmıyor varsayılan durum
    parameter [1:0] MAVI = 2'b01; // soğuk
    parameter [1:0] YESIL = 2'b10; // oda sıcaklığı
    parameter [1:0] KIRMIZI = 2'b11; // sıcak
    
    reg [1:0] durum; // Klimanın durumu
    reg signed [7:0] temp; // Sensörden gelen sıcaklığı kullanmak için bir geçici değişken

    // Sıcaklık değerinin atanması
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            temp <= 0;
        end else begin
            temp <= sicaklik;
        end
    end

    // Klimanın durumları
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            durum <= DEFAULT;
        end else begin
            case (durum)
                DEFAULT: begin
                    if (temp <= 20) begin
                        durum <= MAVI;
                    end else if (temp > 20 && temp <= 30) begin
                        durum <= YESIL;
                    end else if (temp > 30) begin
                        durum <= KIRMIZI;
                    end
                end 

                MAVI: begin
                    if (temp > 20) begin
                        durum <= DEFAULT;
                    end
                end

                YESIL: begin
                    if (temp <= 20 || temp > 30) begin
                        durum <= DEFAULT;
                    end
                end

                KIRMIZI: begin
                    if (temp <= 30) begin
                        durum <= DEFAULT;
                    end
                end
            endcase
        end
    end

    // LED kontrolü
    always @(posedge clk) begin
        case (durum)
            DEFAULT: begin
                blueLED <= 0;
                greenLED <= 0;
                redLED <= 0;
            end

            MAVI: begin
                blueLED <= 1;
                greenLED <= 0;
                redLED <= 0;
            end

            YESIL: begin
                blueLED <= 0;
                greenLED <= 1;
                redLED <= 0;
            end

            KIRMIZI: begin
                blueLED <= 0;
                greenLED <= 0;
                redLED <= 1;
            end
        endcase
    end

endmodule
