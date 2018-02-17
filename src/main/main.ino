/*
 * main robot script
 * 
 * TODO everything!
 * 
 * Some of this is from:
 *    http://www.arduino.cc/en/Tutorial/ButtonStateChange
 */

const int buttonPin = 4;
const int onLedPin  = 12;
const int offLedPin = 13;

const int leftWheelReversePin  = 5;
const int leftWheelForwardPin  = 6;
const int rightWheelReversePin = 9;
const int rightWheelForwardPin = 10;

const int rangingTriggerPin = 7;
const int rangingEchoPin    = 8;

int lastButtonState = 0;
int lastStateInitTime = 0;

int stateTimeout = 0;

enum state
{
  STOPPED,
  RUNNING,
  SLOWING,
  TURNING_LEFT,
  TURNING_RIGHT,
  REVERSING,
  SWIVEL_LEFT,
  SWIVEL_RIGHT
};

enum state currentState;

void setup() {
  pinMode(buttonPin, INPUT);
  pinMode(onLedPin,  OUTPUT);
  pinMode(offLedPin, OUTPUT);

  pinMode(leftWheelForwardPin,  OUTPUT);
  pinMode(leftWheelReversePin,  OUTPUT);
  pinMode(rightWheelForwardPin, OUTPUT);
  pinMode(rightWheelReversePin, OUTPUT);

  pinMode(rangingTriggerPin, OUTPUT); 
  pinMode(rangingEchoPin,    INPUT); 

  Serial.begin(9600);

  currentState = STOPPED;
  initState();
}

void loop() {
  // check for the button press
  int buttonState = digitalRead(buttonPin);
  if (buttonState != lastButtonState && buttonState == LOW) {
    changeState(handleButtonPress());
    delay(20);
  }
  lastButtonState = buttonState;

  // get the distance
  digitalWrite(rangingTriggerPin, LOW); 
  delayMicroseconds(2); 
  digitalWrite(rangingTriggerPin, HIGH); 
  delayMicroseconds(10); 
  digitalWrite(rangingTriggerPin, LOW);

  float duration = pulseIn(rangingEchoPin, HIGH);
  float distance = (duration*.0343)/2;
  changeState(handleDetectObject(distance));

  // time in state?
  int timeInState = millis() - lastStateInitTime;
  if (stateTimeout > 0 && timeInState > stateTimeout) {
    changeState(handleTimeout());
  }
}

void changeState(enum state newState) {
  if (newState != currentState) {
    leaveState();
    currentState = newState;
    initState();
  }  
}

state handleButtonPress() {
  Serial.println("Button press");
  switch(currentState) {
    case STOPPED:
      return RUNNING;
    default:
      return STOPPED;
  }
}

state handleDetectObject(float distance) {
  if (distance < 100) {
    Serial.print("Object at: ");
    Serial.print(distance);
    Serial.println("cm");
  }
  switch(currentState) {
    case RUNNING:
      if (distance < 20) {
        return SWIVEL_LEFT;
      }
      break;
    case SWIVEL_LEFT:
      if (distance > 40) {
        return RUNNING;
      }
      break;
  }
  return currentState;  

}

state handleTimeout() {
  Serial.println("State timeout");
  switch(currentState) {
    case RUNNING:
      return REVERSING;
    case SWIVEL_LEFT:
    case REVERSING:
      return RUNNING;
    default:
      return STOPPED;
  }
}

void initState() {
  Serial.print("Entering state: ");
  Serial.println(stateName());
  lastStateInitTime = millis();
  switch(currentState) {
    case STOPPED:
      digitalWrite(offLedPin, HIGH);
      digitalWrite(onLedPin, LOW);
      stateTimeout = 0;
      break;
    case RUNNING:
      leftWheelForward();
      rightWheelForward();
      stateTimeout = 5000;
      break;
    case SWIVEL_LEFT:
      leftWheelReverse();
      rightWheelReverse();
      delay(2000);
      leftWheelReverse();
      rightWheelForward();
      delay(500);
      stateTimeout = 3000;
      break;
    case REVERSING:
      leftWheelReverse();
      rightWheelReverse();
      stateTimeout = 1000;
      break;
  }
}

void leaveState() {
  Serial.print("Leaving state: ");
  Serial.println(stateName());
  switch(currentState) {
    case STOPPED:
      digitalWrite(offLedPin, LOW);
      digitalWrite(onLedPin, HIGH);
      break;
    case REVERSING:
    case SWIVEL_LEFT:
    case RUNNING:
      leftWheelStop();
      rightWheelStop();
      break;
  }
}

char * stateName() {
  switch(currentState) {
    case STOPPED: return "STOPPED";
    case RUNNING: return "RUNNING";
    case REVERSING: return "REVERSING";
    case SWIVEL_LEFT: return "SWIVEL_LEFT";
    default: return "Unknown";
  }
}

void leftWheelForward() {
  analogWrite(leftWheelForwardPin, 255);
  analogWrite(leftWheelReversePin, 0);
}

void leftWheelReverse() {
  analogWrite(leftWheelForwardPin, 0);
  analogWrite(leftWheelReversePin, 255);
}

void leftWheelStop() {
  analogWrite(leftWheelForwardPin, 0);
  analogWrite(leftWheelReversePin, 0);
}

void rightWheelForward() {
  analogWrite(rightWheelForwardPin, 255);
  analogWrite(rightWheelReversePin, 0);
}

void rightWheelReverse() {
  analogWrite(rightWheelForwardPin, 0);
  analogWrite(rightWheelReversePin, 255);
}

void rightWheelStop() {
  analogWrite(rightWheelForwardPin, 0);
  analogWrite(rightWheelReversePin, 0);
}



