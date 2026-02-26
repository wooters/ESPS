BIN_DIR := bin
MAN2MD_BIN := $(BIN_DIR)/man2md

.PHONY: all man2md clean

all: man2md

man2md: $(MAN2MD_BIN)

$(MAN2MD_BIN):
	mkdir -p $(BIN_DIR)
	cd man2md && go build -o ../$(MAN2MD_BIN) .

clean:
	rm -f $(MAN2MD_BIN)
