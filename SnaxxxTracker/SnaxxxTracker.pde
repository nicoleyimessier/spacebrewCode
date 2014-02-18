/*

 ________  ________   ________     ___    ___ ___    ___ ___    ___         
|\   ____\|\   ___  \|\   __  \   |\  \  /  /|\  \  /  /|\  \  /  /|        
\ \  \___|\ \  \\ \  \ \  \|\  \  \ \  \/  / | \  \/  / | \  \/  / /        
 \ \_____  \ \  \\ \  \ \   __  \  \ \    / / \ \    / / \ \    / /         
  \|____|\  \ \  \\ \  \ \  \ \  \  /     \/   /     \/   /     \/          
    ____\_\  \ \__\\ \__\ \__\ \__\/  /\   \  /  /\   \  /  /\   \          
   |\_________\|__| \|__|\|__|\|__/__/ /\ __\/__/ /\ __\/__/ /\ __\         
   \|_________|                   |__|/ \|__||__|/ \|__||__|/ \|__|         
                                                                            
                                                                            
 _________  ________  ________  ________  ___  __    _______   ________     
|\___   ___\\   __  \|\   __  \|\   ____\|\  \|\  \ |\  ___ \ |\   __  \    
\|___ \  \_\ \  \|\  \ \  \|\  \ \  \___|\ \  \/  /|\ \   __/|\ \  \|\  \   
     \ \  \ \ \   _  _\ \   __  \ \  \    \ \   ___  \ \  \_|/_\ \   _  _\  
      \ \  \ \ \  \\  \\ \  \ \  \ \  \____\ \  \\ \  \ \  \_|\ \ \  \\  \| 
       \ \__\ \ \__\\ _\\ \__\ \__\ \_______\ \__\\ \__\ \_______\ \__\\ _\ 
        \|__|  \|__|\|__|\|__|\|__|\|_______|\|__| \|__|\|_______|\|__|\|__|
                                                                            


Created by Nicole Yi Messier, Joseyln Neon McDonald & LuCy Matchett
Snaxxx Tracker is a spaceBrew application that takes in vending machine data 
logs it and sends it to the Snack NSA website
*/

/******* ARDUINO & FIRMATA STUFF *******/
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

/***SPACE BREW SHIZ********************/
import spacebrew.*;
String server="sandbox.spacebrew.cc";
String name="SnaxxxTracker -> Snack Send";
String description ="An App that takes Arduino input and matches that to information in the snack database, then sending that information to the Snack NSA";
Spacebrew sb;

/*********** ALL STUFF WITH JSON*******/
JSONObject json;                //creating the JSON object
int position_counter = 0;       //position counter to track how many button input there have been to make sure the input doesn't go over three
int[] button = {0,1,2,3,4,5,6,7,8,9,10,11}; //number 0-9 and 10 & 11 = cancel + Done
String code_Input = "";        //varibale to store current input string
String final_code = "";        //variable to store done value string

void setup() {
  
  //load Json file
  json = loadJSONObject("snax.json");
  //instantiate the spacebrewConnection variable
  sb = new Spacebrew(this);
  //declare pblisherz
  sb.addPublish("snack_info", "snack_description", "\"x\":0, \"y\":0");
  //connect!
  sb.connect(server,name,description);
  
  //Print the arduino list so that you know which serial your arduino is connected to
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[9], 57600); //have to change the [] to relate to corresponding arduino serial
  
  for (int i = 0; i <= 11; i++)      {      //set all pins you are using on the arduino to INPUT
    arduino.pinMode(i, Arduino.INPUT);
  }
  
}

void draw() {
  arduinoButtons();
}


//This function takes a variable "buttonP" that is representative of a button pressed
//when a button is pressed it is added to the string "numberInput"
//The max amount of inputs is three
//when the user presses the "done" button the string is saved under the "done" string. 
//by pressing the done button the completed 3 digit code is sent through to the 
//JSONLoop function. 
//When the cancel button is pressed the string is cleared and ready for more input. 

void buttonPressed(int buttonP) {
  
  if (position_counter == 0){      //if we currently have no digits that have been inputted to the code
    for(int i=0; i<=9; i++){  
      if (buttonP == button[i]) {  //if the button pressed is a digit between 0-9
        code_Input = str(i);      // add that digit to the code string i.e. "numberInput"
        position_counter++;        //make position counter higher so we know we have one input
        println(code_Input);
      }
     }
  }
  
  else if (position_counter == 1){
    for(int i=0; i<=9; i++){
      if (buttonP == button[i]) {
        code_Input = code_Input + i;
        position_counter++;
        println(code_Input);
      }
     }
  }
  
  else if (position_counter == 2){
    for(int i=0; i<=9; i++){
      if (buttonP == button[i]) {
        code_Input = code_Input + i;
        position_counter++;
        println(code_Input);
      }
     }
  }
  
  else if (position_counter == 3 && buttonP == 10){
      final_code = code_Input;       //have the temporary string that we have been adding digits to the "done" String
      position_counter = 0;     // reset the position counter to 0 so we are ready to take more inputs
      //println("have done three + done:" + done);
      JSONloop(final_code);           // send completed 3 digit code to the JSONloop function
  }
  
  else if (buttonP == 11) {
      position_counter = 0;     //if hit cancel button return position counter to 0 so can take in more digits
  }
}

//This function is where the arduino input is read
void arduinoButtons() {
   for(int i = 0; i <=11; i++ ) {                 // loop through all possible arduino input pins
     if(arduino.digitalRead(i) == Arduino.HIGH) { // If one of those buttons is being pressed; HIGH
         buttonPressed(i);                        // Run the buttonPressed() function with the corresponding button number
     }
   }
}

///until arduino is plugged in
void keyPressed(){
  if (key == '0') {
     buttonPressed(0);
   }
  if (key == '1') {
     buttonPressed(1);
   }
   if(key == '2'){
     buttonPressed(2);
   }
   if(key == '3'){
     buttonPressed(3);
   }
   if(key == '4'){
     buttonPressed(4);
   }
   if(key == '5'){
     buttonPressed(5);
   }
   if(key == '6'){
     buttonPressed(6);
   }
   if(key == '7'){
     buttonPressed(7);
   }
   if(key == '8'){
     buttonPressed(8);
   }
   if(key == '9'){
     buttonPressed(9);
   }
   if(key == 'd'){
     buttonPressed(10);
     //println("have done three + done:" + done);
     JSONloop(final_code);         // send completed 3 digit code to the JSONloop function
   }
   if(key == 'c'){
     buttonPressed(11);
   }
  }
 
// This function takes a string input
// in this case the three digit code and finds the corresponding JSON database entry
// when it finds the corressponding data it sends to the NSA snaxxx website
void JSONloop(String final_code_input) {
  
  JSONObject snack_send = json.getJSONObject(final_code_input);               //make a JSON object with the information that corresponds to the 3 digit code
  println(snack_send);
  sb.send("snack_info","snack_description", snack_send.toString());           // send the JSON object to the NSA snaxxx website
  
}
    
    

