 /*
  HallEffectReader
  +5V: Purple
  GND: Blue
  A0: Green
  
  Reads an analog input on pin 0, prints the result to the serial monitor as fast as allowable by baud 115200.
  
 */
 
 
 

 int sensorValue1 = 0;
 int sensorValue2 = 0;

void setup() {
  Serial.begin(115200);
}

void loop() {
  sensorValue1 = analogRead(A0);
  sensorValue2 = analogRead(A5);
  Serial.print(sensorValue1);
  Serial.print("\t");
  Serial.print(sensorValue2);
  Serial.print("\t");
  Serial.println(micros());
}


  

