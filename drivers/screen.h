#define VGA_OFFSET 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f
#define RED_ON_WHITE 0xf4

#define IO_SCREEN_CTRL 0x3d4
#define IO_SCREEN_DATA 0x3d5

#define IO_CURSOR_LOW 15
#define IO_CURSOR_HIGH 14

void kclear(void);
void kprint_at(const char *buf, int col, int row);
void kprint(const char *buf);
