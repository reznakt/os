#include "ports.h"

#include "screen.h"

static unsigned char *const vga = (unsigned char *)VGA_OFFSET;

static int cursor_get_offset(void)
{
	outb(IO_SCREEN_CTRL, IO_CURSOR_HIGH);
	int position = inb(IO_SCREEN_DATA) << 8;

	outb(IO_SCREEN_CTRL, IO_CURSOR_LOW);
	position += inb(IO_SCREEN_DATA);

	return position * 2;
}

static void cursor_set_offset(int offset)
{
	offset /= 2;
	outb(IO_SCREEN_CTRL, IO_CURSOR_HIGH);
	outb(IO_SCREEN_DATA, (unsigned char)(offset >> 8));
	outb(IO_SCREEN_CTRL, IO_CURSOR_LOW);
	outb(IO_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

static int get_offset(const int row, const int col)
{
	return (row * MAX_COLS + col) * 2;
}

static int get_row(const int offset)
{
	return offset / (2 * MAX_COLS);
}

static int get_col(const int offset)
{
	return (offset - (get_row(offset) * 2 * MAX_COLS)) / 2;
}

static int print_char(const char c, const int row, const int col)
{
	int offset;

	if (c == '\n')
	{
		offset = get_offset(row + 1, 0);
	}
	else
	{
		offset = get_offset(row, col);
	}

	vga[offset] = c;
	vga[offset + 1] = WHITE_ON_BLACK;

	cursor_set_offset(offset + 2);
	return offset + 2;
}

void kclear(void)
{
	for (int i = 0; i < MAX_ROWS * MAX_COLS; i++)
	{
		vga[i * 2] = ' ';
		vga[i * 2 + 1] = WHITE_ON_BLACK;
	}

	cursor_set_offset(get_offset(0, 0));
}

void kprint_at(const char *const buf, int row, int col)
{
	int offset = get_offset(row, col);

	for (int i = 0; buf[i]; i++)
	{
		offset = print_char(buf[i], row, col);
		row = get_row(offset);
		col = get_col(offset);
	}
}

void kprint(const char *const buf)
{
	int offset = cursor_get_offset();
	kprint_at(buf, get_row(offset), get_col(offset));
}
