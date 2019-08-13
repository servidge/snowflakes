// Including the ESP8266 WiFi library
#include <ESP8266WiFi.h>
#define DEBUG_PRINT 0 //0=aus
#define SYSLOG 1

int LEDPIN = 13; //GPIO-D7 NodeMCU
// Replace with your network details
const char* ssid = "SSID-SSID";
const char* password = "PSK-PSK";

//Bonjour
#include <ESP8266mDNS.h>

// Web Server on port 80
WiFiServer server(80);
String header;
int counter = 1000;

#include <OneWire.h>
#include <DallasTemperature.h>
#define ONE_WIRE_BUS D1
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature DS18B20(&oneWire);
char temperatureDS18B20String[6];
float getDS18B20Temperature() {
  float temp;
  do {
    digitalWrite(LEDPIN, HIGH);
    DS18B20.requestTemperatures();
    temp = DS18B20.getTempCByIndex(0);
    delay(100);
  } while (temp == 85.12 || temp == (-127.0));
  digitalWrite(LEDPIN, LOW);
  return temp;
}

#include <WiFiUdp.h>
WiFiUDP udp;
unsigned int localPort = 2390;
IPAddress syslogServer(192, 168, 30, 16);
void sendUdpSyslog(String msgtosend)
{
  unsigned int msg_length = msgtosend.length();
  byte* p = (byte*)malloc(msg_length);
  memcpy(p, (char*) msgtosend.c_str(), msg_length);

  udp.beginPacket(syslogServer, 514);
  //udp.write("esp8266-02-syslog ");
  udp.write(WiFi.localIP());
  udp.write("|");
  udp.write(p, msg_length);
  udp.endPacket();
  free(p);
}
String MELDUNG;

// only runs once on boot
void setup() {
  // Initializing serial port for debugging purposes
  Serial.begin(115200);
  delay(10);

  pinMode(LEDPIN, OUTPUT);
  digitalWrite(LEDPIN, HIGH);

  // Connecting to WiFi network
  if (DEBUG_PRINT) {
    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);
  }


  int Attempt = 0;
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Attempt++;
    //if (DEBUG_PRINT) {
    Serial.print(".");
    //}
    if (Attempt == 200)
    {
      Serial.print("ESP Restart");
      ESP.restart();
    }
  }
  if (DEBUG_PRINT) {
    Serial.println("");
    Serial.println("WiFi connected");
  }
  // Starting the web server
  delay(5000);
  if (DEBUG_PRINT) {
    // Printing the ESP IP address
    Serial.println(WiFi.localIP());
    Serial.println("Connected.");
    Serial.print("MAC Addr: ");
    Serial.println(WiFi.macAddress());
    Serial.print("IP Addr:  ");
    Serial.println(WiFi.localIP());
    Serial.print("Subnet:   ");
    Serial.println(WiFi.subnetMask());
    Serial.print("Gateway:  ");
    Serial.println(WiFi.gatewayIP());
    Serial.print("DNS Addr: ");
    Serial.println(WiFi.dnsIP());
    Serial.print("Channel:  ");
    Serial.println(WiFi.channel());
    Serial.print("Status: ");
    Serial.println(WiFi.status());
  }
  digitalWrite(LEDPIN, LOW);
  server.begin();
  delay(1000);
  digitalWrite(LEDPIN, HIGH);
  delay(1000);
  digitalWrite(LEDPIN, LOW);
  delay(1000);
  digitalWrite(LEDPIN, HIGH);
  delay(1000);
  digitalWrite(LEDPIN, LOW);

  if (DEBUG_PRINT) {
    Serial.println("Web server running. Waiting for Clients");
  }
  if (SYSLOG) {
    sendUdpSyslog("SYSTEMSTART");
  }

  if (!MDNS.begin("esp8266-tempserver")) {
    Serial.println("Error setting up MDNS responder!");
    while (1) {
      delay(1000);
    }
  }
  if (DEBUG_PRINT) {
    Serial.println("mDNS responder started");
  }

  // Add service to MDNS-SD
  MDNS.addService("http", "tcp", 80);

  Serial.print("IP Addr: ");
  Serial.println(WiFi.localIP());
}


unsigned long previousMillis = 0;
int interval = 60000;

// runs over and over again
void loop() {
  unsigned long currentMillis = millis();
  if ((unsigned long)(currentMillis - previousMillis) >= interval) {

    // It's time to do something! do some task here, or trigger some flags, etc
    float DS18B20temperature = getDS18B20Temperature();
    dtostrf(DS18B20temperature, 2, 2, temperatureDS18B20String);
    MELDUNG = "{\"Conuter\":\"";
    MELDUNG += counter;
    MELDUNG += "\",\"Temperatur\":\"";
    MELDUNG += temperatureDS18B20String;
    MELDUNG += "\"\}";
    sendUdpSyslog(MELDUNG);
    counter = counter + 1;
    previousMillis = currentMillis;
  }


  WiFiClient client = server.available();   // Listen for incoming clients
  if (client) {                             // If a new client connects,
    String remote_ip = client.remoteIP().toString(); // IP Adresse des Client
    if (DEBUG_PRINT) {
      Serial.println("Neuer Zugriff von : " + remote_ip);
    }
    String currentLine = "";                
    while (client.connected()) {            
      if (client.available()) {             
        char c = client.read();             
        if (DEBUG_PRINT) {
          Serial.write(c);
        }
        header += c;
        if (c == '\n') {                    
          if (currentLine.length() == 0) {
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println("Connection: close");
            client.println();
          //Temperator holen
          float DS18B20temperature = getDS18B20Temperature();
          dtostrf(DS18B20temperature, 2, 2, temperatureDS18B20String);
            if (header.indexOf("GET /cmVib290/yes") >= 0) {
              if (DEBUG_PRINT) {
                Serial.println("reboot yes");
              }
              client.println("<!DOCTYPE html><html>");
              client.print("<body>");
              client.print("OK - Reboot");
              client.println("</body></html>");
              if (DEBUG_PRINT) {
                Serial.print("ESP Restart");
              }
              ESP.restart();
            }
            else if ( (header.indexOf("GET /reboot") >= 0) || (header.indexOf("GET /reload") >= 0) || (header.indexOf("GET /restart") >= 0) )  {
              if (DEBUG_PRINT) {
                Serial.println("reboot ???");
              }
              client.println("<!DOCTYPE html><html>");
              client.print("<body>");
              client.println("Reboot Device");
              client.println("<p><a href=\"/\"><button class=\"button\">NO</button></a></p>");
              client.println("<p><a href=\"/cmVib290/yes\"><button class=\"button\">YES</button></a></p>");
              client.println("</body></html>");
            }
            else if ( (header.indexOf("GET /kurz") >= 0) || (header.indexOf("GET /short") >= 0) ) {
              if (DEBUG_PRINT) {
                Serial.println("Seite Kurz");
              }
              //client.println("<!DOCTYPE html><html>");
              //client.print("<body>");
              client.print(counter);
              client.print("|");
              client.print(temperatureDS18B20String);
              //client.println("</body></html>");
            }
            else if (header.indexOf("GET /json") >= 0) {
              if (DEBUG_PRINT) {
                Serial.println("Seite json");
              }
              client.print("{\"Conuter\":\"");
              client.print(counter);
              client.print("\",\"Temperatur\":\"");
              client.print(temperatureDS18B20String);
              client.print("\"\}");
            }
            else if (header.indexOf("GET /status") >= 0) {
              if (DEBUG_PRINT) {
                Serial.println("Seite status");
              }
              client.println("<!DOCTYPE html><html>");
              client.print("<body>");
              client.print("SSID: ");
              client.println(WiFi.SSID());
              client.println(" </p>");
              client.print("Signal staerke (RSSI) dbm: ");
              client.println(WiFi.RSSI());       
              client.println(" </p>");     
              client.print("Channel:  ");
              client.println(WiFi.channel());
              client.println(" </p>");
              client.print("Status: ");
              client.println(WiFi.status());
              client.println(" </p>");
              client.print("MAC Addr: ");
              client.println(WiFi.macAddress());
              client.println(" </p>");
              client.print("IP Addr:  ");
              client.println(WiFi.localIP());
              client.println(" </p>");
              client.print("Subnet:   ");
              client.println(WiFi.subnetMask());
              client.println(" </p>");
              client.print("Gateway:  ");
              client.println(WiFi.gatewayIP());
              client.println(" </p>");
              client.print("DNS Addr: ");
              client.println(WiFi.dnsIP());
              client.println(" </p>");
              client.println(" </p>");
              client.print("Conuter: ");
              client.println(counter);
              client.println(" </p>");
              client.print("Temperatur: ");
              client.println(temperatureDS18B20String);
              client.println(" </p>");
              client.println("</body></html>");              
            }
            else {
              if (DEBUG_PRINT) {
                Serial.println("Seite Normal ");
              }
              // Display the HTML web page
              client.println("<!DOCTYPE html><html>");
              client.println("<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
              client.println("<style>html { font-family: Helvetica; display: inline-block; margin: 0px auto; text-align: center;}");
              client.println("text-decoration: none; font-size: 30px; margin: 2px; cursor: pointer;}");
              client.println("</style></head>");
              // Web Page
              client.println("<body><h1>Temp Web Server</h1>");
              client.print("<p>Temperatur in Celsius: ");
              client.print(temperatureDS18B20String);
              client.println(" </p>");
              client.print("<p>Counter: ");
              client.print(counter);
              client.println(" </p>");
              client.println("</body></html>");
            }
            // The HTTP response ends with another blank line
            client.println();
            // Break out of the while loop
            break;
          } else {
            currentLine = "";
          }
        } else if (c != '\r') {  
          currentLine += c;      
        }
      }
    }
        header = "";
    if (DEBUG_PRINT) {
      Serial.println(counter);
    }
    counter = counter + 1;
    client.stop();
    if (DEBUG_PRINT) {
      Serial.println("Client disconnected.");
      Serial.println("");
    }
  }
}

