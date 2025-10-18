# XLSX Tool - Statistics Guide

Understanding and using the statistics feature to analyze Excel file structure and content.

## Overview

The statistics feature provides comprehensive metadata about Excel files, including:

- Sheet count and names
- Column names for each sheet
- Detected data types for each column
- Sample values from each column

This information is invaluable for:

- Understanding unfamiliar Excel files
- Validating data structure before processing
- Debugging data quality issues
- Planning data extraction strategies

## Getting Statistics

### Basic Usage

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("data.xlsx")
tool = XlsxTool(files=[file_obj])

stats = tool.execute(get_stats=True)
print(stats)
```

### Including Hidden Sheets

```python
# Get statistics for all sheets including hidden ones
stats = tool.execute(
    get_stats=True,
    visible_only=False
)
```

## Output Format

The statistics output is formatted as markdown for readability:

```markdown
# Excel File Statistics: data.xlsx
- **Total Sheets:** 3

## Sheet: Sales Data

### Columns:
| Column | Data Type | Sample Values |
| ------ | --------- | ------------- |
| Date | datetime | `2024-01-15`, `2024-01-16`, `2024-01-17` |
| Product | string | `Laptop`, `Mouse`, `Keyboard`, `Monitor` |
| Quantity | integer | `5`, `10`, `2`, `1` |
| Price | float | `1200.50`, `25.99`, `89.99`, `350.00` |
| Sold | boolean | `True`, `False` |

## Sheet: Summary

### Columns:
| Column | Data Type | Sample Values |
| ------ | --------- | ------------- |
| Category | string | `Electronics`, `Accessories` |
| Total Revenue | float | `50000.00`, `12500.00` |
```

## Data Type Detection

The tool automatically detects and reports data types:

### Integer

Whole numbers without decimal points.

```python
# Examples: 1, 100, -50, 0
```

### Float

Numbers with decimal points.

```python
# Examples: 1.5, 100.00, -50.25, 0.99
```

### String

Text values, including alphanumeric combinations.

```python
# Examples: "John Doe", "Product-123", "Active"
```

### Boolean

True/False values and common boolean representations.

```python
# Detects: True, False, Yes, No, Y, N
# Case-insensitive
```

### Datetime

Date and time values.

```python
# Examples: 2024-01-15, 2024-01-15 10:30:00
```

## Sample Values

For each column, up to 5 unique sample values are provided:

- Helps understand the actual data content
- Truncated to 50 characters for readability
- Shows variety in the data

**Example:**

```markdown
| Column | Data Type | Sample Values |
| ------ | --------- | ------------- |
| Description | string | `High-performance laptop with 16GB RAM`, `Wireless mouse with ergonomic design`, `Mechanical keyboard`, `27-inch 4K monitor`, `USB-C cable` |
```

If a value exceeds 50 characters, it's truncated with `...`:

```markdown
| Column | Data Type | Sample Values |
| ------ | --------- | ------------- |
| Long Description | string | `This is a very long product description that ex...` |
```

## Use Cases

### Use Case 1: Exploring Unknown Files

```python
# You receive an unfamiliar Excel file
file_obj = FileObject.from_path("unknown_data.xlsx")
tool = XlsxTool(files=[file_obj])

# Step 1: Get statistics
stats = tool.execute(get_stats=True)
print(stats)

# Now you know:
# - What sheets exist
# - What columns are in each sheet
# - What type of data each column contains
# - Sample values to understand content

# Step 2: Process based on what you learned
result = tool.execute(
    sheet_names=["Relevant Sheet"],
    filter_value="Target Value"
)
```

### Use Case 2: Data Validation

```python
# Validate that a file has expected structure
stats = tool.execute(get_stats=True)

# Parse the statistics (you can extract programmatically if needed)
# Check that expected columns exist
# Verify data types match expectations
# Confirm sample values look correct

# Then proceed with processing
if "Sales Data" in stats and "Revenue" in stats:
    result = tool.execute(sheet_names=["Sales Data"])
```

### Use Case 3: Debugging Data Quality

```python
# Data processing is failing - check the structure
stats = tool.execute(get_stats=True)

# Questions statistics can answer:
# - Are there unexpected empty columns?
# - Are data types correct?
# - Do sample values reveal data quality issues?
# - Are there hidden sheets causing problems?
```

### Use Case 4: Planning Data Extraction

```python
# Before writing extraction logic, understand the data
stats = tool.execute(get_stats=True)

# Use statistics to:
# - Identify which sheets to process
# - Determine which columns to extract
# - Understand data types for proper handling
# - Find filter values from sample data
```

## Interpreting Statistics

### Sheet Information

```markdown
- **Total Sheets:** 3
```

Tells you how many sheets are in the file (visible only, or all if `visible_only=False`).

### Column Names

```markdown
### Columns:
| Column | Data Type | Sample Values |
| ------ | --------- | ------------- |
| Product Name | ... | ... |
```

The exact column names as they appear in the file. Use these for:
- Understanding data structure
- Planning filtering strategies
- Knowing what data is available

### Data Types

```markdown
| Column | Data Type | Sample Values |
| ------ | --------- | ------------- |
| Revenue | float | ... |
```

Helps you:
- Understand how to process the data
- Identify potential data quality issues (e.g., numbers stored as strings)
- Plan data transformations

### Sample Values

```markdown
| Column | Data Type | Sample Values |
| ------ | --------- | ------------- |
| Status | string | `Active`, `Pending`, `Closed` |
```

Use sample values to:
- Understand the range of values in a column
- Find values to use in filters
- Identify data quality issues
- Validate expected content

## Multiple Files

When processing multiple files, statistics are provided for each:

```python
files = [
    FileObject.from_path("file1.xlsx"),
    FileObject.from_path("file2.xlsx"),
]

tool = XlsxTool(files=files)
stats = tool.execute(get_stats=True)

# Output includes statistics for both files
```

Output:

```markdown
# Excel File Statistics: file1.xlsx
- **Total Sheets:** 2
...

# Excel File Statistics: file2.xlsx
- **Total Sheets:** 3
...
```

## Advanced: Programmatic Access

While the tool returns markdown, you can use `XlsxProcessor` for programmatic access:

```python
from codemie_tools.file_analysis.xlsx.processor import XlsxProcessor

processor = XlsxProcessor()
with open("data.xlsx", "rb") as f:
    sheets = processor.load(f.read())

# Direct access to DataFrames
for sheet_name, df in sheets.items():
    print(f"\nSheet: {sheet_name}")
    print(f"Columns: {list(df.columns)}")
    print(f"Dtypes:\n{df.dtypes}")
    print(f"Shape: {df.shape}")
    print(f"Sample:\n{df.head()}")

    # Detailed statistics
    print(f"\nDescriptive Stats:\n{df.describe()}")

    # Column-wise info
    for col in df.columns:
        print(f"\n{col}:")
        print(f"  Unique values: {df[col].nunique()}")
        print(f"  Sample: {df[col].unique()[:5]}")
```

## Performance Considerations

### Large Files

Statistics generation is fast even for large files because:

1. Data is cleaned before analysis (removes empty rows/columns)
2. Only unique values are collected (limited to 5 per column)
3. Sample values are truncated

```python
# Safe to use on large files
stats = tool.execute(get_stats=True)
```

### Memory Usage

Getting statistics loads all sheets into memory. For extremely large files:

```python
# Option 1: Get stats for specific sheets
# (Currently not supported directly, use XlsxProcessor)

processor = XlsxProcessor(sheet_names=["Sheet1"])
with open("huge_file.xlsx", "rb") as f:
    sheets = processor.load(f.read())
    # Analyze sheets["Sheet1"] manually

# Option 2: Process sheets individually
sheet_names = tool.execute(get_sheet_names=True)
# Then process each sheet separately
```

## Common Patterns

### Pattern 1: Stats-Driven Processing

```python
# Always get statistics first
stats = tool.execute(get_stats=True)
print(stats)

# Review the output, then process
result = tool.execute(
    sheet_names=["Identified Sheet"],
    filter_value="Found in samples"
)
```

### Pattern 2: Validation Workflow

```python
# Get statistics
stats = tool.execute(get_stats=True)

# Validate (pseudo-code)
if validate_structure(stats):
    result = tool.execute(sheet_names=["Data"])
    process(result)
else:
    print("File structure doesn't match expectations")
```

### Pattern 3: Multi-File Comparison

```python
files = [FileObject.from_path(f) for f in file_list]

for file_obj in files:
    tool = XlsxTool(files=[file_obj])
    stats = tool.execute(get_stats=True)

    # Compare statistics across files
    # Verify all files have same structure
    # Identify anomalies
```

## Troubleshooting

### Missing Columns

If expected columns don't appear in statistics:

1. **Check sheet names**:
   ```python
   sheets = tool.execute(get_sheet_names=True)
   # Are you looking at the right sheet?
   ```

2. **Check for hidden sheets**:
   ```python
   stats = tool.execute(get_stats=True, visible_only=False)
   ```

3. **Check the actual file**: Open in Excel and verify columns exist

### Wrong Data Types

If data types seem incorrect:

- Excel stores all data as it appears
- "100" (text) vs 100 (number) are different
- Dates may be stored as text if not formatted correctly in Excel
- Mixed data types in a column default to string

### Empty Sample Values

If sample values are empty:

- The column might contain only empty cells
- Data might be in a different sheet
- Sheet might have complex formatting (merged cells, etc.)

## Best Practices

1. **Always get statistics for unfamiliar files**:
   ```python
   stats = tool.execute(get_stats=True)
   ```

2. **Use statistics to inform processing**:
   ```python
   # Read stats, then decide what to extract
   ```

3. **Check both visible and hidden sheets when needed**:
   ```python
   stats_all = tool.execute(get_stats=True, visible_only=False)
   ```

4. **Combine with sheet names for complete picture**:
   ```python
   sheets = tool.execute(get_sheet_names=True)
   stats = tool.execute(get_stats=True)
   ```

## Next Steps

- [Usage Guide](usage-guide.md): General usage patterns
- [Filtering Guide](filtering.md): Using sample values to create filters
- [Examples](examples.md): Practical examples using statistics
- [API Reference](api-reference.md): Complete API documentation
