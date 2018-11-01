// Including the ESP8266 WiFi library
#include <ESP8266WiFi.h>

// Replace with your network details
const char* ssid = "SSID-SSID";
const char* password = "PSK-PSK";

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
    DS18B20.requestTemperatures();
    temp = DS18B20.getTempCByIndex(0);
    delay(100);
  } while (temp == 85.0 || temp == (-127.0));
  return temp;
}


// only runs once on boot
void setup() {
  // Initializing serial port for debugging purposes
  Serial.begin(115200);
  delay(10);

  // Connecting to WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);


  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");

  // Starting the web server
  delay(5000);
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

  server.begin();
  Serial.println("Web server running. Waiting for Clients");
}


// runs over and over again

void loop() {
  WiFiClient client = server.available();   // Listen for incoming clients

  if (client) {                             // If a new client connects,
    String remote_ip = client.remoteIP().toString(); // IP Adresse des Client
    Serial.println("Neuer Zugriff von : " + remote_ip);
    String currentLine = "";                
    while (client.connected()) {            
      if (client.available()) {             
        char c = client.read();             
        Serial.write(c);                    
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
            if (header.indexOf("GET /kurz") >= 0) {
              Serial.println("Seite Kurz");
              //client.println("<!DOCTYPE html><html>");
              //client.print("<body>");
              client.print(counter);
              client.print("|");
              client.print(temperatureDS18B20String);
              //client.println("</body></html>");
            }
            else if (header.indexOf("GET /json") >= 0) {
              Serial.println("Seite json");
              client.print("{\"Conuter\":\"");
              client.print(counter);
              client.print("\",\"Temperatur\":\"");
              client.print(temperatureDS18B20String);
              client.print("\"\}");
            }
            else {
              Serial.println("Seite Normal ");
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
    Serial.println(counter);
    counter = counter + 1;
    client.stop();
    Serial.println("Client disconnected.");
    Serial.println("");
  }
}