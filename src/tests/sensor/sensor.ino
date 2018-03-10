#include <NewPing.h>
#include <VarSpeedServo.h> 

#define PING_PIN 2
#define SERVO_PIN 9

#define SWEEPER_RANGE     1000
#define SWEEPER_MIN       20
#define SWEEPER_MAX       160
#define SWEEPER_INC       10
#define SWEEPER_SPEED     50
#define SWEEPER_INTERVAL  200

class Sweeper {
  VarSpeedServo servo;
  NewPing sonar;

  int position;
  int increment;
  unsigned long lastUpdateTime;
  
public:

  Sweeper() : sonar(PING_PIN, PING_PIN, SWEEPER_RANGE) {
  }

  void Attach() {
    position = SWEEPER_MIN;
    increment = SWEEPER_INC;
    lastUpdateTime = millis();
    servo.attach(SERVO_PIN);
    servo.write(position, 50, true);
  }

  void Update() {
    if((millis() - lastUpdateTime) > SWEEPER_INTERVAL) {
      lastUpdateTime = millis();
      position += increment;
      printDistance();
      servo.write(position, 50, false);
      if ((position >= SWEEPER_MAX) || (position <= SWEEPER_MIN)) {
        increment = -increment;
      }
    }
  }

  void Detach() {
    servo.detach();  
  }
  
private:

  void printDistance() {
    Serial.print("Angle: ");
    Serial.print(position);
    Serial.print("\tPing: ");
    Serial.print(sonar.ping_cm());
    Serial.println("cm");
  }
  
};

Sweeper sweeper;

void setup() {
  Serial.begin(9600);
  sweeper.Attach();
}

void loop() {
  sweeper.Update();
}

