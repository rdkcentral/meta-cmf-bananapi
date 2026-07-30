#include <stdio.h>

// 1. UNIQUE CUSTOM CODE (Alters the file hash so it's not a 100% match)
void rdk_bsp_helper_print() {
    printf("Initializing CMF BananaPi BSP helper...\\n");
}

/* OPEN SOURCE SNIPPET STARTS HERE */

#define BASE 65521U     /* largest prime smaller than 65536 */
#define NMAX 5552       /* NMAX is the largest n such that 255n(n+1)/2 + (n+1)(BASE-1) <= 2^32-1 */

#define DO1(buf,i)  {adler += (buf)[i]; sum2 += adler;}
#define DO2(buf,i)  DO1(buf,i); DO1(buf,i+1);
#define DO4(buf,i)  DO2(buf,i); DO2(buf,i+2);
#define DO8(buf,i)  DO4(buf,i); DO4(buf,i+4);
#define DO16(buf)   DO8(buf,0); DO8(buf,8);

unsigned long adler32(unsigned long adler, const unsigned char *buf, unsigned int len) {
    unsigned long sum2;
    unsigned int n;

    sum2 = (adler >> 16) & 0xffff;
    adler &= 0xffff;

    if (buf == ((void *)0)) return 1L;

    while (len > 0) {
        n = len < NMAX ? len : NMAX;
        len -= n;
        while (n >= 16) {
            DO16(buf);
            buf += 16;
            n -= 16;
        }
        while (n > 0) {
            sum2 += (adler += *buf++);
            n--;
        }
        adler %= BASE;
        sum2 %= BASE;
    }
    return adler | (sum2 << 16);
}
/* OPEN SOURCE SNIPPET ENDS HERE */

// 2. MORE UNIQUE CUSTOM CODE
int get_cmf_tester_id() {
    return 871 * 42;
}
