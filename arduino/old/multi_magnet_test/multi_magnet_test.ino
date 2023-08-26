
/* Multi trigger code
 *  
 *  This code works to determine the time between multiple discrete
 *  trigger points that occur in a cycle.
 *  
 *  Essentially multiple magnets in a circle
 *  
 *  It works by having an array to store the previous time for each 
 *  individual trigger. This is indexed with each trigger and updated.
 *  By using this system, the system will calculate the time it takes
 *  for each point to pass and not the time between consecutive
 *  triggers.
 * 
 */

const int magnets = 6; //Enter number of magnets in ring (or whatever triggers a reading)
int previous[magnets]; //This array will stor the previous time for each magnet's pass
int current_magnet = 0; //This records the magnet that is expected next trigger

const double drum_circ = 4.7; //Drum circumference
double drum_speed = 0;

int sensor_value = 0;
const int threshold = 10; //Trigger threshold
const int cooldown = 10; 
int current; //Temp int for calculations
/* Time in ms after a trigger before another can be registered, this
 * is to prevent multiple successive readings as a magnet passes
 */
 
void setup() {
  Serial.begin(115200);

  // The while loop gets the initital 5 previous values
  while (current_magnet < magnets){
    sensor_value = analogRead(A0);

    if(sensor_value < threshold) {
      previous[current_magnet] = millis();
      current_magnet++; //Increment to next value
      delay(cooldown);
    }
  }

  current_magnet = 0; // Resets magnet
}

void loop() {
  sensor_value = analogRead(A0);

  if(sensor_value < threshold) {
    current = millis(); //Records current time

    drum_speed = drum_circ / (current - previous[current_magnet]); 
    Serial.println(drum_speed*1000); //Output speed in m/s
    
    previous[current_magnet] = current; //Saves the current to the pervious
    
    current_magnet++; //Increment to next value
    
    delay(cooldown);
  }

  if (current_magnet = magnets) {
    current_magnet = 0; //Resets magnet index once the last one is reached
  }
}
