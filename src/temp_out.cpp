#include <stdio.h>
#include <stdlib.h>
#include "runtime.h"

int main()
{
printValue(makeString("merhaba"));
Value x = makeString("hello");
printValue(x);
x = makeInt(5);
printValue(x);

return 0;
}
