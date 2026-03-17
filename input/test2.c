/* Test 2: Control statements with nesting */
int x = 10;
int y = 20;

if (x < y)
{
    int temp;
    temp = x;
    x = y;
    y = temp;
}

if (x == y)
    x = 0;
else
    y = 0;

if (x > 0)
{
    if (y > 0)
    {
        x = x + y;
    }
    else
    {
        x = x - y;
    }
}

do
{
    x = x - 1;
} while (x > 0);

do
    x = x + 1;
while (x < 100);

/* Nested do-while with if */
do
{
    if (x % 2 == 0)
        x = x / 2;
    else
        x = x * 3 + 1;
} while (x != 1);

while (x < 10)
{
    x++;
}

for (x = 0, y = 0; x < 20 && y < 20; x++, y++)
{
    if (x == y)
        x = x + 1;
}

switch (x)
{
    case 1:
        y = y + 1;
        break;
    case 2:
        y = y + 2;
        break;
    default:
        y = 0;
}
