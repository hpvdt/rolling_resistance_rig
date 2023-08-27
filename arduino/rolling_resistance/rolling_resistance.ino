/*
Rolling Resistance Rig

Sensor install for monitoring wheel rotational period is US5881 which is an open-drain Hall
sensor (drains when exposed to a magnetic field), so it needs a pull up. Sensor model for
the drum is not known exactly, but it is a latching sensor which outputs binary but needs to
be exposed to an alterating magnetic field with a pullup enabled (maybe pullup is not needed 
but this is untested).  
 */

// Circumferences for the wheels (in metres)
const float circTire = 2.0800; //old value 1.9622; //1.994 for grand prix
const float circDrum = 4.7900;

const unsigned long debouncingTime = 5000;  // Software debouncing to avoid counting noisy edges repeatedly (us after first edge until next can be counted)
const byte pinTire = 2;
const byte pinDrum = 3;
const char delimiter = '\t';                // Delimited used for data printed. Originally a tab ('\t').
const int decimalDigits = 2;                // Number of decimal points of precision. Default is 2 if unspecified for a `print` function.

volatile unsigned int rotationsDrum = 0;
volatile unsigned int rotationsTire = 0;
volatile unsigned long messageTime = 0;     // Record when most recent event occured
volatile bool triggerMessage = false;       // Has an event occured to be printed
volatile float velDrum = 0.0;
volatile float velTire = 0.0;

void setup() {
  Serial.begin(115200);

  pinMode(pinTire, INPUT_PULLUP);
  pinMode(pinDrum, INPUT_PULLUP);

  attachInterrupt(digitalPinToInterrupt(pinDrum), drumInterrupt, RISING);
  attachInterrupt(digitalPinToInterrupt(pinTire), tireInterrupt, RISING);
}

void loop() {
  if (triggerMessage == true) {

    // Copy in data into temporary variables so interrupts during the printing stages don't change data mid-message
    // This is done in a short burst that cannot be intterupted
    noInterrupts();
    unsigned long tempTime = messageTime;
    float tempVelDrum = velDrum;
    unsigned int tempRotationsDrum = rotationsDrum;
    float tempVelTire = velTire;
    unsigned int tempRotationsTire = rotationsTire;
    triggerMessage = false; // Clear flag once data is copied
    interrupts();

    Serial.print(tempTime);
    Serial.print(delimiter);
    Serial.print(tempVelDrum, decimalDigits);
    Serial.print(delimiter);
    Serial.print(tempRotationsDrum);
    Serial.print(delimiter);
    Serial.print(tempVelTire, decimalDigits);
    Serial.print(delimiter);
    Serial.println(tempRotationsTire);
  }
}


void drumInterrupt() {
  static unsigned long prevTime = 0; // `static` so it carries between function calls without being globally scoped
  unsigned long currentTime = micros(); // Use micros since it is more accurate to real time than millis()
  // https://arduino.stackexchange.com/questions/692/arduino-time-keeping-using-millis-is-not-accurate-or-correct

  if (currentTime < (prevTime + debouncingTime)) return; // Return without recording if too soon after previous edge

  velDrum = circDrum * (3600000.0 / (currentTime - prevTime)); // Grouped calculations to keep operands of similar magnitude for each step
  rotationsDrum++;
  messageTime = currentTime;
  triggerMessage = true;
}

void tireInterrupt() {
  static unsigned long prevTime = 0;
  unsigned long currentTime = micros(); 

  if (currentTime < (prevTime + debouncingTime)) return;

  velTire = circTire * (3600000.0 / (currentTime - prevTime));
  rotationsTire++;
  messageTime = currentTime;
  triggerMessage = true;
}