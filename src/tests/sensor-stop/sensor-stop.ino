/*
 * Just sets the servo to 90 degress. 
 */
#include <VarSpeedServo.h>
#include <NewPing.h>
 
VarSpeedServo myservo;


void setup() {
  myservo.attach(9);
  myservo.write(90, 250, true);
  myservo.write(160, 250, true);
  myservo.write(20, 250, true);
  myservo.write(90, 250, true);
  myservo.detach();
} 
 
void loop() {
}
