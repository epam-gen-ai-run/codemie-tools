# XLSX Tool - Filtering Guide

Advanced filtering capabilities for extracting specific data from Excel files.

## Overview

The XLSX tool provides powerful row-level filtering that works by checking if **any cell in a row** matches your filter criteria. This approach is particularly effective for:

- Pivot tables and cross-tabulated data
- Complex layouts where target data isn't in a specific column
- Files with varying structures across rows
- Quick data extraction without knowing exact column names

## Filter Modes

### Exact Match

Case-insensitive exact match of cell values.

```python
result = tool.execute(
    filter_value="Approved",
    filter_mode="exact"
)
```

**How it works:**
- Converts both filter value and cell values to lowercase
- Matches if `cell_value.lower() == filter_value.lower()`
- Skips empty cells and NaN values

**Example matches:**
- Filter: `"approved"` matches `"Approved"`, `"APPROVED"`, `"approved"`
- Filter: `"Q1"` matches `"Q1"` but not `"Q1 2024"`

### Substring Match

Case-insensitive substring search in cell values.

```python
result = tool.execute(
    filter_value="John",
    filter_mode="contains"
)
```

**How it works:**
- Converts both filter value and cell values to lowercase
- Matches if `filter_value.lower() in cell_value.lower()`
- Skips empty cells and NaN values

**Example matches:**
- Filter: `"john"` matches `"John Smith"`, `"johnson"`, `"JOHN DOE"`
- Filter: `"2024"` matches `"Q1 2024"`, `"Revenue 2024"`, `"2024-01-15"`

## Practical Examples

### Example 1: Status-Based Filtering

Extract only approved records:

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("invoices.xlsx")
tool = XlsxTool(files=[file_obj])

# Get only approved invoices
approved = tool.execute(
    filter_value="Approved",
    filter_mode="exact"
)

# Get pending or in-progress invoices
pending = tool.execute(
    filter_value="Pending",
    filter_mode="contains"  # Catches "Pending", "Pending Review", etc.
)
```

### Example 2: Date-Based Filtering

Extract data from specific time periods:

```python
# Q1 data
q1_data = tool.execute(
    filter_value="Q1",
    filter_mode="contains"
)

# Specific year
data_2024 = tool.execute(
    filter_value="2024",
    filter_mode="contains"
)

# Specific month
january = tool.execute(
    filter_value="2024-01",
    filter_mode="contains"
)
```

### Example 3: Person-Based Filtering

Extract records related to specific people:

```python
# All records mentioning "Alice"
alice_records = tool.execute(
    filter_value="Alice",
    filter_mode="contains"
)

# Exact match for employee ID
employee_123 = tool.execute(
    filter_value="EMP-123",
    filter_mode="exact"
)
```

### Example 4: Product/Category Filtering

```python
# All electronics
electronics = tool.execute(
    filter_value="Electronics",
    filter_mode="contains"
)

# Specific product
laptop = tool.execute(
    filter_value="Laptop",
    filter_mode="contains"
)

# Product code
product = tool.execute(
    filter_value="PRD-4567",
    filter_mode="exact"
)
```

## Working with Pivot Tables

Pivot tables often have complex structures where data appears in various cells. The row-level filtering approach excels here:

```python
# Sample pivot table structure:
#
# Category      | Q1    | Q2    | Q3    | Q4    | Total
# ------------- | ----- | ----- | ----- | ----- | -----
# Electronics   | 1000  | 1200  | 1100  | 1300  | 4600
# Furniture     | 800   | 850   | 900   | 950   | 3500
# Office Supply | 500   | 550   | 600   | 650   | 2300

# Extract Electronics row
electronics = tool.execute(
    sheet_names=["Pivot"],
    filter_value="Electronics",
    filter_mode="exact"
)

# Result includes the entire row with all quarters
```

## Multi-Sheet Filtering

Apply the same filter across multiple sheets:

```python
# Filter across specific sheets
result = tool.execute(
    sheet_names=["Sales_Q1", "Sales_Q2", "Sales_Q3"],
    filter_value="Premium",
    filter_mode="contains"
)

# Filter across all sheets
result = tool.execute(
    filter_value="VIP",
    filter_mode="exact"
)
```

## Combining Filters with Other Operations

### Filter + Sheet Selection

```python
# First, check what sheets exist
sheets = tool.execute(get_sheet_names=True)
print(sheets)

# Then filter specific sheet
result = tool.execute(
    sheet_names=["Active_Customers"],
    filter_value="Gold",
    filter_mode="exact"
)
```

### Filter + Sheet Index

```python
# Filter the first sheet
result = tool.execute(
    sheet_index=0,
    filter_value="Active",
    filter_mode="exact"
)
```

### Sequential Filtering (Using XlsxProcessor)

For complex filtering logic, use XlsxProcessor:

```python
from codemie_tools.file_analysis.xlsx.processor import XlsxProcessor
import pandas as pd

# Step 1: Initial filter
processor = XlsxProcessor(
    filter_value="2024",
    filter_mode="contains"
)

with open("data.xlsx", "rb") as f:
    sheets = processor.load(f.read())

# Step 2: Additional pandas filtering
df = sheets["Sales"]
df_q1 = df[df.apply(lambda row: "Q1" in str(row.values), axis=1)]

# Step 3: More complex logic
df_high_value = df_q1[df_q1.apply(
    lambda row: any(isinstance(val, (int, float)) and val > 1000
                    for val in row.values),
    axis=1
)]
```

## Performance Considerations

### Efficient Filtering

```python
# Good: Filter at load time
result = tool.execute(filter_value="Active", filter_mode="exact")

# Less efficient: Load then filter manually
result_all = tool.execute()
# Then manually parse and filter...
```

### Large Files

```python
# For very large files, filter specific sheets
result = tool.execute(
    sheet_names=["Current_Year"],  # Load only relevant sheet
    filter_value="Q1",
    filter_mode="contains"
)
```

## Common Patterns

### Pattern 1: Hierarchical Filtering

```python
# Level 1: Get all 2024 data
data_2024 = tool.execute(
    filter_value="2024",
    filter_mode="contains"
)

# Level 2: Get Q1 specifically
q1_2024 = tool.execute(
    filter_value="Q1 2024",
    filter_mode="contains"
)
```

### Pattern 2: Multi-Value Search

To search for multiple values, call execute multiple times:

```python
values_to_find = ["Approved", "Pending Review", "In Progress"]

results = {}
for status in values_to_find:
    results[status] = tool.execute(
        filter_value=status,
        filter_mode="exact"
    )
```

### Pattern 3: Negative Filtering (Using XlsxProcessor)

To exclude certain rows:

```python
from codemie_tools.file_analysis.xlsx.processor import XlsxProcessor

processor = XlsxProcessor()
with open("data.xlsx", "rb") as f:
    sheets = processor.load(f.read())

# Exclude rows containing "Cancelled"
df = sheets["Orders"]
df_active = df[~df.apply(
    lambda row: "Cancelled" in str(row.values).lower(),
    axis=1
)]
```

### Pattern 4: Composite Filtering

Combine filter with statistics:

```python
# Step 1: Get structure
stats = tool.execute(get_stats=True)

# Step 2: Filter based on what you learned
result = tool.execute(
    sheet_names=["TransactionData"],  # From stats
    filter_value="Credit",
    filter_mode="exact"
)
```

## Edge Cases

### Empty Cells

Empty cells and NaN values are automatically skipped:

```python
# This won't match rows with empty cells
result = tool.execute(
    filter_value="",  # Won't match anything
    filter_mode="exact"
)
```

### Numeric Values

Numeric values are converted to strings for comparison:

```python
# Matching numeric values
result = tool.execute(
    filter_value="1000",  # Matches cells with value 1000
    filter_mode="exact"
)

# Partial numeric match
result = tool.execute(
    filter_value="100",  # Matches 100, 1000, 10000, etc.
    filter_mode="contains"
)
```

### Boolean Values

Boolean values are converted to strings:

```python
# Match boolean True
result = tool.execute(
    filter_value="True",
    filter_mode="exact"
)

# Match boolean False
result = tool.execute(
    filter_value="False",
    filter_mode="exact"
)
```

### Special Characters

Special characters are matched literally:

```python
# Match email
result = tool.execute(
    filter_value="user@example.com",
    filter_mode="exact"
)

# Match price with $
result = tool.execute(
    filter_value="$1,000",
    filter_mode="contains"
)
```

## Troubleshooting

### No Results Returned

If filtering returns no results:

1. **Check the filter value**:
   ```python
   # First, see what's actually in the file
   stats = tool.execute(get_stats=True)
   print(stats)  # Check sample values
   ```

2. **Try contains mode instead of exact**:
   ```python
   # More lenient
   result = tool.execute(
       filter_value="search_term",
       filter_mode="contains"
   )
   ```

3. **Check for hidden sheets**:
   ```python
   # Include hidden sheets
   result = tool.execute(
       visible_only=False,
       filter_value="search_term"
   )
   ```

### Unexpected Results

If you get unexpected rows:

1. **Use exact mode for precision**:
   ```python
   # Precise matching
   result = tool.execute(
       filter_value="Q1",
       filter_mode="exact"  # Won't match "Q1 2024"
   )
   ```

2. **Check for case sensitivity**:
   ```python
   # Both are case-insensitive, so:
   filter_value="ACTIVE" == filter_value="active"
   ```

## Best Practices

1. **Start with statistics**:
   ```python
   stats = tool.execute(get_stats=True)
   # Examine actual values before filtering
   ```

2. **Use exact mode when possible**:
   ```python
   # More predictable
   result = tool.execute(filter_value="Exact Value", filter_mode="exact")
   ```

3. **Filter specific sheets**:
   ```python
   # More efficient
   result = tool.execute(
       sheet_names=["TargetSheet"],
       filter_value="value"
   )
   ```

4. **Test filters incrementally**:
   ```python
   # Test on one sheet first
   result = tool.execute(
       sheet_index=0,
       filter_value="test",
       filter_mode="exact"
   )
   # Then apply to all sheets
   ```

## Next Steps

- [Statistics Guide](statistics.md): Understanding the data structure
- [Usage Guide](usage-guide.md): General usage patterns
- [Examples](examples.md): More practical examples
- [API Reference](api-reference.md): Complete API documentation
