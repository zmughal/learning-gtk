PKGS := goocanvas-2.0
CFLAGS  := `pkg-config --cflags $(PKGS)`
LDFLAGS := `pkg-config --libs $(PKGS)`

BIN := model-view-canvas
all: $(BIN)

.PHONY: clean
clean:
	$(RM)  $(BIN)
