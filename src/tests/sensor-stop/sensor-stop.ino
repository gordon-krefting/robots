/*
 * Just sets the servo to 90 degress. 
 */
#include <VarSpeedServo.h>
#include <NewPing.h>
 
VarSpeedServo myservo;


void setup() {
  myservo.attach(3);
  myservo.write(90, 50, true);
  myservo.write(160, 50, true);
  myservo.write(20, 50, true);
  myservo.write(90, 50, true);
  myservo.detach();
} 
 
void loop() {
}
