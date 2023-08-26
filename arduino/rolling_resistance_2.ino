/*
Trying to find number of revolutions of wheel by how many times it passes magnet
  will help figure out how long it takes to slow down and stuff
input: digital read that is 1 when magnet at correct part of the wheel, 0 otherwise
*/

int magnetPin=2; //sets pin for the magnet to be 2

void setup() {// the setup routine runs once when you press reset:
  // put your setup code here, to run once:
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  // make the magnet info stuff pin an input:
  pinMode(magnetPin, INPUT);
  
}

bool on_state = false;// current state of magnet stored here
float count_limit=10.0;//number of revolutions counted

//STATICS DONT RECHANGE VALUE, JUST KEEP THE INITIAL ONE

// the loop routine runs over and over again forever:
void loop() {
  // put your main code here, to run repeatedly:
  
  float cnt =0.0;//number of revolutions
  
  float start = micros();//start time in microseconds

  static float curtime=0;
  static float lasttime=0;
  //Counts how often magnet is 1 without overcounting during same trip/rotation
  while(true){// while loop with break since i dont know how to for loop
    int magnetState= digitalRead(magnetPin); //checks whether magnet is attached at a given time

    if (magnetState==1&&on_state==false){//if tripped
      
      curtime=micros();//sets new curtime
      if(curtime-lasttime>10000){//if more than 1/10 second since last revolution
      on_state = true;
      cnt+=1.0;
      Serial.print(cnt);
      Serial.println("counted!");
      }
      lasttime=curtime;//new last time for revolution
      
    } else{
      on_state = false;
    }
    
    if (cnt>=count_limit){//stops counting over limit
      break;
    }
  }


  //outputs
  float end_time = micros();//finds end time
  float time_passed = ((end_time-start)/1000000.0);
  //Serial.print(cnt+" "+start)
  Serial.print("Time Passed: ");
  Serial.print(time_passed);
  Serial.println("s");
  float rpm_val = (cnt/time_passed)*60.0;
  Serial.print(rpm_val);
  Serial.println(" RPM___________YAY!!!");
  
  delay(1); //delays it by 1 for stability
}
//serial print will show stuff