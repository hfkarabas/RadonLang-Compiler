#include <stdio.h>
#include <stdlib.h>
#include "runtime.h"

int main()
{
Value a = makeInt(5);
printValue(a);
a = makeInt(10);
printValue(a);
a = makeString("test");
printValue(a);

return 0;
}
