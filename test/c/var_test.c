/*
 *
 * Test script for NAPaLM.
 *
 *
 */
#include<stdio.h>

int main()
{
    char* aString = "Hello, World!";
    const char* aConstString = "Hello, World!";

    char aChar                             = 'a';
    printf("aChar = %c\n", aChar); // NNNNAPaLMMMM
    const char aConstChar                  = 'b';
    printf("aConstChar = %c\n", aConstChar); // NNNNAPaLMMMM
    signed char aSignedChar                = 'c';
    printf("aSignedChar = %s\n", aSignedChar); // NNNNAPaLMMMM
    const signed char aConstSignedChar     = 'd';
    printf("aConstSignedChar = %s\n", aConstSignedChar); // NNNNAPaLMMMM
    unsigned char aUnsignedChar            = 'e';
    printf("aUnsignedChar = %c\n", aUnsignedChar); // NNNNAPaLMMMM
    const unsigned char aConstUnsignedChar = 'f';
    printf("aConstUnsignedChar = %c\n", aConstUnsignedChar); // NNNNAPaLMMMM

    short aShort                                = -32767;
    const short aConstShort                     = -32767;
    signed short aSignedShort                   = -32767;
    const signed short aConstSignedShort        = -32767;
    signed short int aSignedShortInt            = -32767;
    const signed short int aConstSignedShortInt = -32767;

    unsigned short aUnsignedShort                   = 32767;
    const unsigned short aConstUnsignedShort        = 32767;
    unsigned short int aUnsignedShortInt            = 32767;
    const unsigned short int aConstUnsignedShortInt = 32767;

    int aInt                         = -32767;
    const int aConstInt              = -32767;
    signed int aSignedInt            = -32767;
    const signed int aConstSignedInt = -32767;

    unsigned aUnsigned                   = -32767;
    const unsigned aConstUnsigned        = -32767;
    unsigned int aUnsignedInt            = -32767;
    const unsigned int aConstUnsignedInt = -32767;

    long aLong                                = -2147483647;
    const long aConstLong                     = -2147483647;
    long int aLongInt                         = -2147483647;
    const long int aConstLongInt              = -2147483647;
    signed long aSignedLong                   = -2147483647;
    const signed long aConstSignedLong        = -2147483647;
    signed long int aSignedLongInt            = -2147483647;
    const signed long int aConstSignedLongInt = -2147483647;

    unsigned long aUnsignedLong                   = 2147483647;
    const unsigned long aConstUnsignedLong        = 2147483647;
    unsigned long int aUnsignedLongInt            = 2147483647;
    const unsigned long int aConstUnsignedLongInt = 2147483647;

    long long aLongLong                                = -9223372036854775807;
    const long long aConstLongLong                     = -9223372036854775807;
    long long int aLongLongInt                         = -9223372036854775807;
    const long long int aConstLongLongInt              = -9223372036854775807;
    signed long long aSignedLongLong                   = -9223372036854775807;
    const signed long long aConstSignedLongLong        = -9223372036854775807;
    signed long long int aSignedLongLongInt            = -9223372036854775807;
    const signed long long int aConstSignedLongLongInt = -9223372036854775807;

    unsigned long long aUnsignedLongLong                   = 9223372036854775807;
    const unsigned long long aConstUnsignedLongLong        = 9223372036854775807;
    unsigned long long int aUnsignedLongLongInt            = 9223372036854775807;
    const unsigned long long int aConstUnsignedLongLongInt = 9223372036854775807;

    float aFloat                       = 3.14295;
    const float aConstFloat            = 3.14295;
    double aDouble                     = 3.14295;
    const double aConstDouble          = 3.14295;
    long double aLongDouble            = 3.14295;
    const long double aConstLongDouble = 3.14295;
};
