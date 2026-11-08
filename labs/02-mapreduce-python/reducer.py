#!/usr/bin/env python3
"""Reducer: sums amounts per key.

Hadoop sorts mapper output by key before the reducer sees it (the shuffle and sort phase),
so all lines for one store arrive together. We only need to notice when the key changes.
Summing is commutative and associative, so this same file also works as a combiner.
"""
import sys

current, total = None, 0.0
for line in sys.stdin:
    key, value = line.rstrip("\n").split("\t")
    if key != current:
        if current is not None:
            print(f"{current}\t{total:.2f}")
        current, total = key, 0.0
    total += float(value)
if current is not None:
    print(f"{current}\t{total:.2f}")
