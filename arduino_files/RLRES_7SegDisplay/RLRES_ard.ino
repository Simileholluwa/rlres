
#include <ShiftRegister74HC595.h>
#define SDI 7
#define SCLK 6
#define LOAD 5
#define DIGITS 2
#define RED 8
#define YELLOW 9
#define GREEN 10
#define TRIGGER 11
#define TRIG 2

// create shift register object (number of shift registers, data pin, clock pin, latch pin)
ShiftRegister74HC595 sr (DIGITS, SDI, SCLK, LOAD); 


int value,digit1,digit2,digit3,digit4; 
uint8_t  digits[] = {B11000000, //0
                      B11111001, //1 
                      B10100100, //2
                      B10110000, //3 
                      B10011001, //4
                      B10010010, //5
                      B10000010, //6 
                      B11111000, //7
                      B10000000, //8
                      B10010000 //9
                     };

// Setup function                     
void setup() {
  pinMode(RED, OUTPUT);
  pinMode(YELLOW, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(TRIGGER, OUTPUT);
  pinMode(TRIG, OUTPUT);
}

// Loop function
void loop() {
  /* Turn on ESP32 and allow a delay of 2 seconds.
   * Display `00` on the seven segment.
  */

  digitalWrite(TRIG, HIGH);
  digitalWrite(TRIGGER, LOW);
  showNumber(0);
  delay(2000);

  /* Counts from 0 to 30.
   * Displays the countdown on the seven segment display.
   * Turns on the red Light on the traffic light.
   * Turn on ESP32 cam to start video streaming.
  */ 

  for(int i=0; i<=30; i++)
  {
    digitalWrite(RED, HIGH);
    digitalWrite(YELLOW, LOW);
    digitalWrite(GREEN, LOW);
    showNumber(i);
    delay(1000);
  }

  /* Displays `00` on the display for 5 seconds.
   * Turns on the yellow Light of the traffic light.
   * Turn off ESP32.
  */

  showNumber(0);
  digitalWrite(RED, LOW);
  digitalWrite(YELLOW, HIGH);
  digitalWrite(GREEN, LOW);
  digitalWrite(TRIGGER, HIGH);
  delay(5000);


  /* Counts from 30 to 0.
   * Displays the countdown on the seven segment display.
   * Turns on the green Light on the traffic light.
   * Turn on ESP32 cam to start video streaming when the countdown is 25.
  */ 

  for(int i=30; i >=0; i--)
  {
    digitalWrite(RED, LOW);
    digitalWrite(YELLOW, LOW);
    digitalWrite(GREEN, HIGH);
    showNumber(i);
    delay(1000);
    if(i == 3) {
      digitalWrite(TRIGGER, LOW);
    }
  }
   delay(1000);   
}


/*
 * @brief shows number on the Seven Segment Display
 * @param "num" is integer
 * @return returns none
 * Usage to show 18: showNumber(18);
 */
void showNumber(int num)
{
    digit2=num % 10 ;
    digit1=(num / 10) % 10 ;
    
    //Send them to 7 segment displays
    uint8_t numberToPrint[]= {digits[digit2],digits[digit1]};
    sr.setAll(numberToPrint);  
}