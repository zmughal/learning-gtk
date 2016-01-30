LDFLAGS := `pkg-config --cflags --libs gtk+-3.0`

BINS := charter

all: $(BINS)

charter: charter.c support.h

.PHONY: clean

clean:
	rm $(BINS)
