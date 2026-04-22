# File: cluster.py

# 1. Buat Region
ctx.createRectangularRegion("my_region", 10, 14, 12, 16)

target_keyword = "SUM" 
count = 0

print("--- PROSES MENGUNCI SEL ---")
for name, cell in ctx.cells:
    if target_keyword in name:
        # Menggunakan fungsi yang disarankan oleh sistem
        ctx.constrainCellToRegion(name, "my_region")
        count += 1

print(f"HASIL: Berhasil mengunci {count} sel ke dalam 'my_region'")