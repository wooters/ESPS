package main

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

type listKind int

const (
	listBullet listKind = iota
	listEnum
	listTag
)

type listContext struct {
	kind listKind
	next int
}

type converter struct {
	lines []string

	sawTitle    bool
	currentName string

	inPre         bool
	pendingTP     bool
	inTermDesc    bool
	skipMacroBody bool

	listStack []listContext
	included  map[string]struct{}
}

var (
	reFontShort = regexp.MustCompile(`\\f[PRIB123]`)
	reFontLong  = regexp.MustCompile(`\\f\([A-Za-z0-9]{2}`)
	reSize      = regexp.MustCompile(`\\s[+-]?[0-9]+`)
	reMove      = regexp.MustCompile(`\\[hv]'[^']*'`)
	reString2   = regexp.MustCompile(`\\\*\([A-Za-z0-9]{2}`)
	reString1   = regexp.MustCompile(`\\\*[A-Za-z0-9]`)
	reSpecial   = regexp.MustCompile(`\\\([A-Za-z0-9]{2}`)
	reMultiWS   = regexp.MustCompile(`[ \t]+`)
)

// Convert translates a troff/nroff man page into Markdown.
func Convert(r io.Reader, sourcePath string) (string, error) {
	c := &converter{
		included: make(map[string]struct{}),
	}
	if sourcePath != "" {
		if abs, err := filepath.Abs(sourcePath); err == nil {
			c.included[abs] = struct{}{}
			sourcePath = abs
		}
	}

	if err := c.convertReader(r, sourcePath, 0); err != nil {
		return "", err
	}
	if c.inPre {
		c.emitLine("```")
		c.inPre = false
	}

	out := strings.TrimSpace(strings.Join(c.lines, "\n"))
	if out == "" {
		return "", nil
	}
	return out + "\n", nil
}

func (c *converter) convertReader(r io.Reader, currentPath string, depth int) error {
	if depth > 32 {
		return errors.New("include depth exceeded")
	}

	br := bufio.NewReader(r)
	for {
		line, err := br.ReadString('\n')
		if err != nil && !errors.Is(err, io.EOF) {
			return err
		}

		if line == "" && errors.Is(err, io.EOF) {
			break
		}

		line = strings.TrimRight(line, "\r\n")
		if c.skipMacroBody {
			if strings.TrimSpace(line) == ".." {
				c.skipMacroBody = false
			}
		} else {
			if procErr := c.processLine(line, currentPath, depth); procErr != nil {
				return procErr
			}
		}

		if errors.Is(err, io.EOF) {
			break
		}
	}

	return nil
}

func (c *converter) processLine(line, currentPath string, depth int) error {
	trimmed := strings.TrimSpace(line)
	if trimmed == "" {
		if c.inPre {
			c.emitLine("")
		} else {
			c.emitBlank()
			c.inTermDesc = false
		}
		return nil
	}

	if isCommentLine(trimmed) {
		return nil
	}

	if trimmed[0] == '.' || trimmed[0] == '\'' {
		return c.handleMacroLine(trimmed, currentPath, depth)
	}

	c.emitText(cleanInline(trimmed))
	return nil
}

func isCommentLine(line string) bool {
	return strings.HasPrefix(line, ".\\\"") || strings.HasPrefix(line, "'\\\"")
}

func (c *converter) handleMacroLine(line, currentPath string, depth int) error {
	body := strings.TrimSpace(line[1:])
	if body == "" {
		return nil
	}

	cmd, rest := splitCommand(body)
	if cmd == "" {
		return nil
	}

	rest = stripInlineComment(rest)
	args := parseMacroArgs(rest)
	key := strings.ToLower(cmd)

	switch key {
	case "de", "ig":
		c.skipMacroBody = true
		return nil
	case "th", "dt":
		c.handleTitle(args)
		return nil
	case "dd", "os":
		return nil
	case "sh":
		c.handleSection(args, "##")
		return nil
	case "ss":
		c.handleSection(args, "###")
		return nil
	case "pp", "p", "lp", "np", "sp", "br", "pd":
		c.emitBlank()
		c.inTermDesc = false
		return nil
	case "tp":
		c.emitBlank()
		c.pendingTP = true
		c.inTermDesc = false
		return nil
	case "ip", "hp":
		c.emitBlank()
		label := c.renderInlineMacro(key, args)
		if label == "" {
			c.emitLine("-")
		} else {
			c.emitLine("- **" + label + "**")
		}
		c.pendingTP = false
		c.inTermDesc = true
		return nil
	case "rs":
		c.emitBlank()
		return nil
	case "re":
		c.inTermDesc = false
		return nil
	case "nf":
		if !c.inPre {
			c.emitBlank()
			c.emitLine("```")
			c.inPre = true
		}
		c.inTermDesc = false
		return nil
	case "fi":
		if c.inPre {
			c.emitLine("```")
			c.emitBlank()
			c.inPre = false
		}
		c.inTermDesc = false
		return nil
	case "so":
		if len(args) > 0 && currentPath != "" {
			return c.includeFile(args[0], currentPath, depth)
		}
		return nil
	case "bl":
		c.pushList(args)
		return nil
	case "el":
		c.popList()
		c.inTermDesc = false
		return nil
	case "it":
		c.handleListItem(args)
		return nil
	default:
		text := c.renderInlineMacro(key, args)
		if text != "" {
			c.emitText(text)
		}
		return nil
	}
}

func (c *converter) handleTitle(args []string) {
	if c.sawTitle {
		return
	}

	title := ""
	if len(args) > 0 {
		title = cleanInline(args[0])
	}
	section := ""
	if len(args) > 1 {
		section = cleanInline(args[1])
	}
	if title == "" {
		title = "Manual Page"
	}
	if section != "" {
		title = title + " (" + section + ")"
	}

	c.emitLine("# " + title)
	c.emitBlank()
	c.sawTitle = true
}

func (c *converter) handleSection(args []string, prefix string) {
	c.pendingTP = false
	c.inTermDesc = false
	title := cleanInline(strings.Join(args, " "))
	if title == "" {
		return
	}
	c.emitBlank()
	c.emitLine(prefix + " " + title)
	c.emitBlank()
}

func (c *converter) pushList(args []string) {
	kind := listBullet
	for _, a := range args {
		l := strings.ToLower(cleanInline(a))
		switch l {
		case "-enum":
			kind = listEnum
		case "-tag", "-diag", "-hang", "-ohang":
			kind = listTag
		case "-bullet", "-item":
			kind = listBullet
		}
	}
	c.listStack = append(c.listStack, listContext{
		kind: kind,
		next: 1,
	})
	c.pendingTP = false
	c.inTermDesc = false
}

func (c *converter) popList() {
	if len(c.listStack) == 0 {
		return
	}
	c.listStack = c.listStack[:len(c.listStack)-1]
}

func (c *converter) handleListItem(args []string) {
	c.emitBlank()
	c.pendingTP = false

	itemText := c.renderListItemText(args)

	if len(c.listStack) == 0 {
		if itemText == "" {
			c.emitLine("-")
		} else {
			c.emitLine("- " + itemText)
		}
		c.inTermDesc = false
		return
	}

	top := &c.listStack[len(c.listStack)-1]
	switch top.kind {
	case listEnum:
		if itemText == "" {
			itemText = "item"
		}
		c.emitLine(fmt.Sprintf("%d. %s", top.next, itemText))
		top.next++
		c.inTermDesc = false
	case listTag:
		if itemText == "" {
			c.emitLine("-")
		} else {
			c.emitLine("- **" + itemText + "**")
		}
		c.inTermDesc = true
	default:
		if itemText == "" {
			c.emitLine("-")
		} else {
			c.emitLine("- " + itemText)
		}
		c.inTermDesc = false
	}
}

func (c *converter) renderListItemText(args []string) string {
	if len(args) == 0 {
		return ""
	}

	first := strings.ToLower(args[0])
	if isInlineMacro(first) {
		return c.renderMdocSequence(args)
	}
	return cleanInline(strings.Join(args, " "))
}

func isInlineMacro(name string) bool {
	switch strings.ToLower(name) {
	case "nm", "nd", "op", "fl", "ar", "pa", "xr", "em", "sy", "li", "ic", "cm", "ql", "sq", "dq",
		"b", "i", "bi", "ib", "br", "rb", "ir", "ri":
		return true
	default:
		return false
	}
}

func (c *converter) renderInlineMacro(name string, args []string) string {
	switch name {
	case "b", "sy", "li", "ic", "cm":
		return wrapStrong(cleanJoin(args))
	case "i", "em":
		return wrapEm(cleanJoin(args))
	case "nm":
		if len(args) > 0 {
			c.currentName = cleanInline(args[0])
			return wrapStrong(cleanJoin(args))
		}
		if c.currentName != "" {
			return wrapStrong(c.currentName)
		}
		return ""
	case "nd":
		return cleanJoin(args)
	case "bi", "ib", "br", "rb", "ir", "ri":
		return renderAlternating(name, args)
	case "fl":
		if len(args) == 0 {
			return "`-`"
		}
		out := make([]string, 0, len(args))
		for _, arg := range args {
			a := cleanInline(arg)
			if a == "" {
				continue
			}
			if strings.HasPrefix(a, "-") {
				out = append(out, "`"+a+"`")
			} else {
				out = append(out, "`-"+a+"`")
			}
		}
		return strings.Join(out, " ")
	case "ar":
		if len(args) == 0 {
			return wrapEm("arg")
		}
		out := make([]string, 0, len(args))
		for _, arg := range args {
			a := cleanInline(arg)
			if a != "" {
				out = append(out, wrapEm(a))
			}
		}
		return strings.Join(out, " ")
	case "op":
		content := c.renderMdocSequence(args)
		if content == "" {
			return "[]"
		}
		return "[" + content + "]"
	case "pa":
		out := make([]string, 0, len(args))
		for _, arg := range args {
			a := cleanInline(arg)
			if a != "" {
				out = append(out, "`"+a+"`")
			}
		}
		return strings.Join(out, " ")
	case "xr":
		if len(args) >= 2 {
			return cleanInline(args[0]) + "(" + cleanInline(args[1]) + ")"
		}
		return cleanJoin(args)
	case "ql", "sq", "dq":
		text := cleanJoin(args)
		if text == "" {
			return ""
		}
		switch name {
		case "sq":
			return "'" + text + "'"
		case "dq":
			return "\"" + text + "\""
		default:
			return "`" + text + "`"
		}
	case "":
		return cleanJoin(args)
	default:
		return cleanJoin(args)
	}
}

func (c *converter) renderMdocSequence(args []string) string {
	if len(args) == 0 {
		return ""
	}

	var parts []string
	for i := 0; i < len(args); {
		token := strings.ToLower(args[i])
		if isInlineMacro(token) {
			if i+1 < len(args) {
				parts = append(parts, c.renderInlineMacro(token, []string{args[i+1]}))
				i += 2
				continue
			}
			parts = append(parts, c.renderInlineMacro(token, nil))
			i++
			continue
		}
		parts = append(parts, cleanInline(args[i]))
		i++
	}
	return strings.TrimSpace(strings.Join(parts, " "))
}

func renderAlternating(name string, args []string) string {
	if len(args) == 0 {
		return ""
	}

	first := byte('r')
	second := byte('r')
	if len(name) == 2 {
		first = name[0]
		second = name[1]
	}

	var parts []string
	for i, arg := range args {
		segment := cleanInline(arg)
		if segment == "" {
			continue
		}

		style := first
		if i%2 == 1 {
			style = second
		}

		switch style {
		case 'b':
			parts = append(parts, wrapStrong(segment))
		case 'i':
			parts = append(parts, wrapEm(segment))
		default:
			parts = append(parts, segment)
		}
	}
	return strings.Join(parts, " ")
}

func cleanJoin(args []string) string {
	parts := make([]string, 0, len(args))
	for _, arg := range args {
		c := cleanInline(arg)
		if c != "" {
			parts = append(parts, c)
		}
	}
	return strings.Join(parts, " ")
}

func wrapStrong(s string) string {
	if s == "" {
		return ""
	}
	return "**" + s + "**"
}

func wrapEm(s string) string {
	if s == "" {
		return ""
	}
	return "*" + s + "*"
}

func splitCommand(body string) (string, string) {
	body = strings.TrimSpace(body)
	if body == "" {
		return "", ""
	}

	i := 0
	for i < len(body) && body[i] != ' ' && body[i] != '\t' {
		i++
	}
	if i >= len(body) {
		return body, ""
	}
	return body[:i], strings.TrimSpace(body[i:])
}

func stripInlineComment(s string) string {
	if s == "" {
		return s
	}

	inQuote := false
	for i := 0; i < len(s)-1; i++ {
		ch := s[i]
		if ch == '"' {
			inQuote = !inQuote
			continue
		}
		if ch == '\\' && s[i+1] == '"' && !inQuote {
			return strings.TrimSpace(s[:i])
		}
		if ch == '\\' {
			i++
		}
	}
	return strings.TrimSpace(s)
}

func parseMacroArgs(s string) []string {
	if s == "" {
		return nil
	}

	var args []string
	var b strings.Builder
	inQuote := false

	flush := func() {
		if b.Len() == 0 {
			return
		}
		args = append(args, b.String())
		b.Reset()
	}

	for i := 0; i < len(s); i++ {
		ch := s[i]
		switch {
		case ch == '"':
			inQuote = !inQuote
		case (ch == ' ' || ch == '\t') && !inQuote:
			flush()
		default:
			b.WriteByte(ch)
		}
	}
	flush()
	return args
}

func cleanInline(s string) string {
	s = strings.TrimSpace(s)
	if s == "" {
		return ""
	}

	replacements := map[string]string{
		`\\-`:   "-",
		`\\&`:   "",
		`\\~`:   " ",
		`\\ `:   " ",
		`\\e`:   "\\",
		`\\c`:   "",
		`\\z`:   "",
		`\\(em`: "--",
		`\\(en`: "-",
		`\\(bu`: "*",
		`\\(cq`: "'",
		`\\(dq`: "\"",
		`\\(lq`: "\"",
		`\\(rq`: "\"",
		`\\(ga`: "`",
		`\\(rs`: "\\",
		`\\(tm`: "(tm)",
		`\\(co`: "(c)",
	}
	for from, to := range replacements {
		s = strings.ReplaceAll(s, from, to)
	}

	s = reMove.ReplaceAllString(s, "")
	s = reSize.ReplaceAllString(s, "")
	s = reFontLong.ReplaceAllString(s, "")
	s = reFontShort.ReplaceAllString(s, "")
	s = reString2.ReplaceAllString(s, "")
	s = reString1.ReplaceAllString(s, "")
	s = reSpecial.ReplaceAllStringFunc(s, func(match string) string {
		switch match {
		case `\(em`:
			return "--"
		case `\(en`:
			return "-"
		case `\(bu`:
			return "*"
		case `\(cq`:
			return "'"
		case `\(dq`, `\(lq`, `\(rq`:
			return "\""
		case `\(ga`:
			return "`"
		default:
			return ""
		}
	})
	s = strings.ReplaceAll(s, `\\`, `\`)
	s = reMultiWS.ReplaceAllString(s, " ")
	return strings.TrimSpace(s)
}

func (c *converter) emitText(text string) {
	text = strings.TrimSpace(text)
	if text == "" {
		return
	}

	if c.pendingTP {
		c.emitLine("- **" + text + "**")
		c.pendingTP = false
		c.inTermDesc = true
		return
	}

	if c.inTermDesc {
		c.emitLine("  " + text)
		return
	}

	if c.inPre {
		c.emitLine(text)
		return
	}

	if len(c.lines) > 0 && shouldAppendParagraph(c.lines[len(c.lines)-1]) {
		c.lines[len(c.lines)-1] = c.lines[len(c.lines)-1] + " " + text
		return
	}
	c.emitLine(text)
}

func shouldAppendParagraph(last string) bool {
	last = strings.TrimSpace(last)
	if last == "" {
		return false
	}
	if strings.HasPrefix(last, "#") {
		return false
	}
	if strings.HasPrefix(last, "- ") || strings.HasPrefix(last, "- **") {
		return false
	}
	if strings.HasPrefix(last, "1. ") || strings.HasPrefix(last, "2. ") || strings.HasPrefix(last, "3. ") {
		return false
	}
	if strings.HasPrefix(last, "```") {
		return false
	}
	if strings.HasPrefix(last, "  ") {
		return false
	}
	return true
}

func (c *converter) emitLine(line string) {
	c.lines = append(c.lines, line)
}

func (c *converter) emitBlank() {
	if len(c.lines) == 0 {
		return
	}
	if c.lines[len(c.lines)-1] == "" {
		return
	}
	c.lines = append(c.lines, "")
}

func (c *converter) includeFile(target, currentPath string, depth int) error {
	resolved, err := resolveIncludePath(target, currentPath)
	if err != nil {
		c.emitText("include " + cleanInline(target))
		return nil
	}
	if _, ok := c.included[resolved]; ok {
		return nil
	}

	f, err := os.Open(resolved)
	if err != nil {
		return err
	}
	defer f.Close()

	c.included[resolved] = struct{}{}
	return c.convertReader(f, resolved, depth+1)
}

func resolveIncludePath(target, currentPath string) (string, error) {
	target = strings.TrimSpace(target)
	target = strings.Trim(target, "\"")
	target = strings.ReplaceAll(target, "$MANDIR$/", "")
	target = strings.ReplaceAll(target, "${MANDIR}/", "")
	target = cleanInline(target)
	if target == "" {
		return "", errors.New("empty include target")
	}

	var candidates []string
	seen := make(map[string]struct{})
	addCandidate := func(path string) {
		if path == "" {
			return
		}
		abs, err := filepath.Abs(path)
		if err != nil {
			return
		}
		if _, ok := seen[abs]; ok {
			return
		}
		seen[abs] = struct{}{}
		candidates = append(candidates, abs)
	}

	if filepath.IsAbs(target) {
		addCandidate(target)
	}

	baseDir := filepath.Dir(currentPath)
	addCandidate(filepath.Join(baseDir, target))
	addCandidate(filepath.Join(filepath.Dir(baseDir), target))

	dir := baseDir
	for i := 0; i < 10; i++ {
		addCandidate(filepath.Join(dir, target))
		if strings.HasPrefix(target, "man") {
			addCandidate(filepath.Join(dir, "man", target))
		}

		next := filepath.Dir(dir)
		if next == dir {
			break
		}
		dir = next
	}

	for _, candidate := range candidates {
		if st, err := os.Stat(candidate); err == nil && !st.IsDir() {
			return candidate, nil
		}
	}

	return "", fmt.Errorf("include not found: %s", target)
}
