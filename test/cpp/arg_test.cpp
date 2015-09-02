/*
 *
 * Test script for NAPaLM.
 *
 */

#include <iostream>
void argTestConst(char* s, int i, double d)
{

}

void argTest(const char* s, const int i, const double d)
{

}

int main()
{
    const char* s = "Hello, World!";
    const int i = 123456789;
    const double d = 3.14159265359; 
    argTest(s, i, d);
    argTestConst(s, i, d);
}
