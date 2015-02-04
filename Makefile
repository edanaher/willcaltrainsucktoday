CFLAGS := -I ~/bin/include/urweb
all: willcaltrainsucktoday

willcaltrainsucktoday: c_date.o willcaltrainsucktoday.urp main.ur main.urs date.ur date.urs c_date.urs giants.ur giants.urs
	urweb willcaltrainsucktoday
