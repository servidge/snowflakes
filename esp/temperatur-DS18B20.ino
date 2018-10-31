// Including the ESP8266 WiFi library
#include <ESP8266WiFi.h>

#include <OneWire.h>
#include <DallasTemperature.h>
#define ONE_WIRE_BUS D1
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature DS18B20(&oneWire);
char temperatureString[6];
float getDS18B20Temperature() {
  float temp;
  do {
    DS18B20.requestTemperatures();
    temp = DS18B20.getTempCByIndex(0);
    delay(100);
  } while (temp == 85.0 || temp == (-127.0));
  Serial.print("temp " + temp);
  return temp;
}

// Replace with your network details
const char* ssid = "SSID-SSID";
const char* password = "PSK-PSK";


// Web Server on port 80
WiFiServer server(80);


// only runs once on boot
void setup() {
  // Initializing serial port for debugging purposes
  Serial.begin(115200);
  delay(10);
  // Connecting to WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  //WiFi.mode(WIFI_STA);
  WiFi.begin (ssid,password);
  while ( WiFi.status() != WL_CONNECTED ) {
    delay ( 500 );
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  //WiFi.mode(WIFI_STA);

  // Starting the web server
  server.begin();
  Serial.println("Web server running. Waiting for the ESP IP...");
  delay(10000);

  // Printing the ESP IP address
  Serial.println(WiFi.localIP());
}

// runs over and over again
void loop()
{
  // Listenning for new clients
  WiFiClient client = server.available();

  if (client)
  {
    // IP Adresse des Client
    String remote_ip = client.remoteIP().toString(); 
    Serial.println("Neuer Zugriff von : " + remote_ip);

    float DS18B20temperature = getDS18B20Temperature();
    dtostrf(DS18B20temperature, 2, 2, temperatureString);

    // bolean to locate when the http request ends
    boolean blank_line = true;
    while (client.connected())
    {
      if (client.available())
      {
        char c = client.read();
        if (c == '\n' && blank_line)
        {

        }

        client.println("HTTP/1.1 200 OK");
        client.println("Content-Type: text/html");
        client.println("Connection: close");
        client.println();
        client.println("<!DOCTYPE HTML>");
        client.println("<html>");
        client.println("<head></head><body><h1>DS18B20 - Temperatur</h1>");
        client.println("<h3>DS18B20 Temperatur in Celsius: ");
        client.println(temperatureString);
        client.println("</h3>");
        client.println("<hr>Remote IP: " + remote_ip + "<br>");
        client.println("</body></html>");
        break;

        if (c == '\n')
        {
          // when starts reading a new line
          blank_line = true;
        }
        else if (c != '\r')
        {
          // when finds a character on the current line
          blank_line = false;
        }
      }
    }
    // closing the client connection
    delay(1);
    client.stop();
    Serial.println("Client disconnected.");

  }
}
