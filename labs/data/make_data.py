"""Write the small sample dataset used by every lab.

Same three tables as the Day 3 and Day 4 slides:
  sales(sale_id, product_id, store_id, quantity, amount, dt)
  products(product_id, name, category, unit_price)
  stores(store_id, name, region)

Fixed seed, so everyone gets identical files. Run: python make_data.py
"""
import csv
import random
from datetime import date, timedelta
from pathlib import Path

random.seed(7)
HERE = Path(__file__).parent

products = [
    (1, "Rice 5kg", "Food", 9.50), (2, "Cooking oil 1L", "Food", 3.20),
    (3, "Milk 1L", "Food", 1.10), (4, "Sugar 1kg", "Food", 1.40),
    (5, "Phone charger", "Electronics", 7.00), (6, "Earphones", "Electronics", 12.00),
    (7, "Solar lamp", "Electronics", 25.00), (8, "Notebook", "Stationery", 0.80),
    (9, "Pen (box of 10)", "Stationery", 2.50), (10, "Soap bar", "Household", 0.60),
    (11, "Detergent 1kg", "Household", 2.90), (12, "Bucket 10L", "Household", 4.50),
]
stores = [
    (1, "Nyarugenge", "Kigali"), (2, "Kicukiro", "Kigali"), (3, "Gasabo", "Kigali"),
    (4, "Musanze", "North"), (5, "Huye", "South"), (6, "Rubavu", "West"), (7, "Rwamagana", "East"),
]
# Kigali stores sell more, so the data has realistic skew.
store_weights = [5, 4, 4, 2, 2, 2, 1]

with open(HERE / "products.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["product_id", "name", "category", "unit_price"])
    w.writerows(products)

with open(HERE / "stores.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["store_id", "name", "region"])
    w.writerows(stores)

start = date(2024, 3, 1)
with open(HERE / "sales.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["sale_id", "product_id", "store_id", "quantity", "amount", "dt"])
    for sale_id in range(1, 2001):
        p = random.choice(products)
        s = random.choices(stores, store_weights)[0]
        qty = random.randint(1, 6)
        # product 99 does not exist: a few orphan rows for the outer-join exercise
        pid = 99 if sale_id % 250 == 0 else p[0]
        w.writerow([sale_id, pid, s[0], qty, round(qty * p[3], 2),
                    (start + timedelta(days=random.randrange(31))).isoformat()])

print("wrote sales.csv (2000 rows), products.csv (12), stores.csv (7)")
