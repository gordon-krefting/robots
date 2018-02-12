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

const int leftWheelForwardPin  = 5;
const int leftWheelReversePin  = 6;
const int rightWheelForwardPin = 9;
const int rightWheelReversePin = 10;

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
  if (distance < 100.0) {
    Serial.print("Distance: ");
    Serial.println(distance);
  }

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

state handleTimeout() {
  Serial.println("State timeout");
  switch(currentState) {
    case RUNNING:
      return REVERSING;
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
    default: return "Unknown";
  }
}

void leftWheelForward() {
  digitalWrite(leftWheelForwardPin, HIGH);
  digitalWrite(leftWheelReversePin, LOW);
}

void leftWheelReverse() {
  digitalWrite(leftWheelForwardPin, LOW);
  digitalWrite(leftWheelReversePin, HIGH);
}

void leftWheelStop() {
  digitalWrite(leftWheelForwardPin, LOW);
  digitalWrite(leftWheelReversePin, LOW);
}

void rightWheelForward() {
  digitalWrite(rightWheelForwardPin, HIGH);
  digitalWrite(rightWheelReversePin, LOW);
}

void rightWheelReverse() {
  digitalWrite(rightWheelForwardPin, LOW);
  digitalWrite(rightWheelReversePin, HIGH);
}

void rightWheelStop() {
  digitalWrite(rightWheelForwardPin, LOW);
  digitalWrite(rightWheelReversePin, LOW);
}



