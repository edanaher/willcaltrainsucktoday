CFLAGS := -I ~/bin/include/urweb
all: willcaltrainsucktoday

willcaltrainsucktoday: willcaltrainsucktoday.urp main.ur main.urs giants.ur giants.urs sharks.ur sharks.urs site.css
	urweb willcaltrainsucktoday
