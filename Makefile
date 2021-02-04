CC = c89
CFLAGS = -g -Wall -Wextra -Wpedantic
INCS = -I ~/.local/include
LIBS = -L ~/.local/lib -lgame -lvec -lSDL2 -lSDL2_image

PREFIX = ~/.local

mario: main.o player.o level.o
	$(CC) $^ -o $@ $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) $(INCS) -c $^

install: mario
	mkdir -p $(PREFIX)/share/mario
	cp -rn assets/* $(PREFIX)/share/mario/
	cp mario $(PREFIX)/bin/

uninstall:
	rm -r $(PREFIX)/share/mario
	rm $(PREFIX)/bin/mario

clean:
	rm -f *.o mario
