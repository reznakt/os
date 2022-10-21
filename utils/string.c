#include "mem.h"

int strlen(const char *const buf)
{
    int i;
    for (i = 0; buf[i]; i++)
        ;
    return i;
}

int strcmp(const char *a, const char *b)
{
    int la = strlen(a), lb = strlen(b);

    if (la != lb)
    {
        return la - lb;
    }

    return memcmp(a, b, la);
}

void strcpy(char *const restrict dst, const char *const restrict src)
{
    memcpy(dst, src, strlen(src));
}

void strncpy(char *const restrict dst, const char *const restrict src, const int size)
{
    memcpy(dst, src, size);
}
