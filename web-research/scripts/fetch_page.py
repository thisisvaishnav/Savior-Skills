#!/usr/bin/env python3
"""Fetch a web page and extract readable text content.

Usage:
    python3 fetch_page.py <url> [max_chars]

Requires: Python 3.9+ standard library only.
"""
import re
import sys
import urllib.request

TAG_RE = re.compile(r"<(script|style)[^>]*>.*?</\1>", re.DOTALL | re.IGNORECASE)
HTML_RE = re.compile(r"<[^>]+>")
WS_RE = re.compile(r"\n{3,}")


def fetch(url: str) -> str:
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (research-bot)"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return resp.read().decode("utf-8", errors="replace")


def extract(html: str) -> str:
    text = TAG_RE.sub(" ", html)
    text = HTML_RE.sub("\n", text)
    text = re.sub(r"[ \t]+", " ", text)
    return WS_RE.sub("\n\n", text).strip()


def main() -> None:
    if len(sys.argv) < 2:
        sys.exit("Usage: python3 fetch_page.py <url> [max_chars]")
    url = sys.argv[1]
    max_chars = int(sys.argv[2]) if len(sys.argv) > 2 else 8000
    text = extract(fetch(url))
    print(f"URL: {url}\n{'-' * 60}")
    print(text[:max_chars])
    if len(text) > max_chars:
        print(f"\n[truncated — {len(text)} total chars]")


if __name__ == "__main__":
    main()
