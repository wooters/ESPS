package main

import (
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
)

func usage() {
	fmt.Fprintf(os.Stderr, "Usage: %s <input-man-file|-> <output-markdown-file|->\n", filepath.Base(os.Args[0]))
	flag.PrintDefaults()
}

func main() {
	flag.Usage = usage
	flag.Parse()

	if flag.NArg() != 2 {
		usage()
		os.Exit(2)
	}

	inputName := flag.Arg(0)
	outputName := flag.Arg(1)

	var in io.ReadCloser
	if inputName == "-" {
		in = os.Stdin
	} else {
		f, err := os.Open(inputName)
		if err != nil {
			fmt.Fprintf(os.Stderr, "man2md: open input %q: %v\n", inputName, err)
			os.Exit(1)
		}
		in = f
		defer in.Close()
	}

	markdown, err := Convert(in, inputName)
	if err != nil {
		fmt.Fprintf(os.Stderr, "man2md: convert %q: %v\n", inputName, err)
		os.Exit(1)
	}

	var out io.WriteCloser
	if outputName == "-" {
		out = os.Stdout
	} else {
		f, err := os.Create(outputName)
		if err != nil {
			fmt.Fprintf(os.Stderr, "man2md: create output %q: %v\n", outputName, err)
			os.Exit(1)
		}
		out = f
		defer out.Close()
	}

	if _, err := io.WriteString(out, markdown); err != nil {
		fmt.Fprintf(os.Stderr, "man2md: write output %q: %v\n", outputName, err)
		os.Exit(1)
	}
}
