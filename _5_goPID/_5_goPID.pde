#include "TimerOne.h"

#define ledpin 13

#define analogThreshold 0

#define l5 analogRead(5) - 610 //new values
#define l4 analogRead(6) - 270
#define l3 analogRead(7) - 460
#define l2 analogRead(8) - 720
#define l1 analogRead(9) - 720

#define m analogRead(10) - 430
#define r1 analogRead(11) - 520
#define r2 analogRead(12) - 540
#define r3 analogRead(13) - 660
#define r4 analogRead(14) - 680
#define r5 analogRead(15) - 730

#define d_l5 (analogRead(5) - 610 - analogThreshold > 0?1:0) //new values
#define d_l4 (analogRead(6) - 270 - analogThreshold > 0?1:0)
#define d_l3 (analogRead(7) - 460 -analogThreshold > 0?1:0)
#define d_l2 (analogRead(8) - 720 -analogThreshold > 0?1:0)
#define d_l1 (analogRead(9) - 720 -analogThreshold > 0?1:0)

#define d_m (analogRead(10) - 430 -analogThreshold > 0?1:0)
#define d_r1 (analogRead(11) - 520 -analogThreshold > 0?1:0)
#define d_r2 (analogRead(12) - 540 -analogThreshold > 0?1:0)
#define d_r3 (analogRead(13) - 660-analogThreshold > 0?1:0)
#define d_r4 (analogRead(14) - 680-analogThreshold > 0?1:0)
#define d_r5 (analogRead(15) - 730-analogThreshold > 0?1:0)

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
#define ENCODER_MINI_COUNT 1

int leftEncoderSpeedCount_1=0;
int rightEncoderSpeedCount_1=0;
int leftEncoderSpeedCount_2=0;
int rightEncoderSpeedCount_2=0;

int leftEncoderSpeed=0;
int rightEncoderSpeed=0;

int time=0;

bool READ_BARCODE=false;

String barcode="";

int pwm_error=0;
//int pre_pwm_error=0;

int getDigital(int num){
	if(num==-5) return d_l5;
	if(num==-4) return d_l4;
	if(num==-3) return d_l3;
	if(num==-2) return d_l2;
	if(num==-1) return d_l1;
	if(num== 0) return d_m;
	if(num== 1) return d_r1;
	if(num== 2) return d_r2;
	if(num== 3) return d_r3;
	if(num== 4) return d_r4;
	if(num== 5) return d_r5;
}

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

void lineFollow(int pwm){
	
	/*
	int w1=1,w2=2,w3=4,w4=8,w5=16;
	int current=d_l5 * -w5 + d_l4 * -w4 + d_l3 * -w3 + d_l2 * -w2  + d_l1 * -w1 + 0 + d_r5 * w5 + d_r4 * w4 + d_r3 * w3 + d_r2 * w2  + d_r1 * w1;
	if (d_l5 ||d_l4 || d_l3 ||d_l2 || d_l1 || d_m || d_r1 || d_r2 || d_r3 || d_r4 ||d_r5){ 
		pwm_error=current*1.5;
	}*/


	int errors[]={-32,-16,-8,-2,-1,0,1,2,8,16,32};
	int common_error=0;

	int k=-5,l=5;
	
	for(int i=-5;i<=5;i++){
		if(getDigital(i)) k=i;
	}
	for(int i=5;i>=-5;i--){
		if(getDigital(i)) l=i;
	}

	int current=errors[(k+l)/2 + 5];

	if(current!=0){
		pwm_error=current*12;
	}

	Serial.println(pwm_error);
	
	int l_pwm=(pwm/9)*11 +pwm_error;
	int r_pwm=pwm - pwm_error;
	//int common_error=0;


	if(l_pwm>0){
		leftMotorForward(l_pwm-common_error);
	}else{
		leftMotorBackward(pwm-common_error);
	}

	if(r_pwm>0){
		rightMotorForward(r_pwm-common_error);
	}else{
		rightMotorBackward(pwm-common_error);
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
  Timer1.initialize(100000);         // initialize timer1, and set a 100milisecond period
  Timer1.attachInterrupt(encoderCheck);  // attaches encodercheck() as a timer overflow interrupt

}


void right_Enc_INT(){
	right_enc_mini++;
	if(right_enc_mini>=ENCODER_MINI_COUNT){
		rightEnc_count++;
		right_enc_mini=0;
	}

	if(READ_BARCODE){
		//cur_reading_barcode.aa();
			
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

void checkBarCode(){
	int x=0,y;
	while((d_m)==0){
		forward(30);
		//Serial.print("a");
	}
	y=leftEnc_count;
	Serial.println("going to black area");
	Serial.print("y = ");
	Serial.println(y);

	while((d_m)==1){
		forward(30);
		//Serial.print("b");
	}

	y=leftEnc_count-y;
	Serial.println("going to white area");
	Serial.print("length = ");
	Serial.println(y);
	//breakMotors(10000);
	forward(0);
	delay(10000);
	
}

void check(int pwm){
	breakMotors(3000);
	Serial.println("starting...");
	int values[5];
	int current;
	int count;

	for(int i=0;i<12;i++){
		current=d_m;
		count=leftEnc_count;
		while(d_m==current){
			forward(pwm);
		}
		values[i]=leftEnc_count-count;
	}

	for(int i=1;i<12;i++){
		Serial.println(values[i]);
	}
	Serial.println("end");
	breakMotors(5000);
}

void loop(){

	//go_pid();
	//lineFollow(50);
	//leftMotorForward(40);
	//rightMotorForward(40);

	lineFollow(50);
	//delay(50);
	/*
	for(int i=-5;i<=5;i++){
		Serial.print(getDigital(i));
		Serial.print(" ");
	}
	Serial.println();
	delay(50);
	*/
}


