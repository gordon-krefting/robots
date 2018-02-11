/*
 * main robot script
 * 
 * TODO everything!
 * 
 * Some of this is from:
 *    http://www.arduino.cc/en/Tutorial/ButtonStateChange
 */

const int buttonPin   = 4;
const int onLedPin    = 12;
const int offLedPin   = 13;




void setup() {
  pinMode(buttonPin, INPUT);
  pinMode(onLedPin, OUTPUT);
  pinMode(offLedPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

}
