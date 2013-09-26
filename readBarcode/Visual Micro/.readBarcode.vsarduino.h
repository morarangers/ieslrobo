//Board = Arduino Mega 2560 or Mega ADK
#define ARDUINO 10
#define __AVR_ATmega2560__
#define F_CPU 16000000L
#define __AVR__
#define __cplusplus
#define __attribute__(x)
#define __inline__
#define __asm__(x)
#define __extension__
#define __ATTR_PURE__
#define __ATTR_CONST__
#define __inline__
#define __asm__ 
#define __volatile__
#define __builtin_va_list
#define __builtin_va_start
#define __builtin_va_end
#define __DOXYGEN__
#define prog_void
#define PGM_VOID_P int
#define NOINLINE __attribute__((noinline))

typedef unsigned char byte;
extern "C" void __cxa_pure_virtual() {}

void leftMotorForward(int pwm);
void rightMotorForward(int pwm);
void  leftMotorBackward(int pwm);
void rightMotorBackward(int pwm);
void breakMotors(int time);
void forward(int pwm);
void backward(int pwm);
void turnLeft(int lpwm,int rpwm);
void turnRight(int lpwm,int rpwm);
void rotateLeft(int pwm);
void rotateRight(int pwm);
void rotateLeftOneMotor(int pwm);
void rotateRightOneMotor(int pwm);
//already defined in arduno.h
//already defined in arduno.h
void right_Enc_INT();
void left_Enc_INT();
void encoderCheck();
void printSensors();

#include "F:\Electronic\arduino-1.0-windows\arduino-1.0-windows\arduino-1.0\hardware\arduino\variants\mega\pins_arduino.h" 
#include "F:\Electronic\arduino-1.0-windows\arduino-1.0-windows\arduino-1.0\hardware\arduino\cores\arduino\arduino.h"
#include "C:\Users\Dell\Documents\Arduino\readBarcode\readBarcode.pde"
