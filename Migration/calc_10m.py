# Quick calc: how long does 10M offset last?
offset = 10_000_000

# (current_max, growth_per_month)
tables = [
    ("securitylog",      1,          14_794),
    ("procedurelog",     227_678,    2_528),
    ("appointment",      87_733,     1_336),
    ("payment",          57_315,     824),
    ("adjustment",       37_890,     496),
    ("document",         57_916,     851),
    ("patient",          10_651,     95),
]

print(f"Offset: {offset:,}")
print(f"{'Table':<20} {'Current':>10} {'Gap':>14} {'Growth/yr':>12} {'Years':>8}")
print("-" * 68)

for name, current, per_month in tables:
    gap = offset - current
    per_year = per_month * 12
    years = gap / per_year if per_year > 0 else float("inf")
    print(f"{name:<20} {current:>10,} {gap:>14,} {per_year:>12,} {years:>8.1f}")

# What if we never truncated securitylog?
print()
print("--- If securitylog was NOT truncated (still at 1,028,954) ---")
sec_max = 1_028_954
gap_sec = offset - sec_max
years_sec = gap_sec / (14_794 * 12)
print(f"securitylog: max={sec_max:,} gap={gap_sec:,} growth=177,528/yr -> {years_sec:.1f} yrs")
