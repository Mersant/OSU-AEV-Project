void myCode()
{
  //----------------------------------------------------------------------------------------
  // myCode();
  //
  // This is the tab where the programming of your vehicle operation is done.
  // Tab _00_AEV_key_words contains a compiled list of functions/subroutines used for vehicle
  // operation. 
  //
  // Note:
  // (1) After running your AEV do not turn the AEV off, connect the AEV to a computer, or 
  //     push the reset button on the Arduino. There is a 13 second processing period. In 
  //     post processing, data is stored and battery recuperation takes place. 
  // (2) Time, current, voltage, total marks, position traveled are recorded approximately 
  //     every 60 milliseconds. This may vary depending on the vehicles operational tasks. 
  //     It takes approximately 35-40 milliseconds for each recording. Thus when programming,
  //     code complexity may not be beneficial. 
  // (3) Always comment your code. Debugging will be quicker and easier to do and will 
  //     especially aid the instructional team in helping you. 
  //---------------------------------------------------------------------------------------- 

  // Program between here-------------------------------------------------------------------
  
  celerate(2,0,25,2.5);
motorSpeed(2,20);
goFor(1);
brake(1);
/* motor2*/ 
motorSpeed(2,27);
goFor(.7);
brake(2);
reverse(4);
motorSpeed(4,25);
goFor(3);
motorSpeed(1,20);
goFor(3);
brake(2);
brake(4);
goFor(1);
reverse(1);
celerate(4,28,15,2);
motorSpeed(2,25);
goFor(2);
motorSpeed(1,19);
goFor(2);
brake(4);


  // And here--------------------------------------------------------------------------------

} // DO NOT REMOVE. end of void myCode()
