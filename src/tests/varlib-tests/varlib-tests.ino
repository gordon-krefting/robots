#include <NewPing.h>
#include <VarSpeedServo.h> 


#define PING_PIN  2
#define MAX_DISTANCE 1000

NewPing sonar(PING_PIN, PING_PIN, MAX_DISTANCE);

VarSpeedServo myServo;
 
void setup() {
  myServo.attach(9);
  Serial.begin(9600);
} 
 
void loop() {

  for (int pos = 30; pos <= 160; pos += 10) {
    //myservo.write(pos);
    printDistance(myServo.read());
    myServo.write(pos, 50, false);
    delay(200);
  }
  for (int pos = 150; pos >= 20; pos -= 10) {
    //myservo.write(pos);
    printDistance(myServo.read());
    myServo.write(pos, 50, false);
    delay(200);
  }

}

void printDistance(int pos) {
  Serial.print("Angle: ");
  Serial.print(pos);
  Serial.print("\tPing: ");
  Serial.print(sonar.ping_cm());
  Serial.println("cm");
}



