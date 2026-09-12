/*
  BloomTech - ESP32 Firebase gateway
  ===================================
  STATUS: Best-effort reference implementation written from the project's
  thesis description (chapters 3 and 5) and from the exact Firebase Realtime
  Database paths the Flutter app reads/writes (see
  lib/Pages/sensors_pages/sensor_screen.dart and
  lib/Pages/main_pages/add_screen.dart). It has NOT been tested on real
  hardware - no ESP32 source existed in the repository before this file.

  Role (thesis 5.1): "the ESP32 functions primarily as a Wi-Fi module,
  transferring sensor data from the Arduino Uno to the cloud in real time."
  All sensor reading and actuator/threshold logic lives on the Arduino Uno
  (see arduino_uno.ino in the sibling folder); this sketch only bridges
  serial <-> Firebase.

  Library used: "Firebase ESP Client" by mobizt (install via Library
  Manager - search "Firebase ESP Client"). Tested against its
  email/password-authenticated API; adjust if you use a different Firebase
  ESP32 library or auth method.

  Wiring assumed:
    GPIO16 (RX2) - Arduino TX (pin D9 on the Uno sketch)
    GPIO17 (TX2) - Arduino RX (pin D8 on the Uno sketch)
  The ESP32 operates at 3.3V logic; the thesis (section 4.4) notes this
  caused signal-compatibility issues when driving 5V actuators directly,
  which is why actuator control is kept on the Arduino Uno rather than
  moved here.

  Firebase Realtime Database paths (must match the Flutter app exactly):
    Written by this sketch (sensor telemetry from the Arduino):
      /soil_raw          - int, raw ADC 0-1023
      /ph_raw            - float, computed pH value
      /ldr_raw           - int, raw ADC 0-1023
      /temperature_raw   - float, degrees Celsius
    Read by this sketch and forwarded to the Arduino as informational
    context (see the data-contract note in arduino_uno.ino for why these
    aren't auto-applied as thresholds):
      /soil_statues       - string ("Dry" | "Very Dry" | "Moderate Dry")
      /ph_statues         - string ("Acidic" | "Alkaline" | "Neutral")
      /temperature        - number (admin's target temperature)

  Fill in your own project's credentials below - do not commit real values
  to a public repository. Consider loading these from a separate untracked
  header (e.g. secrets.h, already covered by this repo's .gitignore pattern
  for *.h if you add one) rather than hardcoding them here.
*/

#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <ArduinoJson.h>

// ---------- Fill in your own values ----------
#define WIFI_SSID "YOUR_WIFI_SSID"
#define WIFI_PASSWORD "YOUR_WIFI_PASSWORD"
#define FIREBASE_API_KEY "YOUR_FIREBASE_WEB_API_KEY"
#define FIREBASE_DATABASE_URL "https://YOUR_PROJECT_ID-default-rtdb.firebaseio.com/"
#define FIREBASE_USER_EMAIL "YOUR_DEVICE_ACCOUNT_EMAIL"
#define FIREBASE_USER_PASSWORD "YOUR_DEVICE_ACCOUNT_PASSWORD"

// ---------- Serial link to the Arduino Uno ----------
// Uses ESP32 hardware UART2 so the USB serial stays free for debug logs.
HardwareSerial unoSerial(2); // RX2=16, TX2=17

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long lastStatusPollAt = 0;
const unsigned long STATUS_POLL_INTERVAL_MS = 10000;

void setup() {
  Serial.begin(115200);
  unoSerial.begin(9600, SERIAL_8N1, 16, 17);

  connectWiFi();
  connectFirebase();
}

void loop() {
  readFromArduinoAndPublish();

  unsigned long now = millis();
  if (now - lastStatusPollAt >= STATUS_POLL_INTERVAL_MS) {
    lastStatusPollAt = now;
    forwardPlantTargetsToArduino();
  }
}

void connectWiFi() {
  Serial.printf("Connecting to WiFi '%s'...\n", WIFI_SSID);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(300);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("WiFi connected, IP: ");
  Serial.println(WiFi.localIP());
}

void connectFirebase() {
  config.api_key = FIREBASE_API_KEY;
  config.database_url = FIREBASE_DATABASE_URL;
  auth.user.email = FIREBASE_USER_EMAIL;
  auth.user.password = FIREBASE_USER_PASSWORD;
  config.token_status_callback = tokenStatusCallback;

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void readFromArduinoAndPublish() {
  if (!unoSerial.available()) return;

  String line = unoSerial.readStringUntil('\n');
  StaticJsonDocument<128> doc;
  DeserializationError err = deserializeJson(doc, line);
  if (err) {
    Serial.print("Bad JSON from Uno: ");
    Serial.println(line);
    return;
  }

  if (!Firebase.ready()) return;

  if (doc.containsKey("soil")) {
    Firebase.RTDB.setInt(&fbdo, "/soil_raw", doc["soil"].as<int>());
  }
  if (doc.containsKey("ph")) {
    Firebase.RTDB.setFloat(&fbdo, "/ph_raw", doc["ph"].as<float>());
  }
  if (doc.containsKey("ldr")) {
    Firebase.RTDB.setInt(&fbdo, "/ldr_raw", doc["ldr"].as<int>());
  }
  if (doc.containsKey("temp")) {
    Firebase.RTDB.setFloat(&fbdo, "/temperature_raw", doc["temp"].as<float>());
  }

  Serial.print("Published to Firebase: ");
  Serial.println(line);
}

void forwardPlantTargetsToArduino() {
  if (!Firebase.ready()) return;

  StaticJsonDocument<192> outDoc;

  if (Firebase.RTDB.getString(&fbdo, "/soil_statues")) {
    outDoc["soil_status"] = fbdo.stringData();
  }
  if (Firebase.RTDB.getString(&fbdo, "/ph_statues")) {
    outDoc["ph_status"] = fbdo.stringData();
  }
  if (Firebase.RTDB.getFloat(&fbdo, "/temperature")) {
    outDoc["temp_target"] = fbdo.floatData();
  }

  if (outDoc.size() > 0) {
    serializeJson(outDoc, unoSerial);
    unoSerial.println();
  }
}
