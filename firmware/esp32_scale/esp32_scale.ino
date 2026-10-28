#include "HX711.h"
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

#define DT_PIN  26
#define SCK_PIN 25

#define SDA_PIN 21
#define SCL_PIN 22

#define SERVICE_UUID        "12345678-1234-1234-1234-1234567890ab"
#define CHARACTERISTIC_UUID "abcd1234-5678-90ab-cdef-1234567890ab"

HX711 scale;
LiquidCrystal_I2C lcd(0x27, 16, 2);

float lastReadings[5] = {0, 0, 0, 0, 0};
int readIndex = 0;

BLECharacteristic *weightCharacteristic;
bool deviceConnected = false;

// Set by the BLE task when the phone writes "t"; the tare itself runs in loop()
volatile bool tareRequested = false;


// ================= BLE CALLBACKS =================

class MyServerCallbacks : public BLEServerCallbacks {

  void onConnect(BLEServer* server) {
    deviceConnected = true;
    Serial.println(">>> Phone connected");
  }

  void onDisconnect(BLEServer* server) {
    deviceConnected = false;
    Serial.println(">>> Phone disconnected");

    BLEDevice::startAdvertising();
  }
};


// Called by the BLE library whenever the phone writes to the characteristic
class TareCallbacks : public BLECharacteristicCallbacks {

  void onWrite(BLECharacteristic *c) {
    String v = c->getValue().c_str();

    if (v == "t") {
      tareRequested = true;
    }
  }
};


// ================= STABILITY CHECK =================

bool isStable() {

  float highest = lastReadings[0];
  float lowest = lastReadings[0];

  for (int i = 1; i < 5; i++) {

    if (lastReadings[i] > highest)
      highest = lastReadings[i];

    if (lastReadings[i] < lowest)
      lowest = lastReadings[i];
  }

  return (highest - lowest < 5.0);
}


// ================= I2C SCANNER =================

void scanI2C() {

  Serial.println("Scanning I2C...");

  byte count = 0;

  for (byte addr = 1; addr < 127; addr++) {

    Wire.beginTransmission(addr);

    if (Wire.endTransmission() == 0) {

      Serial.print(">>> Found I2C device at 0x");
      Serial.println(addr, HEX);

      count++;
    }
  }

  if (count == 0) {
    Serial.println(">>> No I2C devices found - check wiring");
  }
}


// ================= SETUP =================

void setup() {

  Serial.begin(115200);

  // =================================================
  // HX711
  // =================================================

  scale.begin(DT_PIN, SCK_PIN);

  Serial.println("Starting HX711...");

  delay(1000);

  // Calibration factor
  scale.set_scale(101.16);

  Serial.println("Taring scale...");
  Serial.println("IMPORTANT: Keep the scale EMPTY");

  delay(1000);

  // Take 20 readings for better zero
  scale.tare(20);

  Serial.println(">>> Scale zeroed");

  // Check zero
  float zeroCheck = scale.get_units(10);

  Serial.print("Zero check: ");
  Serial.print(zeroCheck, 1);
  Serial.println(" grams");


  // =================================================
  // I2C
  // =================================================

  Wire.begin(SDA_PIN, SCL_PIN);

  scanI2C();


  // =================================================
  // LCD
  // =================================================

  lcd.init();

  lcd.backlight();

  lcd.setCursor(0, 0);
  lcd.print("SmartVeg Scale");

  lcd.setCursor(0, 1);
  lcd.print("Starting...");

  delay(1500);

  lcd.clear();


  // =================================================
  // BLE
  // =================================================

  BLEDevice::init("ESP32-Scale");

  BLEServer *server = BLEDevice::createServer();

  server->setCallbacks(new MyServerCallbacks());

  BLEService *service =
    server->createService(SERVICE_UUID);

  // READ + NOTIFY: phone receives the weight
  // WRITE: phone sends "t" to tare
  weightCharacteristic =
    service->createCharacteristic(
      CHARACTERISTIC_UUID,
      BLECharacteristic::PROPERTY_READ |
      BLECharacteristic::PROPERTY_NOTIFY |
      BLECharacteristic::PROPERTY_WRITE
    );

  weightCharacteristic->addDescriptor(
    new BLE2902()
  );

  weightCharacteristic->setCallbacks(new TareCallbacks());

  service->start();

  BLEAdvertising *advertising =
    BLEDevice::getAdvertising();

  advertising->addServiceUUID(SERVICE_UUID);

  advertising->start();


  Serial.println("================================");
  Serial.println("Scale + BLE + LCD ready");
  Serial.println("================================");
}


// ================= LOOP =================

void loop() {

  // =================================================
  // TARE
  // 't' from the Serial Monitor, or 't' written by the phone over BLE
  // =================================================

  bool doTare = tareRequested;

  if (Serial.available() > 0 && Serial.read() == 't') {
    doTare = true;
  }

  if (doTare) {
    tareRequested = false;

    Serial.println(">>> Taring...");

    scale.tare(20);

    Serial.println(">>> TARED");

    // Reset stability readings
    for (int i = 0; i < 5; i++) {
      lastReadings[i] = 0;
    }

    readIndex = 0;
  }


  // =================================================
  // READ WEIGHT
  // =================================================

  if (scale.is_ready()) {

    // Read weight in grams
    float grams = scale.get_units(5);


    // Remove tiny negative values
    if (grams < 0 && grams > -5) {
      grams = 0;
    }


    // If very close to zero, display zero
    if (abs(grams) < 2) {
      grams = 0;
    }


    // Store reading
    lastReadings[readIndex] = grams;

    readIndex++;

    if (readIndex >= 5) {
      readIndex = 0;
    }


    // Stability
    bool stable = isStable();


    // Convert grams to kg
    float kg = grams / 1000.0;


    // =================================================
    // LCD DISPLAY
    // =================================================

    lcd.setCursor(0, 0);
    lcd.print("Weight:         ");

    lcd.setCursor(0, 1);

    lcd.print(kg, 3);
    lcd.print(" kg ");

    if (stable) {
      lcd.print("OK ");
    }
    else {
      lcd.print(".. ");
    }


    // =================================================
    // BLE
    // =================================================

    String payload =
      String(grams, 1) +
      "," +
      (stable ? "1" : "0");

    if (deviceConnected) {

      weightCharacteristic->setValue(
        payload.c_str()
      );

      weightCharacteristic->notify();
    }


    // =================================================
    // SERIAL MONITOR
    // =================================================

    Serial.println(payload);
  }


  delay(200);
}
