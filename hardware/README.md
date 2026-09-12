# BloomTech Hardware Firmware

**Status: unverified reference code.** No Arduino/ESP32 source existed anywhere in the original project download - only the thesis documentation described this hardware, and the Flutter app only reads/writes the Firebase paths it expects a working system to populate. The sketches in this folder were written to match those exact paths and the thesis's described behavior (chapters 3 and 5), but they have not been compiled, flashed, or tested against real sensors/relays. Treat them as a documented starting point, not a validated deliverable - verify pin assignments, calibration constants, and thresholds against your own build before relying on them.

## Structure

```
hardware/
├── arduino_uno/arduino_uno.ino      # Sensor reading + threshold/actuator logic
└── esp32_gateway/esp32_gateway.ino  # Serial <-> Firebase bridge
```

This split matches the thesis's own division of responsibility (section 5.1): the Arduino Uno owns sensors and relays; the ESP32 only relays data to/from Firebase over Wi-Fi.

## Required libraries (Arduino IDE Library Manager)

- `DHT sensor library` (Adafruit) - for the DHT11
- `ArduinoJson` (v6.x) - used by both sketches for the serial protocol between them
- `Firebase ESP Client` by mobizt - used by the ESP32 sketch only

## Data contract

The two sketches talk to each other over a simple newline-delimited JSON serial protocol, and the ESP32 sketch talks to Firebase using the **exact paths already confirmed in the Flutter app's source**:

| Path | Written by | Read by | Type |
|---|---|---|---|
| `/soil_raw` | ESP32 (from Arduino) | App (`sensor_screen.dart`) | int, raw ADC 0-1023 |
| `/ph_raw` | ESP32 (from Arduino) | App | float, computed pH |
| `/ldr_raw` | ESP32 (from Arduino) | App | int, raw ADC 0-1023 |
| `/temperature_raw` | ESP32 (from Arduino) | App | float, °C |
| `/soil_statues` | App (`add_screen.dart`) | ESP32 -> Arduino | string label |
| `/ph_statues` | App | ESP32 -> Arduino | string label |
| `/temperature` | App | ESP32 -> Arduino | number |

The last three are admin-entered plant target labels from the app's "Add Plant" screen. **They are forwarded to the Arduino as informational log output only** - nothing in the project's documentation or code defines a mapping from a label like `"Very Dry"` to a numeric moisture threshold, so the firmware does not fabricate one. The Arduino's actual automatic irrigation/pH-correction logic uses separate, explicitly tunable constants at the top of `arduino_uno.ino` (`SOIL_DRY_THRESHOLD_RAW`, `PH_LOW_THRESHOLD`, `PH_HIGH_THRESHOLD`) - calibrate these against your real sensors following the thesis's own procedure (section 3.4): buffer solutions at pH 4.0/7.0/10.0 for the pH probe, and dry/moist/saturated soil samples for the moisture sensor.

## Setup

1. Open `esp32_gateway/esp32_gateway.ino` and fill in your Wi-Fi credentials and Firebase project details (API key, database URL, and a device account's email/password - do not reuse your personal Firebase login). Do not commit real values; consider moving them into a gitignored header.
2. Wire the Arduino Uno and ESP32 as described in the comments at the top of each `.ino` file, and adjust the pin `#define`s if your build differs.
3. Flash `arduino_uno.ino` to the Uno and `esp32_gateway.ino` to the ESP32.
4. Open the Arduino Serial Monitor (9600 baud) to confirm sensor readings and relay activity; open the ESP32's monitor (115200 baud) to confirm Wi-Fi/Firebase connectivity and successful publishes.
5. Confirm the app's Sensor Dashboard screen updates with live values.

## Known gaps versus the thesis

- No firmware exists yet for the described safety mechanisms beyond a basic pump cooldown/run-time guard (thesis 3.5 mentions "float switch behavior" for water-level safety and "relay debounce" - a float switch input isn't wired in here since no pin/behavior was specified anywhere in the documentation).
- The three water tanks/pumps are treated as three independent relays with no interlocking beyond the cooldown timer; the thesis's uneven-distribution fix (a shared pipe network, section 4.4) is a plumbing change, not firmware.
