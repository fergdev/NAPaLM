/*
 * 
 * Objective C test script for NAPaLM print var. 
 * 
 * 
 */

#import <stdio.h>
#import <objc.h>
#import <stdbool.h>
#import <MacTypes.h>

int main (int argc, const char * argv[])
{
   NSString* s = @"Hello, World!";
   // NSLog(@"s = %s", s); // NNNNAPaLMMMM

   BOOL isBool = YES;

   bool isbool = true;

   boolean isBoolean = TRUE;

   char aChar = 'a';
   // NSLog(@"aChar = %c" + aChar); // NNNNAPaLMMMM

   unsigned char anUnsignedChar = 255;

   short aShort = -32768;

   unsigned short anUnsignedShort = 65535;

   int anInt = -2147483648;

   unsigned int anUnsignedInt = 4294967295;

   long aLong = -9223372036854775808;

   unsigned long anUnsignedLong = 18446744073709551615;

   long long aLongLong = -9223372036854775808;

   unsigned long long anUnsignedLongLong = 18446744073709551615;

   float aFloat = -21.09f;

   double aDouble = -21.09f;

   long double aLongDouble = -21.09e8L;

   return 0;
}
