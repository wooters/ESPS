BIN_DIR ?= ../bin
MAN2MD_BIN := $(BIN_DIR)/man2md

.PHONY: all build test clean

all: build

build: $(MAN2MD_BIN)

$(MAN2MD_BIN): *.go go.mod
	mkdir -p $(BIN_DIR)
	go build -o $(MAN2MD_BIN) .

test:
	go test ./...

clean:
	rm -f $(MAN2MD_BIN)
