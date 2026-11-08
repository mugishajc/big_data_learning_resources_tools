"""Build the two past-paper PDFs: scanned questions first, then the model answers.

  cat-past-papers/CAT past paper July 2026 (questions and answers).pdf
  cat-past-papers/Final exam past papers (questions and answers).pdf

Needs: pypdf, pandoc, Google Chrome. Run from the repo root:
  python scripts/build_past_papers.py
"""
import os
import subprocess
import tempfile
from pathlib import Path

from pypdf import PdfReader, PdfWriter

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "cat-past-papers"
SCAN = OUT / "source" / "scan-compressed.pdf"
ANSWERS = OUT / "answers"
CSS = ROOT / "scripts" / "pdf.css"
CHROME = os.environ.get("CHROME", "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")

# Scanned page numbers (1-based). Page 8 is the end of CAT Question 5, scanned out of order.
CAT_PAGES = [1, 2, 3, 4, 5, 6, 8]
FINAL_PAGES = [7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]


def answers_pdf(md_files, title, tmp):
    html = Path(tmp) / f"{title}.html"
    pdf = Path(tmp) / f"{title}.pdf"
    subprocess.run(["pandoc", *map(str, md_files), "--from", "gfm", "--to", "html5", "--standalone",
                    "--metadata", f"title={title}", "-c", str(CSS), "-o", str(html)], check=True)
    subprocess.run([CHROME, "--headless=new", "--disable-gpu", "--no-pdf-header-footer",
                    f"--print-to-pdf={pdf}", html.as_uri()], check=True, capture_output=True)
    return pdf


def build(name, pages, md_files):
    scan = PdfReader(SCAN)
    with tempfile.TemporaryDirectory() as tmp:
        answers = PdfReader(answers_pdf(md_files, name, tmp))
        w = PdfWriter()
        for n in pages:
            w.add_page(scan.pages[n - 1])
        w.add_outline_item("Questions", 0)
        first_answer = len(w.pages)
        for p in answers.pages:
            w.add_page(p)
        w.add_outline_item("Answers", first_answer)
        w.add_metadata({"/Title": name})
        target = OUT / f"{name}.pdf"
        with open(target, "wb") as f:
            w.write(f)
    print(f"{target.relative_to(ROOT)}: {len(pages)} question pages + {len(answers.pages)} answer pages")


if (ANSWERS / "cat-2026-07.md").exists():
    build("CAT past paper July 2026 (questions and answers)", CAT_PAGES,
          [ANSWERS / "cat-2026-07.md"])
build("Final exam past papers (questions and answers)", FINAL_PAGES,
      [ANSWERS / "final-2026-07.md", ANSWERS / "final-2025-10-mscit9128.md"])
