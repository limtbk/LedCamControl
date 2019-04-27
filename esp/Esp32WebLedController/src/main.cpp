#include <NeoPixelAnimator.h>
#include <NeoPixelBus.h>
#include <WiFi.h>

const uint16_t PixelCount = 16;
const uint8_t PixelPin = 5;

NeoPixelBus<NeoGrbFeature, Neo800KbpsMethod> strip(PixelCount, PixelPin);

NeoPixelAnimator animations(PixelCount);

WiFiServer server(80);

struct MyAnimationState {
    RgbColor StartingColor;
    RgbColor EndingColor;
};

MyAnimationState animationState[PixelCount];

void setRandomSeed() {
    uint32_t seed;

    seed = analogRead(0);
    delay(1);

    for (int shifts = 3; shifts < 31; shifts += 3) {
        seed ^= analogRead(0) << shifts;
        delay(1);
    }

    randomSeed(seed);
}

void blendAnimUpdate(const AnimationParam &param) {
    RgbColor updatedColor = RgbColor::LinearBlend(
        animationState[param.index].StartingColor,
        animationState[param.index].EndingColor, param.progress);
    strip.SetPixelColor(param.index, updatedColor);
}

void pickRandom(float luminance) {
    uint16_t count = random(PixelCount);
    while (count > 0) {
        uint16_t pixel = random(PixelCount);

        uint16_t time = random(100, 400);
        animationState[pixel].StartingColor = strip.GetPixelColor(pixel);
        animationState[pixel].EndingColor =
            HslColor(random(360) / 360.0f, 1.0f, luminance);

        animations.StartAnimation(pixel, time, blendAnimUpdate);

        count--;
    }
}

void turnOff() {
    RgbColor offColor = RgbColor(0, 0, 0);
    for (int i = 0; i < PixelCount; i++) {
        strip.SetPixelColor(i, offColor);
    }
    strip.Show();
}

void turnOn() {
    RgbColor onColor = RgbColor(5, 5, 5);
    for (int i = 0; i < PixelCount; i++) {
        strip.SetPixelColor(i, onColor);
    }
    strip.Show();
}

void setup() {
    Serial.begin(115200);

    strip.Begin();
    strip.Show();

    WiFi.mode(WIFI_AP_STA);
    WiFi.begin("LH", "ToyamasuticA");

    setRandomSeed();

    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }

    Serial.println("");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());

    server.begin();
    Serial.println("Server started");
}

void showReply(WiFiClient client) {
    client.println("HTTP/1.1 200 OK");
    client.println("Content-type:text/html");
    client.println();
    client.print(
        "Click <a href=\"/H\">here</a> to turn the random LEDs on.<br>");
    client.print(
        "Click <a href=\"/L\">here</a> to turn the random LEDs off.<br>");
    client.print("Click <a href=\"/S\">here</a> to turn the LEDs on.<br>");
    client.print("Click <a href=\"/R\">here</a> to turn the LEDs off.<br>");
    client.print(
        "Click <a href=\"/M009090900099909990999\">here</a> to set the LEDs "
        "color.<br>");
    client.println();
}

void processLine(String line) {
    int getInd = line.lastIndexOf("GET /");

    if (getInd >= 0) {
        String cmd = line.substring(getInd + 5);
        Serial.print("Command = ");
        Serial.println(cmd);

        if (cmd.startsWith("H")) {
            Serial.println("High");
            pickRandom(0.1f);
        } else if (cmd.startsWith("L")) {
            Serial.println("Low");
            pickRandom(0.0f);
        } else if (cmd.startsWith("R")) {
            Serial.println("Reset");
            turnOff();
        } else if (cmd.startsWith("S")) {
            Serial.println("Set");
            turnOn();
        } else if (cmd.startsWith("M")) {
            Serial.println("Multi");
            String dat = cmd.substring(1);
            uint8_t r, g, b;
            for(int i = 0; i < dat.length(); i++) {
                char c = dat.charAt(i);
                if ((c >= '0') && (c <='9')) {
                    switch (i % 3) {
                        case 0: {
                            r = c - '0';
                            break;
                        }
                        case 1: {
                            g = c - '0';
                            break;
                        }
                        case 2: {
                            b = c - '0';
                            RgbColor color = RgbColor(r, g, b);
                            strip.SetPixelColor(i / 3, color);
                            break;
                        }
                        default:
                            break;
                    }
                } else {
                    break;
                }
            }
            strip.Show();
        }
    }
}

void processConnection() {
    WiFiClient client = server.available();
    if (client) {
        Serial.println();
        Serial.println("New Client");
        String currentLine = "";
        while (client.connected()) {
            if (client.available()) {
                char c = client.read();
                Serial.write(c);
                if (c == '\n') {
                    if (currentLine.length() == 0) {
                        showReply(client);
                        break;
                    } else {
                        processLine(currentLine);
                        currentLine = "";
                    }
                } else if (c != '\r') {
                    currentLine += c;
                }
            }
        }
        client.stop();
        Serial.println("Client Disconnected.");
    }
}

void loop() {
    processConnection();

    if (animations.IsAnimating()) {
        animations.UpdateAnimations();
        strip.Show();
    } else {
        //      PickRandom(0.1f); // 0.0 = black, 0.25 is normal, 0.5 is bright
    }
}