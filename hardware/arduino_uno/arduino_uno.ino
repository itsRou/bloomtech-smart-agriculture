/*
  BloomTech - Arduino Uno controller
  ===================================
  STATUS: Best-effort reference implementation written from the project's
  thesis description (chapters 3 and 5). It has NOT been tested on real
  hardware as part of this change - no Arduino/ESP32 source existed in the
  repository before this file. Treat pin numbers, calibration constants, and
  thresholds below as starting points to verify against your own wiring and
  calibrated sensors (thesis section 3.4 describes the intended calibration
  procedure: pH 4.0/7.0/10.0 buffer solutions, dry/moist/saturated soil
  samples, etc.).

  Role (thesis 5.1): the Arduino Uno reads all sensors and owns the
  threshold/actuator logic. It talks to the ESP32 over a serial link; the
  ESP32's only job is bridging that data to Firebase and back (see
  esp32_gateway.ino in the sibling folder).

  Wiring assumed (adjust to match your build):
    A0  - Soil moisture sensor (analog, capacitive or resistive)
    A1  - pH sensor analog output
    A2  - LDR (light dependent resistor) voltage divider
    D2  - DHT11 temperature/humidity sensor (digital, one-wire protocol)
    D4  - Relay 1: main irrigation pump
    D5  - Relay 2: acid solution pump (lowers pH when soil is too alkaline)
    D6  - Relay 3: alkaline/base solution pump (raises pH when too acidic)
    D8  - SoftwareSerial RX (from ESP32 TX)
    D9  - SoftwareSerial TX (to ESP32 RX)
  The hardware USB Serial (pins 0/1) is left free for the Arduino IDE Serial
  Monitor, matching the thesis's mention of dual Serial Monitor + Firebase
  output (section 3.4, Phase 2).

  Relay modules referenced in the thesis are low-level triggered (thesis
  5.1); RELAY_ON/RELAY_OFF below assume that. Flip them if yours are
  active-high.

  Data contract with the ESP32 (see esp32_gateway.ino):
    Uno -> ESP32, one JSON line per read cycle:
      {"soil":<raw 0-1023>,"ph":<computed pH>,"ldr":<raw 0-1023>,"temp":<C>}
    ESP32 -> Uno, forwarded admin-configured plant targets from the app's
    "Add Plant" screen (Firebase paths /soil_statues, /ph_statues,
    /temperature - see lib/Pages/main_pages/add_screen.dart). These are
    informational labels only; they are logged but NOT auto-mapped to the
    numeric thresholds below, because no such mapping is defined anywhere
    in the project's documentation or code. Tune SOIL_DRY_THRESHOLD_RAW /
    PH_LOW / PH_HIGH yourself for your actual plants and calibrated sensors.
      {"soil_status":"<string>","ph_status":"<string>","temp_target":<number>}
*/

#include <SoftwareSerial.h>
#include <DHT.h>
#include <ArduinoJson.h>

// ---------- Pin assignments ----------
#define PIN_SOIL A0
#define PIN_PH A1
#define PIN_LDR A2
#define PIN_DHT 2
#define PIN_RELAY_IRRIGATION 4
#define PIN_RELAY_ACID 5
#define PIN_RELAY_ALKALINE 6
#define PIN_ESP_RX 8  // Arduino RX <- ESP32 TX
#define PIN_ESP_TX 9  // Arduino TX -> ESP32 RX

#define DHTTYPE DHT11
DHT dht(PIN_DHT, DHTTYPE);
SoftwareSerial espSerial(PIN_ESP_RX, PIN_ESP_TX);

// ---------- Relay logic ----------
// Thesis 5.1: "relay modules... low-level triggered". Flip if needed.
const int RELAY_ON = LOW;
const int RELAY_OFF = HIGH;

// ---------- Tunable thresholds (calibrate per thesis 3.4) ----------
const int SOIL_DRY_THRESHOLD_RAW = 600;   // higher raw = drier for typical
                                           // resistive/capacitive sensors
const float PH_LOW_THRESHOLD = 5.5;       // below this: too acidic
const float PH_HIGH_THRESHOLD = 7.5;      // above this: too alkaline

// pH probe calibration (thesis 3.4: calibrate with pH 4.0/7.0/10.0 buffers).
// Placeholder linear mapping - REPLACE with your probe's actual calibration.
const float PH_VOLTAGE_SLOPE = -5.70;
const float PH_VOLTAGE_INTERCEPT = 21.34;

// ---------- Safety / debounce ----------
const unsigned long READ_INTERVAL_MS = 30000;   // thesis 3.4 Phase 2: "read
                                                 // sensors every 30 seconds"
const unsigned long PUMP_COOLDOWN_MS = 60000;   // minimum time between two
                                                 // activations of the same
                                                 // pump (thesis 3.5: "relay
                                                 // cooldowns")
const unsigned long PUMP_RUN_MS = 5000;         // how long a pump stays on
                                                 // per activation

unsigned long lastReadAt = 0;
unsigned long irrigationLastRun = 0;
unsigned long acidPumpLastRun = 0;
unsigned long alkalinePumpLastRun = 0;

void setup() {
  Serial.begin(9600);
  espSerial.begin(9600);
  dht.begin();

  pinMode(PIN_RELAY_IRRIGATION, OUTPUT);
  pinMode(PIN_RELAY_ACID, OUTPUT);
  pinMode(PIN_RELAY_ALKALINE, OUTPUT);
  digitalWrite(PIN_RELAY_IRRIGATION, RELAY_OFF);
  digitalWrite(PIN_RELAY_ACID, RELAY_OFF);
  digitalWrite(PIN_RELAY_ALKALINE, RELAY_OFF);

  Serial.println("BloomTech Arduino Uno controller starting...");
}

void loop() {
  handleIncomingFromEsp();

  unsigned long now = millis();
  if (now - lastReadAt >= READ_INTERVAL_MS) {
    lastReadAt = now;
    readAndActOnSensors();
  }
}

void readAndActOnSensors() {
  int soilRaw = analogRead(PIN_SOIL);
  int ldrRaw = analogRead(PIN_LDR);
  float phValue = readPh();
  float tempC = dht.readTemperature();
  if (isnan(tempC)) {
    tempC = 0; // DHT11 read failure fallback
  }

  Serial.print("soil="); Serial.print(soilRaw);
  Serial.print(" ph="); Serial.print(phValue);
  Serial.print(" ldr="); Serial.print(ldrRaw);
  Serial.print(" tempC="); Serial.println(tempC);

  applyIrrigationLogic(soilRaw);
  applyPhCorrectionLogic(phValue);

  sendReadingsToEsp(soilRaw, phValue, ldrRaw, tempC);
}

float readPh() {
  int raw = analogRead(PIN_PH);
  float voltage = raw * (5.0 / 1023.0);
  return PH_VOLTAGE_SLOPE * voltage + PH_VOLTAGE_INTERCEPT;
}

void applyIrrigationLogic(int soilRaw) {
  unsigned long now = millis();
  bool tooDry = soilRaw >= SOIL_DRY_THRESHOLD_RAW;
  bool cooldownElapsed = (now - irrigationLastRun) >= PUMP_COOLDOWN_MS;

  if (tooDry && cooldownElapsed) {
    Serial.println("Irrigation: soil dry, activating pump.");
    digitalWrite(PIN_RELAY_IRRIGATION, RELAY_ON);
    delay(PUMP_RUN_MS);
    digitalWrite(PIN_RELAY_IRRIGATION, RELAY_OFF);
    irrigationLastRun = now;
  }
}

void applyPhCorrectionLogic(float phValue) {
  unsigned long now = millis();

  if (phValue > PH_HIGH_THRESHOLD &&
      (now - acidPumpLastRun) >= PUMP_COOLDOWN_MS) {
    Serial.println("pH correction: too alkaline, activating acid pump.");
    digitalWrite(PIN_RELAY_ACID, RELAY_ON);
    delay(PUMP_RUN_MS);
    digitalWrite(PIN_RELAY_ACID, RELAY_OFF);
    acidPumpLastRun = now;
  } else if (phValue < PH_LOW_THRESHOLD &&
             (now - alkalinePumpLastRun) >= PUMP_COOLDOWN_MS) {
    Serial.println("pH correction: too acidic, activating alkaline pump.");
    digitalWrite(PIN_RELAY_ALKALINE, RELAY_ON);
    delay(PUMP_RUN_MS);
    digitalWrite(PIN_RELAY_ALKALINE, RELAY_OFF);
    alkalinePumpLastRun = now;
  }
}

void sendReadingsToEsp(int soilRaw, float phValue, int ldrRaw, float tempC) {
  StaticJsonDocument<128> doc;
  doc["soil"] = soilRaw;
  doc["ph"] = phValue;
  doc["ldr"] = ldrRaw;
  doc["temp"] = tempC;
  serializeJson(doc, espSerial);
  espSerial.println();
}

void handleIncomingFromEsp() {
  if (!espSerial.available()) return;

  String line = espSerial.readStringUntil('\n');
  StaticJsonDocument<192> doc;
  DeserializationError err = deserializeJson(doc, line);
  if (err) return;

  // Informational only - see the data contract note at the top of this
  // file for why these aren't wired into the threshold logic above.
  if (doc.containsKey("soil_status")) {
    Serial.print("Admin-set soil target (informational): ");
    Serial.println(doc["soil_status"].as<const char*>());
  }
  if (doc.containsKey("ph_status")) {
    Serial.print("Admin-set pH target (informational): ");
    Serial.println(doc["ph_status"].as<const char*>());
  }
  if (doc.containsKey("temp_target")) {
    Serial.print("Admin-set temperature target (informational): ");
    Serial.println(doc["temp_target"].as<float>());
  }
}
