 /*
  HallEffectCounter
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
 
  /*
  HallEffectCounter
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

boolean shortStart = false; // Set to true for inertia measurements
float tireCirc = 2.053;
int threshold1 = 500;
int threshold2 = 500;
int Nstage1 = 1;
int Nstage2 = 3;
int N1 = 0, N2 = 0;
int stage1 = 1;
int stage2 = 1;
boolean trigger1 = false, trigger2=false;
int sensorValue1;
int sensorValue2;
int sensorMin1 = threshold1, sensorMin2 = threshold2;
int sensorMax1 = threshold1;
int sensorMax2 = threshold2;
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
  while (N1 < Nstage1) {
    sensorValue1 = analogRead(A0);
    
    if ((sensorValue1 < threshold1) && (trigger1 == 0)) {
      trigger1 = 1;
      N1++;
      Serial.print(N1);
      Serial.print('\t');
      Serial.println(1);
    }
    else if ((sensorValue1 > threshold1) && (trigger1 == 1)) {
      trigger1 = 0;
    }
  }
  
  while (N2 < Nstage1) {
    sensorValue2 = analogRead(A5);
    
    if ((sensorValue2 < threshold2) && (trigger2 == 0)) {
      trigger2 = 1;
      N2++;
      Serial.print(N2);
      Serial.print('\t');
      Serial.println(1);
    }
    else if ((sensorValue2 > threshold2) && (trigger2 == 1)) {
      trigger2 = 0;
    }
  }

  // Stage 2
  while (N1 < Nstage1+Nstage2) {
    sensorValue1 = analogRead(A0);
    if ((sensorValue1 < threshold1) && (trigger1 == 0)) {
      trigger1 = 1;
      N1++;
      Serial.print(N1);
      Serial.print('\t');
      Serial.println(2);
    }
    else if ((sensorValue1 > threshold1) && (trigger1 == 1)) {
      trigger1 = 0;
    }
    if (sensorValue1 < sensorMin1)
      sensorMin1 = sensorValue1;
    else if (sensorValue1 > sensorMax1)
      sensorMax1 = sensorValue1;
  }


  while (N2 < Nstage1+Nstage2) {
    sensorValue2 = analogRead(A5);
    if ((sensorValue2 < threshold2) && (trigger2 == 0)) {
      trigger2 = 1;
      N2++;
      Serial.print(N2);
      Serial.print('\t');
      Serial.println(2);
    }
    else if ((sensorValue2 > threshold2) && (trigger2 == 1)) {
      trigger2 = 0;
    }
    if (sensorValue2 < sensorMin2)
      sensorMin2 = sensorValue2;
    else if (sensorValue2 > sensorMax2)
      sensorMax2 = sensorValue2;
  }

  
  threshold1 = (sensorMax1 + sensorMin1)/2;
  Serial.println();
  Serial.print("Min: ");
  Serial.println(sensorMin1);
  Serial.print("Max: ");
  Serial.println(sensorMax1);
  Serial.print("threshold1: ");
  Serial.println(threshold1);
  Serial.println("Ready to start taking data");
  Serial.println();

  threshold2 = (sensorMax2 + sensorMin2)/2;
  Serial.println();
  Serial.print("Min: ");
  Serial.println(sensorMin2);
  Serial.print("Max: ");
  Serial.println(sensorMax2);
  Serial.print("threshold2: ");
  Serial.println(threshold2);
  Serial.println("Ready to start taking data");
  Serial.println();
}

void loop() {
  
  // Stage 3: Data acquisition
  sensorValue1 = analogRead(A0);

    
  // When trigger is switched
  if ((sensorValue1 < threshold1) && (trigger1 == 0)) {
    currentTime = micros();
    if (N1 > Nstage1+Nstage2) {
      vel = tireCirc/(currentTime-previousTime)*3.6*1000000;
      Serial.print(currentTime);
      Serial.print('\t');
      Serial.print(vel);
      Serial.print('\t');
      Serial.print(N1);
      Serial.print('\t');
      Serial.println(3);
    }
    trigger1 = 1;
    N1++;
    previousTime = currentTime;
  }
  
  else if ((sensorValue1 > threshold1) && (trigger1 == 1)) {
    trigger1 = 0;
  }


  sensorValue2 = analogRead(A5);
    
  // When trigger is switched
  if ((sensorValue2 < threshold2) && (trigger2 == 0)) {
    currentTime = micros();
    if (N2 > Nstage1+Nstage2) {
      vel = tireCirc/(currentTime-previousTime)*3.6*1000000;
      Serial.print(currentTime);
      Serial.print('\t');
      Serial.print(vel);
      Serial.print('\t');
      Serial.print(N2);
      Serial.print('\t');
      Serial.println(3);
    }
    trigger2 = 1;
    N2++;
    previousTime = currentTime;
  }
  
  else if ((sensorValue2 > threshold2) && (trigger2 == 1)) {
    trigger2 = 0;
  }

  
}


  
