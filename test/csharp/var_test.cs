/*
 *
 * Test script for NAPaLM.
 *
 *
 */
public class VarTest
{
    public static void Main()
    {
        byte aByte                  = 255;
        const byte aConstByte       = 255;
        readonly byte aReadonlyByte = 255;

        sbyte aSbyte = -127;
        const sbyte aConstSbyte = -127;
        readonly sbyte aReadOnlySbyte = -127;

        short aShort = -32768;
        const short aConstShort = -32768;
        readonly short aReadonlyShort = -32768;
        
        ushort aUshort = 65535;
        const ushort aConstUshort = 65535;
        readonly ushort aReadonlyUshort = 65535;

        int aInt = -2147483648;
        const int aConstInt = -2147483648;
        readonly int aReadonlyInt = -2147483648;

        uint aUint = 429496729;
        const uint aConstUint = 429496729;
        readonly uint aReadonlyUint = 429496729;

        long aLong = -9223372036854775808;
        const long aConstLong = -9223372036854775808;
        readonly long aReadonlyLong = -9223372036854775808;
        
        ulong aUlong = 18446744073709551615;
        const ulong aConstUlong = 18446744073709551615;
        readonly ulong aReadonlyUlong = 18446744073709551615;

        float aFloat = -3.402823e38;
        const float aConstFloat = -3.402823e38;
        readonly float aReadonlyFloat = -3.402823e38;
        
        double aDouble = -1.79769313486232e308;     
        const double aConstDouble = -1.79769313486232e308;     
        readonly double aReadonlyDouble = -1.79769313486232e308;     

        char aChar = 'a';
        const char aConstChar = 'a';
        readonly char aReadonlyChar = 'a';

        bool aBool = false;
        const bool aConstBool = false;
        readonly bool aReadonlyBool = false;

        object aObject = new Object();
        const object aConstObject = new Object();
        readonly object aReadonlyObject = new Object();

        String aString = "Hello, World!";
        const String aConstString = "Hello, World!";
        readonly String aReadonlyString = "Hello, World!";

        decimal aDecimal = 79228162514264337593543950335;
        const decimal aConstDecimal = 79228162514264337593543950335;
        readonly decimal aReadonlyDecimal = 79228162514264337593543950335;
    }
}
