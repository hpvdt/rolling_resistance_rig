 /*
  HallEffectCounterWheel
  +5V: Purple
  GND: Blue
  A0: Green
  
  Reads fluctuations in the Hall Effect Sensor reading on pin A0 and translates them into discrete trigger points,
  printing the time stamp and velocity associated with each trigger.
  
  The program works in three stages:
  Stage 1: sensor threshold is set to default. Wait for Nstage1 rotations.
  Stage 2: sensor threshold is set to default. Read sensorMin and sensorMax sensor values. Wait for Nstage2 rotations
  Stage 3: set threshold to Avg(sensorMin,sensorMax). Start collecting data.
 
  The default value of the sensor is roughly 512 going up to 1023 and down to 0 when the magnet is near
  (depending on polarity). For typical distances the value might drop to roughly 400-450.
  
  Each cycle takes roughly 0.132 ms on an Arduino Uno (most of that time is from the analogRead function). Giving roughly 10x
  better resolution than printing out to the serial monitor and post-processing the raw data.
  
 */

boolean shortStart = true; // Set to true for inertia measurements
float tireCirc = 2.095; 
// 650C Tires
// Velocity/GP4000 Custom:  1.939 @140psi, 1.938 @120psi, 1.934 @100psi, 
// FMB 20:  1.901 @140psi, 1.8985 @120psi
// FMB 25:  1.937 @160psi 

// 406 Tires
// Ultremo (worn):  1.418 @120psi
// Ultremo (new):  1.419 @120psi
// Schwalbe Stelvio (orange): 1.435 @120psi
// Michelin Blue:  1.527 @80psi
int threshold = 450;// old value was 500
int Nstage1 = 1;
int Nstage2 = 3;
int N = 0;
int stage = 1;
boolean trigger = false;
int sensorValue;
int sensorMin = threshold;
int sensorMax = threshold;
unsigned long currentTime;
unsigned long previousTime;
float vel;

void setup() {
  Serial.begin(115200);
  
  Serial.println();
  Serial.println();
  
  if (shortStart) {
    Nstage1 = 1;
    Nstage2 = 3;  
  }
  else {
    Nstage1 = 5;
    Nstage2 = 20;
  }
  
  // Stage 1
  while (N < Nstage1) {
    sensorValue = analogRead(A0);
    if ((sensorValue < threshold) && (trigger == 0)) {
      trigger = 1;
      N++;
      Serial.print(N);
      Serial.print('\t');
      Serial.println(1);
    }
    else if ((sensorValue > threshold) && (trigger == 1)) {
      trigger = 0;
    }
  }
  
  // Stage 2
  while (N < Nstage1+Nstage2) {
    sensorValue = analogRead(A0);
    if ((sensorValue < threshold) && (trigger == 0)) {
      trigger = 1;
      N++;
      Serial.print(N);
      Serial.print('\t');
      Serial.println(2);
    }
    else if ((sensorValue > threshold) && (trigger == 1)) {
      trigger = 0;
    }
    if (sensorValue < sensorMin)
      sensorMin = sensorValue;
    else if (sensorValue > sensorMax)
      sensorMax = sensorValue;
  }
  
//  threshold = (sensorMax + sensorMin)/2;
  Serial.println();
  Serial.print("Min: ");
  Serial.println(sensorMin);
  Serial.print("Max: ");
  Serial.println(sensorMax);
  Serial.print("threshold: ");
  Serial.println(threshold);
  Serial.println("Ready to start taking data");
  Serial.println();
}

void loop() {
  
  // Stage 3: Data acquisition
  sensorValue = analogRead(A0);
    
  // When trigger is switched
  if ((sensorValue < threshold) && (trigger == 0)) {
    currentTime = micros();
    if (N > Nstage1+Nstage2) {
      vel = tireCirc/(currentTime-previousTime)*3.6*1000000;
      Serial.print(currentTime);
      Serial.print('\t');
      Serial.print(vel);
      Serial.print('\t');
      Serial.print(N);
      Serial.print('\t');
      Serial.println(3);
    }
    trigger = 1;
    N++;
    previousTime = currentTime;
  }
  
  else if ((sensorValue > threshold) && (trigger == 1)) {
    trigger = 0;
  }
  
}


  

