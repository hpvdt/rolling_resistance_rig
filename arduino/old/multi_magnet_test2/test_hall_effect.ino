int sensorValue = 0;
double drum_circ = 4.790/4;
double drum_speed; 
int previous = millis(); 
int readings = 0; 

void setup() {
  
  Serial.begin(115200);
 

}

void loop() {

  sensorValue = analogRead(A0);
  
  if (sensorValue < 10) {

    int current = millis(); 

    drum_speed = drum_circ / (current - previous); 

    Serial.println(drum_speed*1000); 

    previous = current; 
    
    //Serial.print("  ");
    //Serial.println(sensorValue);
    readings++; 
    
    delay(20);
    
  }
  
  

}
