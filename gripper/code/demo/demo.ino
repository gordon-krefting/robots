#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();

#define SERVO_1_MIN 370
#define SERVO_1_MAX 440
#define SERVO_2_MIN 194
#define SERVO_2_MAX 630

#define POT_1_PIN A0
#define POT_2_PIN A1

void setup() {
  Serial.begin(9600);
  Serial.println("Starting...");
  pwm.begin();
  pwm.setPWMFreq(60);
}

void loop() {
  int v1 = 1023 - analogRead(POT_1_PIN);
  int v2 = 1023 - analogRead(POT_2_PIN);
  int p1 = map(v1, 0, 1023, SERVO_1_MIN, SERVO_1_MAX);
  int p2 = map(v2, 0, 1023, SERVO_2_MIN, SERVO_2_MAX);

  Serial.print("pot 1: ");
  Serial.print(v1);
  Serial.print("  pwm 1:");
  Serial.print(p1);
  Serial.print("    pot 2: ");
  Serial.print(v2);
  Serial.print("  pwm 2:");
  Serial.println(p2);

  pwm.setPWM(0, 0, p1);
  pwm.setPWM(1, 0, p2);
}
