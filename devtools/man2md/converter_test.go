package main

import (
	"io/fs"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"
)

var manFilePattern = regexp.MustCompile(`\.[1-9](\.[^.]+)?$`)

func TestConvertSimpleMan(t *testing.T) {
	input := `
.TH FOO 1
.SH NAME
foo \- sample utility
.SH SYNOPSIS
.B foo
.RI [ options ] " file"
.TP
.BI \-o " output"
write output
`
	got, err := Convert(strings.NewReader(input), "")
	if err != nil {
		t.Fatalf("convert returned error: %v", err)
	}
	if !strings.Contains(got, "# FOO (1)") {
		t.Fatalf("expected title in output, got:\n%s", got)
	}
	if !strings.Contains(got, "## NAME") {
		t.Fatalf("expected NAME section in output, got:\n%s", got)
	}
	if !strings.Contains(got, "- **") {
		t.Fatalf("expected tagged list output, got:\n%s", got)
	}
}

func TestConvertSimpleMdoc(t *testing.T) {
	input := `
.Dd 3/11/05
.Dt audiom 1
.Sh NAME
.Nm audiom
.Nd audio tester
.Sh SYNOPSIS
.Nm
.Op Fl a Ar path
`
	got, err := Convert(strings.NewReader(input), "")
	if err != nil {
		t.Fatalf("convert returned error: %v", err)
	}
	if !strings.Contains(got, "# audiom (1)") {
		t.Fatalf("expected title in output, got:\n%s", got)
	}
	if !strings.Contains(got, "## NAME") {
		t.Fatalf("expected NAME section in output, got:\n%s", got)
	}
	if !strings.Contains(got, "`-a`") {
		t.Fatalf("expected rendered flag, got:\n%s", got)
	}
}

func TestConvertSelectedRepoExamples(t *testing.T) {
	repoRoot := findRepoRoot(t)

	examples := []string{
		filepath.Join(repoRoot, "ESPS", "ATT", "formant", "man", "formant.1"),
		filepath.Join(repoRoot, "macAudio", "audioM.1"),
		filepath.Join(repoRoot, "ESPS", "general", "man", "man3", "getsdorecs.3"),
	}

	for _, path := range examples {
		data, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read %s: %v", path, err)
		}
		got, err := Convert(strings.NewReader(string(data)), path)
		if err != nil {
			t.Fatalf("convert %s: %v", path, err)
		}
		if strings.TrimSpace(got) == "" {
			t.Fatalf("expected non-empty output for %s", path)
		}
	}
}

func TestConvertAllRepoManPages_NoErrors(t *testing.T) {
	repoRoot := findRepoRoot(t)

	var manPages []string
	err := filepath.WalkDir(repoRoot, func(path string, d fs.DirEntry, walkErr error) error {
		if walkErr != nil {
			return walkErr
		}
		if d.IsDir() {
			if d.Name() == ".git" {
				return filepath.SkipDir
			}
			return nil
		}
		if manFilePattern.MatchString(d.Name()) {
			manPages = append(manPages, path)
		}
		return nil
	})
	if err != nil {
		t.Fatalf("walk repo: %v", err)
	}

	if len(manPages) == 0 {
		t.Fatal("no man pages found")
	}

	for _, path := range manPages {
		f, err := os.Open(path)
		if err != nil {
			t.Fatalf("open %s: %v", path, err)
		}
		_, convErr := Convert(f, path)
		closeErr := f.Close()
		if convErr != nil {
			t.Fatalf("convert %s: %v", path, convErr)
		}
		if closeErr != nil {
			t.Fatalf("close %s: %v", path, closeErr)
		}
	}
}

func findRepoRoot(t *testing.T) string {
	t.Helper()

	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}

	dir := wd
	for i := 0; i < 12; i++ {
		if _, err := os.Stat(filepath.Join(dir, ".git")); err == nil {
			return dir
		}
		next := filepath.Dir(dir)
		if next == dir {
			break
		}
		dir = next
	}

	t.Fatalf("could not find repo root from %s", wd)
	return ""
}
