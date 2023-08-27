/*
Rolling Resistance Rig

Sensor install for monitoring wheel rotational period is US5881 which is an open-drain Hall
sensor (drains when exposed to a magnetic field), so it needs a pull up. Sensor model for
the drum is not known exactly, but it is a latching sensor which outputs binary but needs to
be exposed to an alterating magnetic field.

TODO: change this code to use interrupts are per George's code.
  
 */

const byte wheelPin = 2;
const byte drumPin = 3;



boolean shortStart = false;  // Set to true for inertia measurements
float drumCirc = 4.790;
float tireCirc = 2.08;  //old value 1.9622; //1.994 for grand prix
int threshold1 = 500;   // old value was 500
int threshold2 = 600;   //
int threshold = 600;    // old value was 500
int Nstage1 = 1;
int Nstage2 = 3;
int N = 0;
int N1;
int N2;
int stage = 1;
boolean trigger1 = false;
boolean trigger2 = false;
int sensorValue1;
int sensorValue2;
int sensorMin1 = threshold;
int sensorMax1 = threshold;
int sensorMin2 = threshold;
int sensorMax2 = threshold;
unsigned long currentTime;
unsigned long previousTime1;
unsigned long previousTime2;
float vel1;
float vel2;

void setup() {
  Serial.begin(115200);

  Serial.println();
  Serial.println();

  if (shortStart) {
    Nstage1 = 1;
    Nstage2 = 3;
  } else {
    Nstage1 = 5;
    Nstage2 = 20;
  }

  // Stage 1
  Serial.println("Callibrating drum sensor");
  while (N < Nstage1) {
    sensorValue1 = analogRead(A0);

    if ((sensorValue1 < threshold) && (trigger1 == 0)) {
      trigger1 = 1;
      N++;
      Serial.print(N);
      Serial.print('\t');
      Serial.println(1);

    } else if ((sensorValue1 > threshold) && (trigger1 == 1)) {
      trigger1 = 0;
    }
  }

  N = 0;
  Serial.println("Callibrating wheel sensor");
  while (N < Nstage1) {
    sensorValue2 = analogRead(A5);

    if ((sensorValue2 < threshold2) && (trigger2 == 0)) {
      trigger2 = 1;
      N++;
      Serial.print(N);
      Serial.print('\t');
      Serial.println(1);

    } else if ((sensorValue2 > threshold2) && (trigger2 == 1)) {
      trigger2 = 0;
    }
  }


  // Stage 2
  while (N < Nstage1 + Nstage2) {
    sensorValue1 = analogRead(A0);
    if ((sensorValue1 < threshold) && (trigger1 == 0)) {
      trigger1 = 1;
      N++;
      Serial.print(N);
      Serial.print('\t');
      Serial.println(2);
    } else if ((sensorValue1 > threshold) && (trigger1 == 1)) {
      trigger1 = 0;
    }
    if (sensorValue1 < sensorMin1)
      sensorMin1 = sensorValue1;
    else if (sensorValue1 > sensorMax1)
      sensorMax1 = sensorValue1;
  }

  N = Nstage1;

  while (N < Nstage1 + Nstage2) {
    sensorValue2 = analogRead(A5);
    if ((sensorValue2 < threshold) && (trigger2 == 0)) {
      trigger2 = 1;
      N++;
      Serial.print(N);
      Serial.print('\t');
      Serial.println(2);
    } else if ((sensorValue2 > threshold) && (trigger2 == 1)) {
      trigger2 = 0;
    }
    if (sensorValue2 < sensorMin2)
      sensorMin2 = sensorValue2;
    else if (sensorValue2 > sensorMax2)
      sensorMax2 = sensorValue2;
  }

  threshold1 = (sensorMax1 + sensorMin1) / 2;
  threshold2 = (sensorMax2 + sensorMin2) / 2;

  Serial.println();
  Serial.print("Min1: ");
  Serial.println(sensorMin1);
  Serial.print("Max1: ");
  Serial.println(sensorMax1);
  Serial.print("threshold1: ");
  Serial.println(threshold1);

  Serial.print("Min1: ");
  Serial.println(sensorMin2);
  Serial.print("Max1: ");
  Serial.println(sensorMax2);
  Serial.print("threshold2: ");
  Serial.println(threshold2);
  Serial.println("Ready to start taking data");
  Serial.println();
  N1 = Nstage1 + Nstage2 + 1;
  N2 = Nstage1 + Nstage2 + 1;
}



void loop() {

  // Stage 3: Data acquisition

  sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A5);

  // When trigger is switched
  if ((sensorValue1 < threshold1) && (trigger1 == 0)) {
    currentTime = micros();
    if (N1 > Nstage1 + Nstage2) {
      vel1 = drumCirc / (currentTime - previousTime1) * 3.6 * 1000000;
      Serial.print(currentTime);
      Serial.print('\t');
      Serial.print(vel1);
      Serial.print('\t');
      Serial.print(N1);
      Serial.print('\t');
      Serial.print(vel2);
      Serial.print('\t');
      Serial.println(N2);
    }
    trigger1 = 1;
    N1++;
    previousTime1 = currentTime;
  }

  else if ((sensorValue1 > threshold1) && (trigger1 == 1)) {
    trigger1 = 0;
  }

  if ((sensorValue2 < threshold2) && (trigger2 == 0)) {
    currentTime = micros();
    if (N2 > Nstage1 + Nstage2) {
      vel2 = tireCirc / (currentTime - previousTime2) * 3.6 * 1000000;
      Serial.print(currentTime);
      Serial.print('\t');
      Serial.print(vel1);
      Serial.print('\t');
      Serial.print(N1);
      Serial.print('\t');
      Serial.print(vel2);
      Serial.print('\t');
      Serial.println(N2);
    }
    trigger2 = 1;
    N2++;
    previousTime2 = currentTime;
  }

  else if ((sensorValue2 > threshold2) && (trigger2 == 1)) {
    trigger2 = 0;
  }
}