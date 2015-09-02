/*
 *
 * C++ test script for NAPaLM print var.
 *
 *
 */
#include <iostream>

int main()
{
    //char* aString = "Hello, World!";
    const char* aConstString = "Hello, World!";
    
    char aChar                             = 'a';
    const char aConstChar                  = 'b';
    signed char aSignedChar                = 'c';
    const signed char aConstSignedChar     = 'd';
    unsigned char aUnsignedChar            = 'e';
    const unsigned char aConstUnsignedChar = 'f';

    wchar_t aWchar                             = 'a';
    const wchar_t aConstWchar                  = 'b';
    signed wchar_t aSignedWchar                = 'c';
    const signed wchar_t aConstSignedWchar     = 'd';
    unsigned wchar_t aUnsignedWchar            = 'e';
    const unsigned wchar_t aConstUnsignedWchar = 'f';

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

    int8_t aInt8              = 0;
    const int8_t aConstInt8   = 0;
    uint8_t atUint8           = 0;
    const uint8_t aConstUint8 = 0;

    int16_t aInt16              = 0;
    const int16_t aConstInt16   = 0;
    uint16_t atUint16           = 0;
    const uint16_t aConstUint16 = 0;

    int32_t aInt32              = 0;
    const int32_t aConstInt32   = 0;
    uint32_t atUint32           = 0;
    const uint32_t aConstUint32 = 0;

    int64_t aInt64              = 0;
    const int64_t aConstInt64   = 0;
    uint64_t atUint64           = 0;
    const uint64_t aConstUint64 = 0;

    int_fast8_t aFastInt8              = 0;
    const int_fast8_t aConstFastInt8   = 0;
    uint_fast8_t atUFastint8           = 0;
    const uint_fast8_t aConstFastUint8 = 0;
    
    int_fast16_t aFastInt16              = 0;
    const int_fast16_t aConstFastInt16   = 0;
    uint_fast16_t atUFastint16           = 0;
    const uint_fast16_t aConstFastUint16 = 0;

    int_fast32_t aFastInt32              = 0;
    const int_fast32_t aConstFastInt32   = 0;
    uint_fast32_t atFastUint32           = 0;
    const uint_fast32_t aConstFastUint32 = 0;

    int_fast64_t aFastInt64              = 0;
    const int_fast64_t aConstFastInt64   = 0;
    uint_fast64_t atFastUint64           = 0;
    const uint_least64_t aConstFastUint64 = 0;
    
    int_least8_t aLeastInt8              = 0;
    const int_least8_t aConstLeastInt8   = 0;
    uint_least8_t atULeastint8           = 0;
    const uint_least8_t aConstLeastUint8 = 0;

    int_least16_t aLeastInt16              = 0;
    const int_least16_t aConstLeastInt16   = 0;
    uint_least16_t atULeastint16           = 0;
    const uint_least16_t aConstLeastUint16 = 0;

    int_least32_t aLeastInt32              = 0;
    const int_least32_t aConstLeastInt32   = 0;
    uint_least32_t atLeastUint32           = 0;
    const uint_least32_t aConstLeastUint32 = 0;

    int_least64_t aLeastInt64              = 0;
    const int_least64_t aConstLeastInt64   = 0;
    uint_least64_t atLeastUint64           = 0;
    const uint_least64_t aConstLeastUint64 = 0;

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

    bool aBool = false;
    
    return 0;
};
