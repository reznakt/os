#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

#include "../drivers/screen.h"
#include "../drivers/ports.h"
#include "../utils/string.h"

void kernel_main(void);

void __attribute__((noreturn, unused)) __kernel_entry()
{
    kernel_main();
    for (;;)
        ;
}

static int offset;
static volatile uint8_t *const vga = (volatile uint8_t *)VGA_OFFSET;

void init_offset(void)
{
    outb(IO_SCREEN_CTRL, IO_CURSOR_HIGH);
    offset = inb(IO_SCREEN_DATA) << 8;
    outb(IO_SCREEN_CTRL, IO_CURSOR_LOW);
    offset += inb(IO_SCREEN_DATA) & 0x00ff;
    offset *= 2;
}

void putchar(const char ch)
{
    vga[offset] = ch;
    vga[offset + 1] = (uint8_t)0xf4u;
    offset += 2;
}

void kernel_main(void)
{
    char *video_memory = (char *)VGA_OFFSET;

    *(video_memory + 1) = 'H';
    *(video_memory + 3) = 'e';
    *(video_memory + 5) = 'l';
    *(video_memory + 7) = 'l';
    *(video_memory + 9) = 'o';
    *(video_memory + 11) = ' ';
    *(video_memory + 13) = 'W';
    *(video_memory + 15) = 'o';
    *(video_memory + 17) = 'r';
    *(video_memory + 19) = 'l';
    *(video_memory + 21) = 'd';
    /*
    init_offset();
    putchar('X');
    */

    /*
        static const char msg[] = "Hello, World!";

        for (uint64_t i = 0; i < sizeof msg / sizeof *msg; i++)
        {
            vga[offset] = msg[i];
            vga[offset + 1] = (uint8_t)0xf4u;
            offset += 2;
        }

    */
}
