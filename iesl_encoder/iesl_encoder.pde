#include "TimerOne.h"

#define ledpin 13

#define l5 5
#define l4 6
#define l3 7
#define l2 8
#define l1 9

#define m 10
#define r1 11
#define r2 12
#define r3 13
#define r4 14
#define r5 15

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
	
	
	while(rightEnc_count<200){
		forward(40);
		delay(1);
	}
	
	breakMotors(1000);
}

void right_Enc_INT(){
	right_enc_mini++;
	if(right_enc_mini>=ENCODER_MINI_COUNT){
		rightEnc_count++;
		right_enc_mini=0;
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
