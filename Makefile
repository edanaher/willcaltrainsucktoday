CFLAGS := -I ~/bin/include/urweb
all: willcaltrainsucktoday

willcaltrainsucktoday: date.o willcaltrainsucktoday.urp main.ur main.urs date.urs
	urweb willcaltrainsucktoday
