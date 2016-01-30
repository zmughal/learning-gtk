CFLAGS := `pkg-config --cflags gtk+-3.0 gmodule-2.0`
LDLIBS := `pkg-config --libs   gtk+-3.0 gmodule-2.0`

BINS := charter
OBJS := callbacks.o

all: $(BINS)

charter: charter.c support.h $(OBJS)

.PHONY: clean

clean:
	rm $(BINS) $(OBJS)
