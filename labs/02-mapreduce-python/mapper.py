#!/usr/bin/env python3
"""Mapper: revenue per store. Reads sales.csv lines on stdin, emits "store_id<TAB>amount".

Same role as map() on the Day 2 slides: one input record in, zero or more key-value pairs out.
"""
import sys

for line in sys.stdin:
    fields = line.strip().split(",")
    if len(fields) != 6 or fields[0] == "sale_id":   # skip the header and broken lines
        continue
    store_id, amount = fields[2], fields[4]
    print(f"{store_id}\t{amount}")
