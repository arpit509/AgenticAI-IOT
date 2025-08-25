const int obstacleSensorPin = 2;

//Main Road
const int mainRoadRedPin = 13;
const int mainRoadGreenPin = 12;

//Side Road
const int sideRoadRedPin = 10;
const int sideRoadGreenPin = 9;

// --- Helper Function to Control Lights ---
/**
 * @brief Sets the color of a traffic light.
 * @param redPin The pin number for the red LED.
 * @param greenPin The pin number for the green LED.
 * @param color The desired color ("red", "green", or "yellow").
 */
void setLightColor(int redPin, int greenPin, String color) {
  digitalWrite(redPin, LOW);
  digitalWrite(greenPin, LOW);
  if (color == "red") {
    digitalWrite(redPin, HIGH);
  } else if (color == "green") {
    digitalWrite(greenPin, HIGH);
  } else if (color == "yellow") {
    digitalWrite(redPin, HIGH);
    digitalWrite(greenPin, HIGH);
  }
}

void setup() {
  pinMode(mainRoadRedPin, OUTPUT);
  pinMode(mainRoadGreenPin, OUTPUT);
  pinMode(sideRoadRedPin, OUTPUT);
  pinMode(sideRoadGreenPin, OUTPUT);
  pinMode(obstacleSensorPin, INPUT);
  
  Serial.begin(9600);
  setLightColor(mainRoadRedPin, mainRoadGreenPin, "green");
  setLightColor(sideRoadRedPin, sideRoadGreenPin, "red");
  
  Serial.println("System Initialized. Main Road: GREEN, Side Road: RED");
}


void loop() {
  int sensorState = digitalRead(obstacleSensorPin);
  if (sensorState == LOW) {
    Serial.println("Vehicle detected on side road! Starting traffic change sequence.");
    setLightColor(mainRoadRedPin, mainRoadGreenPin, "yellow");
    delay(2000);
    setLightColor(mainRoadRedPin, mainRoadGreenPin, "red");
    setLightColor(sideRoadRedPin, sideRoadGreenPin, "green");
    Serial.println("State Change: Main Road: RED, Side Road: GREEN");
    delay(10000);
    setLightColor(sideRoadRedPin, sideRoadGreenPin, "yellow");
    delay(2000);
    setLightColor(sideRoadRedPin, sideRoadGreenPin, "red");
    delay(500);
    setLightColor(mainRoadRedPin, mainRoadGreenPin, "green");
    Serial.println("Sequence complete. Reverting to default state.");
    Serial.println("Main Road: GREEN, Side Road: RED");
  }
  delay(100);
}