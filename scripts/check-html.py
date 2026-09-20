#!/usr/bin/env python3
"""check-html.py — offline structural sanity check for the static site.

Uses only the Python standard library. For each *.html at the repo root it
verifies:
  * tags are balanced (every non-void element is explicitly closed, in order);
  * there are no duplicate id="" values on a page;
  * a <title> is present.

This is a smoke test for the hand-authored pages, not a full W3C conformance
run — it deliberately requires explicit closing tags (we always write them) so
that an accidental unclosed tag fails CI.

Run in CI and locally:  python3 scripts/check-html.py
"""
from __future__ import annotations

import glob
import os
import sys
from html.parser import HTMLParser

VOID = {
    "area", "base", "br", "col", "embed", "hr", "img", "input",
    "link", "meta", "param", "source", "track", "wbr",
}


class Checker(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.stack: list[tuple[str, int]] = []
        self.ids: dict[str, int] = {}
        self.errors: list[str] = []
        self.has_title = False

    def handle_starttag(self, tag, attrs):
        for name, value in attrs:
            if name == "id" and value is not None:
                if value in self.ids:
                    self.errors.append(
                        f"duplicate id={value!r} (first seen line {self.ids[value]}, "
                        f"again line {self.getpos()[0]})"
                    )
                else:
                    self.ids[value] = self.getpos()[0]
        if tag == "title":
            self.has_title = True
        if tag not in VOID:
            self.stack.append((tag, self.getpos()[0]))

    def handle_startendtag(self, tag, attrs):
        # explicit self-closing (e.g. <br/>) — treat as void, do not push
        self.handle_starttag(tag, attrs)
        if tag not in VOID and self.stack and self.stack[-1][0] == tag:
            self.stack.pop()

    def handle_endtag(self, tag):
        if tag in VOID:
            return
        if not self.stack:
            self.errors.append(f"stray </{tag}> at line {self.getpos()[0]} (nothing open)")
            return
        open_tag, open_line = self.stack[-1]
        if open_tag == tag:
            self.stack.pop()
        else:
            self.errors.append(
                f"mismatched </{tag}> at line {self.getpos()[0]}: "
                f"innermost open tag is <{open_tag}> from line {open_line}"
            )


def check(path: str) -> list[str]:
    with open(path, encoding="utf-8") as fh:
        html = fh.read()
    c = Checker()
    c.feed(html)
    errs = list(c.errors)
    if c.stack:
        unclosed = ", ".join(f"<{t}> (line {ln})" for t, ln in c.stack)
        errs.append(f"unclosed tag(s) at EOF: {unclosed}")
    if not c.has_title:
        errs.append("missing <title>")
    return errs


def main() -> int:
    root = os.path.join(os.path.dirname(__file__), "..")
    os.chdir(root)
    pages = sorted(
        p for p in glob.glob("**/*.html", recursive=True)
        if "dist" not in p.split(os.sep)
    )
    if not pages:
        print("no *.html found at repo root", file=sys.stderr)
        return 1
    total = 0
    for p in pages:
        errs = check(p)
        if errs:
            total += len(errs)
            print(f"FAIL {p}:")
            for e in errs:
                print(f"  - {e}")
        else:
            print(f"OK   {p}")
    if total:
        print(f"\nFAIL: {total} problem(s) found.")
        return 1
    print(f"\nOK: {len(pages)} page(s) structurally sound.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
