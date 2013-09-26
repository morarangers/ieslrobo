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
  leftMotorForward((pwm));
  rightMotorForward((pwm));
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

  pinMode(36,INPUT);

}


void loop(){
	//forward(50);
	int a=digitalRead(36);
	Serial.println(a);
	delay(200);
}