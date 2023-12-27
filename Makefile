CC = c99
CFLAGS = -g -Wall -Wextra -Wpedantic
INCS = -I ~/.local/include
LIBS = -L ~/.local/lib -lgame -lSDL2 -lSDL2_image

PREFIX = ~/.local

mario: main.o player.o level.o config.o
	$(CC) $^ -o $@ $(LIBS)

main.o: config.h player.h level.h
player.o: config.h
level.o: config.h
config.o: config.h

%.o: %.c
	$(CC) $(CFLAGS) $(INCS) -c $<

install: mario
	mkdir -p $(PREFIX)/share/mario
	cp -rn assets/* $(PREFIX)/share/mario/
	cp mario $(PREFIX)/bin/

uninstall:
	rm -r $(PREFIX)/share/mario
	rm $(PREFIX)/bin/mario

clean:
	rm -f *.o mario
