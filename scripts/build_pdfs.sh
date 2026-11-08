#!/usr/bin/env bash
# Rebuild the PDFs from the markdown and HTML sources.
# Needs: pandoc and Google Chrome (or Chromium). Run from the repo root: ./scripts/build_pdfs.sh
set -euo pipefail
cd "$(dirname "$0")/.."

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
command -v google-chrome >/dev/null 2>&1 && CHROME=google-chrome
command -v chromium >/dev/null 2>&1 && CHROME=chromium

print_pdf() { "$CHROME" --headless=new --disable-gpu --no-pdf-header-footer --print-to-pdf="$2" "file://$PWD/$1" 2>/dev/null; }

# 1. Cheat sheet
print_pdf cheatsheet/cheatsheet.html cheatsheet/big-data-cheatsheet.pdf

# 2. All past-paper answers in one PDF
TMP=$(mktemp -d)
cat > "$TMP/cover.md" <<'MD'
<div class="cover">
<h1>Big Data Analytics</h1>
<p>Past papers and review questions with answers</p>
<p>MIT 91205 &middot; Days 1 to 4: foundations, Hadoop, Hive and Pig, Spark</p>
<p>github.com/mugishajc/big_data_learning_resources_tools</p>
</div>
MD
pandoc "$TMP/cover.md" \
  answers/day1-foundations.md answers/day2-hadoop-mapreduce.md answers/day3-hive-pig.md \
  answers/day3-assignment.md answers/day4-spark.md answers/most-asked-questions.md \
  --from gfm --to html5 --standalone --metadata title="Big Data Analytics: Past Papers and Answers" \
  --css "$PWD/scripts/pdf.css" --embed-resources -o "$TMP/past-papers.html" 2>/dev/null \
  || pandoc "$TMP/cover.md" answers/day1-foundations.md answers/day2-hadoop-mapreduce.md \
       answers/day3-hive-pig.md answers/day3-assignment.md answers/day4-spark.md \
       answers/most-asked-questions.md --from gfm --to html5 --standalone \
       --metadata title="Big Data Analytics: Past Papers and Answers" -c "$PWD/scripts/pdf.css" -o "$TMP/past-papers.html"
"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
  --print-to-pdf=past-papers/past-papers-and-answers.pdf "file://$TMP/past-papers.html" 2>/dev/null
rm -rf "$TMP"

# 3. One PDF per answers file
mkdir -p past-papers/by-topic
for md in answers/*.md; do
  name=$(basename "$md" .md)
  T=$(mktemp -d)
  pandoc "$md" --from gfm --to html5 --standalone --metadata title="$name" \
    -c "$PWD/scripts/pdf.css" -o "$T/$name.html"
  "$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
    --print-to-pdf="past-papers/by-topic/$name.pdf" "file://$T/$name.html" 2>/dev/null
  rm -rf "$T"
done
# 4. One PDF per past-paper answers file
for md in cat-past-papers/answers/*.md; do
  [ -e "$md" ] || continue
  name=$(basename "$md" .md)
  T=$(mktemp -d)
  pandoc "$md" --from gfm --to html5 --standalone --metadata title="$name" \
    -c "$PWD/scripts/pdf.css" -o "$T/$name.html"
  "$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
    --print-to-pdf="cat-past-papers/answers/$name.pdf" "file://$T/$name.html" 2>/dev/null
  rm -rf "$T"
done

echo "Built cheatsheet/big-data-cheatsheet.pdf past-papers/past-papers-and-answers.pdf and past-papers/by-topic/*.pdf"
