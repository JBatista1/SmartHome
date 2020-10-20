#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>

#define SERVICE_UUID "ab0828b1-198e-4351-b779-901fa0e0371e"
#define MESSAGE_UUID "4ac8a682-9736-4e5d-932b-e9b31405049c"

#define DEVINFO_UUID (uint16_t)0x180a
#define DEVINFO_MANUFACTURER_UUID (uint16_t)0x2a29
#define DEVINFO_NAME_UUID (uint16_t)0x2a24
#define DEVINFO_SERIAL_UUID (uint16_t)0x2a25

#define DEVICE_MANUFACTURER "Foobar"
#define DEVICE_NAME "SmartHome"

BLECharacteristic *characteristicMessage;
// Pin in ESP
#define pinBlue 2
#define pinGreen 14
#define pinYellow 27
#define pinRed 26

// Value define is on or off led
int valuePinBlue = 0;
int valuePinGreen = 0;
int valuePinYellow = 0;
int valuePinRed = 0;

int LED_BUILTIN = 2;
int port = 0;

class MyServerCallbacks : public BLEServerCallbacks
{
    void onConnect(BLEServer *server)
    {
      Serial.println("Connected");
    };

    void onDisconnect(BLEServer *server)
    {
      Serial.println("Disconnected");
    }
};

class MessageCallbacks : public BLECharacteristicCallbacks
{
    void onWrite(BLECharacteristic *characteristic)
    {
      std::string data = characteristic->getValue();
      port = atoi( data.c_str());
      Serial.println(data.c_str());
    }

    void onRead(BLECharacteristic *characteristic)
    {
      characteristic->setValue("Foobar");
    }
};

int updateValue(int valuePin) {
  int value = 0;
  if (valuePin == 0) {
    value = 1;
  }else {
    value = 0;
  }
  return value;
}
void setNumber(int value) {
  //numeros utilizando os pinos
   
  switch (value) {
    case 2:
      valuePinBlue = updateValue(valuePinBlue);
      digitalWrite(pinBlue, valuePinBlue);
      Serial.println("case 2");
      break;
    case 14:
      valuePinGreen = updateValue(valuePinGreen);
      digitalWrite(pinGreen, valuePinGreen);
      Serial.println("case 14");
      break;
    case 27:
      valuePinYellow = updateValue(valuePinYellow);
      digitalWrite(pinYellow, valuePinYellow);
      Serial.println("case 27");
      break;
    case 26:
      valuePinRed = updateValue(valuePinRed);
      digitalWrite(pinRed, valuePinRed);
      Serial.println("case 26");
      break;
    default:
      break;
  }
  port = 0;
}
void setup()
{
  Serial.begin(9600);
  pinMode(pinBlue, OUTPUT);
  pinMode(pinGreen, OUTPUT);
  pinMode(pinYellow, OUTPUT);
  pinMode(pinRed, OUTPUT);
  
  // Setup BLE Server
  BLEDevice::init(DEVICE_NAME);
  BLEServer *server = BLEDevice::createServer();
  server->setCallbacks(new MyServerCallbacks());

  // Register message service that can receive messages and reply with a static message.
  BLEService *service = server->createService(SERVICE_UUID);
  characteristicMessage = service->createCharacteristic(MESSAGE_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_WRITE);
  characteristicMessage->setCallbacks(new MessageCallbacks());
  characteristicMessage->addDescriptor(new BLE2902());
  service->start();

  // Register device info service, that contains the device's UUID, manufacturer and name.
  service = server->createService(DEVINFO_UUID);
  BLECharacteristic *characteristic = service->createCharacteristic(DEVINFO_MANUFACTURER_UUID, BLECharacteristic::PROPERTY_READ);
  characteristic->setValue(DEVICE_MANUFACTURER);
  characteristic = service->createCharacteristic(DEVINFO_NAME_UUID, BLECharacteristic::PROPERTY_READ);
  characteristic->setValue(DEVICE_NAME);
  characteristic = service->createCharacteristic(DEVINFO_SERIAL_UUID, BLECharacteristic::PROPERTY_READ);
  String chipId = String((uint32_t)(ESP.getEfuseMac() >> 24), HEX);
  characteristic->setValue(chipId.c_str());
  service->start();

  // Advertise services
  BLEAdvertising *advertisement = server->getAdvertising();
  BLEAdvertisementData adv;
  adv.setName(DEVICE_NAME);
  adv.setCompleteServices(BLEUUID(SERVICE_UUID));
  advertisement->setAdvertisementData(adv);
  advertisement->start();

  Serial.println("Ready");
}

void loop()
{
  if (port != 0){
    setNumber(port);
  }
  
  delay(500);
}
