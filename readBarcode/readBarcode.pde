#include "TimerOne.h"

#define ledpin 13

#define analogThreshold 150

#define l5 analogRead(5) - 620
#define l4 analogRead(6) - 0  // not working
#define l3 analogRead(7) - 300
#define l2 analogRead(8) - 650
#define l1 analogRead(9) - 500

#define m analogRead(10) - 0
#define r1 analogRead(11) - 200
#define r2 analogRead(12) - 0 
#define r3 analogRead(13) - 400
#define r4 analogRead(14) - 600
#define r5 analogRead(15) - 680

#define d_l5 analogRead(5) - 620 - analogThreshold > 0?1:0
#define d_l4 analogRead(6) - 0 - analogThreshold > 0?1:0// not working
#define d_l3 analogRead(7) - 300 -analogThreshold > 0?1:0
#define d_l2 analogRead(8) - 650 -analogThreshold > 0?1:0
#define d_l1 analogRead(9) - 500 -analogThreshold > 0?1:0

#define d_m analogRead(10) - 0 -analogThreshold > 0?1:0
#define d_r1 analogRead(11) - 200 -analogThreshold > 0?1:0
#define d_r2 analogRead(12) - 0 -analogThreshold > 0?1:0
#define d_r3 analogRead(13) - 400-analogThreshold > 0?1:0
#define d_r4 analogRead(14) - 600-analogThreshold > 0?1:0
#define d_r5 analogRead(15) - 680-analogThreshold > 0?1:0

#define leftMotorForwardPin 22
#define leftMotorBackwardPin 24
#define leftMotorPWMPin 6

#define rightMotorForwardPin 28
#define rightMotorBackwardPin 26
#define rightMotorPWMPin 7

#define leftEncoder 2 // interrupt number=0
#define rightEncoder 3 // interrupt number=1

int leftEnc_count=0;
int rightEnc_count=0;
int left_enc_mini=0;
int right_enc_mini=0;
#define ENCODER_MINI_COUNT 5

int leftEncoderSpeedCount_1=0;
int rightEncoderSpeedCount_1=0;
int leftEncoderSpeedCount_2=0;
int rightEncoderSpeedCount_2=0;

int leftEncoderSpeed=0;
int rightEncoderSpeed=0;

int time=0;

int forwardleftPWM;

bool READ_BARCODE=false;
Barcode cur_reading_barcode;

String barcode="";

void leftMotorForward(int pwm) {
  analogWrite(leftMotorPWMPin,pwm);
  digitalWrite(leftMotorForwardPin,HIGH);
  digitalWrite(leftMotorBackwardPin,LOW);
}

void rightMotorForward(int pwm){
  analogWrite(rightMotorPWMPin,pwm);
  digitalWrite(rightMotorForwardPin,HIGH);
  digitalWrite(rightMotorBackwardPin,LOW);
}

void  leftMotorBackward(int pwm) {
  analogWrite(leftMotorPWMPin,pwm);
  digitalWrite(leftMotorForwardPin,LOW);
  digitalWrite(leftMotorBackwardPin,HIGH);
}

void rightMotorBackward(int pwm){
  analogWrite(rightMotorPWMPin,pwm);
  digitalWrite(rightMotorForwardPin,LOW);
  digitalWrite(rightMotorBackwardPin,HIGH);
}

void breakMotors(int time){
  digitalWrite(leftMotorForwardPin,HIGH);
  digitalWrite(leftMotorBackwardPin,HIGH);
  digitalWrite(rightMotorForwardPin,HIGH);
  digitalWrite(rightMotorBackwardPin,HIGH);
  delay(time);
}

void forward(int pwm){	

	if(leftEncoderSpeed > rightEncoderSpeed ){
		leftMotorForward((pwm/9)*11);
		rightMotorForward(pwm + leftEncoderSpeed - rightEncoderSpeed );
	}else
	{
		leftMotorForward((pwm/9)*11 +  rightEncoderSpeed - leftEncoderSpeed );
		rightMotorForward(pwm);
	}

}

void backward(int pwm){
  leftMotorBackward(pwm);
  rightMotorBackward(pwm);
}

void turnLeft(int lpwm,int rpwm){
   if(lpwm>rpwm){
      int c=lpwm;
      lpwm=rpwm;
      rpwm=c;
   }
   leftMotorForward(lpwm);
   rightMotorForward(rpwm);
}

void turnRight(int lpwm,int rpwm){
   if(rpwm>lpwm){
      int c=lpwm;
      lpwm=rpwm;
      rpwm=c;
   }
   leftMotorForward(lpwm);
   rightMotorForward(rpwm);
}

void rotateLeft(int pwm){
   rightMotorForward(pwm);
   leftMotorBackward(pwm);
}

void rotateRight(int pwm){
   leftMotorForward(pwm);
   rightMotorBackward(pwm);
}

void rotateLeftOneMotor(int pwm){
   digitalWrite(leftMotorForwardPin,HIGH);
   digitalWrite(leftMotorBackwardPin,HIGH);
   rightMotorForward(pwm);
}

void rotateRightOneMotor(int pwm){
   digitalWrite(rightMotorForwardPin,HIGH);
   digitalWrite(rightMotorBackwardPin,HIGH);
   leftMotorForward(pwm);
}

void setup(){
  
  Serial.begin(9600);
  
  pinMode(leftMotorPWMPin,OUTPUT);
  pinMode(rightMotorPWMPin,OUTPUT);
  
  pinMode(leftMotorForwardPin,OUTPUT);
  pinMode(leftMotorBackwardPin,OUTPUT);
  pinMode(rightMotorForwardPin,OUTPUT);
  pinMode(rightMotorBackwardPin,OUTPUT);
  
  pinMode(m,INPUT);
  pinMode(l1,INPUT);
  pinMode(l2,INPUT);
  pinMode(l3,INPUT);
  pinMode(l4,INPUT);
  pinMode(l5,INPUT);
  pinMode(r1,INPUT);
  pinMode(r2,INPUT);
  pinMode(r3,INPUT);
  pinMode(r4,INPUT);
  pinMode(r5,INPUT);

  
  pinMode(2,INPUT);
  pinMode(1,INPUT);

  attachInterrupt(0,left_Enc_INT,CHANGE); // to leftEncoder (pin number=2)
  attachInterrupt(1,right_Enc_INT,CHANGE); // to rightEncoder (pin number=3)

  pinMode(ledpin,OUTPUT);

  // Timer 1
  Timer1.initialize(100000);         // initialize timer1, and set a 1/2 second period
  Timer1.attachInterrupt(encoderCheck);  // attaches callback() as a timer overflow interrupt

}


void loop(){
	
	printSensors();
	delay(200);

}

void right_Enc_INT(){
	right_enc_mini++;
	if(right_enc_mini>=ENCODER_MINI_COUNT){
		rightEnc_count++;
		right_enc_mini=0;
	}

	if(READ_BARCODE){
		cur_reading_barcode.aa();
			
	}


}


void left_Enc_INT(){
	left_enc_mini++;
	if(left_enc_mini>=ENCODER_MINI_COUNT){
		leftEnc_count++;
		left_enc_mini=0;
	}
}

void encoderCheck(){

	leftEncoderSpeedCount_2=leftEnc_count;
	rightEncoderSpeedCount_2=rightEnc_count;

	leftEncoderSpeed = leftEncoderSpeedCount_2-leftEncoderSpeedCount_1;
	rightEncoderSpeed = rightEncoderSpeedCount_2-rightEncoderSpeedCount_1;

	leftEncoderSpeedCount_1=leftEncoderSpeedCount_2;
	rightEncoderSpeedCount_1=rightEncoderSpeedCount_2;


}

void printSensors(){

	Serial.print(d_l5);
	Serial.print(" ");
	Serial.print(d_l4);
	Serial.print(" ");
	Serial.print(d_l3);
	Serial.print(" ");
	Serial.print(d_l2);
	Serial.print(" ");
	Serial.print(d_l1);
	Serial.print(" ");
	Serial.print(d_m);
	Serial.print(" ");
	Serial.print(d_r1);
	Serial.print(" ");
	Serial.print(d_r2);
	Serial.print(" ");
	Serial.print(d_r3);
	Serial.print(" ");
	Serial.print(d_r4);
	Serial.print(" ");
	Serial.println(d_r5);

}

class Barcode{


public: 
	
	int last;
	String code;

	Barcode(){
		last=0;
		code="";
	}
	
	void aaa(){

	}



}