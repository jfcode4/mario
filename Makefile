PREFIX = ~/.local

mario: *.odin
	odin build .

install: mario
	mkdir -p $(PREFIX)/share/mario
	cp -rn assets/* $(PREFIX)/share/mario/
	cp mario $(PREFIX)/bin/

uninstall:
	rm -r $(PREFIX)/share/mario
	rm $(PREFIX)/bin/mario

clean:
	rm -f mario
