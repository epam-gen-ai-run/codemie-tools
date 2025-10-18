# CSV Tool - API Reference

Complete API reference for the CSV Tool.

## CSVTool

Main tool class for processing CSV files using pandas operations.

::: codemie_tools.file_analysis.csv_tool.CSVTool
    options:
      show_root_heading: true
      show_source: false
      heading_level: 3
      members:
        - execute
        - _process_single_csv

---

## Input

Input schema for CSV Tool operations.

::: codemie_tools.file_analysis.csv_tool.Input
    options:
      show_root_heading: true
      show_source: false
      heading_level: 3

**Fields**:

- `method_name` (str): Name of pandas DataFrame method to call
- `method_args` (dict): Arguments to pass to the method (default: {})
- `column` (str | None): Specific column to operate on (default: None)

---

## Helper Functions

### get_csv_delimiter()

```python
def get_csv_delimiter(data: str, length_to_sniff: int) -> str
```

Automatically detect CSV delimiter using `clevercsv`.

**Parameters**:
- `data`: CSV content as string
- `length_to_sniff`: Number of characters to analyze for delimiter detection

**Returns**: Detected delimiter character

---

## Usage Examples

### Basic Operations

```python
from codemie_tools.file_analysis.csv_tool import CSVTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("data.csv")
csv_tool = CSVTool(files=[file_obj])

# Get first 10 rows
head = csv_tool.execute(method_name="head", method_args={"n": 10})

# Get column names
columns = csv_tool.execute(method_name="columns")

# Get shape (rows, columns)
shape = csv_tool.execute(method_name="shape")

# Get data types
dtypes = csv_tool.execute(method_name="dtypes")

# Get info
info = csv_tool.execute(method_name="info")
```

### Statistical Operations

```python
# Descriptive statistics for all columns
stats = csv_tool.execute(method_name="describe")

# Mean of specific column
mean = csv_tool.execute(method_name="mean", column="price")

# Sum of specific column
total = csv_tool.execute(method_name="sum", column="quantity")

# Count non-null values
count = csv_tool.execute(method_name="count")

# Standard deviation
std = csv_tool.execute(method_name="std", column="revenue")
```

### Data Filtering

```python
# Query with condition
filtered = csv_tool.execute(
    method_name="query",
    method_args={"expr": "price > 100 and category == 'Electronics'"}
)

# Get unique values in column
unique = csv_tool.execute(method_name="unique", column="category")

# Value counts for column
counts = csv_tool.execute(method_name="value_counts", column="status")

# Check for nulls
nulls = csv_tool.execute(method_name="isnull")
```

### Aggregation Operations

```python
# Group by single column
grouped = csv_tool.execute(
    method_name="groupby",
    method_args={"by": "category"}
)

# Group by multiple columns
grouped = csv_tool.execute(
    method_name="groupby",
    method_args={"by": ["category", "region"]}
)
```

### Column Operations

```python
# Get minimum value in column
min_val = csv_tool.execute(method_name="min", column="price")

# Get maximum value in column
max_val = csv_tool.execute(method_name="max", column="price")

# Get median
median = csv_tool.execute(method_name="median", column="age")

# Count unique values
nunique = csv_tool.execute(method_name="nunique", column="user_id")
```

### Advanced Operations

```python
# Sort values
sorted_df = csv_tool.execute(
    method_name="sort_values",
    method_args={"by": "price", "ascending": False}
)

# Drop duplicates
unique_rows = csv_tool.execute(method_name="drop_duplicates")

# Sample rows
sample = csv_tool.execute(
    method_name="sample",
    method_args={"n": 100}
)
```

### Multi-File Processing

```python
files = [
    FileObject.from_path("q1.csv"),
    FileObject.from_path("q2.csv"),
    FileObject.from_path("q3.csv")
]

csv_tool = CSVTool(files=files)

# Operations are performed on each file
results = csv_tool.execute(method_name="describe")
```

---

## Supported Pandas Methods

The CSV Tool supports all pandas DataFrame and Series methods, including:

### DataFrame Methods
- `head()`, `tail()`, `info()`, `describe()`
- `shape`, `columns`, `dtypes`, `index`
- `sum()`, `mean()`, `median()`, `std()`, `var()`
- `min()`, `max()`, `count()`, `nunique()`
- `isnull()`, `notnull()`, `isna()`, `notna()`
- `drop_duplicates()`, `sort_values()`, `sample()`
- `groupby()`, `pivot_table()`, `merge()`
- `query()`, `filter()`, `select_dtypes()`

### Series Methods (when column specified)
- `mean()`, `sum()`, `min()`, `max()`
- `unique()`, `value_counts()`, `nunique()`
- `std()`, `var()`, `median()`, `mode()`
- `describe()`, `count()`

---

## Error Handling

```python
try:
    result = csv_tool.execute(method_name="mean", column="invalid_column")
except Exception as e:
    print(f"Error: {e}")
    # Returns: "Error: Column 'invalid_column' not found in file data.csv"
```

**Common Errors**:

- Column not found: Returns error message with file name
- Invalid method: AttributeError if method doesn't exist
- Invalid arguments: TypeError if arguments are incorrect
- Processing error: Returns error message with details

---

## See Also

- [Overview](overview.md)
- [Examples](examples.md)
- [Pandas Documentation](https://pandas.pydata.org/docs/)
