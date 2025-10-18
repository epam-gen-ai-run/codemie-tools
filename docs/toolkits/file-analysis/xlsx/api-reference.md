# XLSX Tool - API Reference

Complete API reference for the XLSX tool and processor.

## XlsxTool

Main tool class for working with Excel files in CodeMie Tools.

::: codemie_tools.file_analysis.xslx_tool.XlsxTool
    options:
      show_root_heading: true
      show_source: false
      heading_level: 3
      members:
        - execute
        - _load_excel_file
        - _get_file_stats
        - _get_sheet_names

---

## XslxToolInput

Input schema for XlsxTool operations.

::: codemie_tools.file_analysis.xslx_tool.XslxToolInput
    options:
      show_root_heading: true
      show_source: false
      heading_level: 3
      members:
        - query
        - sheet_names
        - sheet_index
        - get_sheet_names
        - get_stats
        - visible_only
        - filter_value
        - filter_mode

---

## XlsxProcessor

Low-level processor for Excel file operations.

```python
class XlsxProcessor:
    """
    Processes XLSX files by loading them into pandas DataFrames and converting to various formats.
    """
```

### Constructor

Initialize the XLSX processor with filtering and visibility options.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `sheet_names` | `List[str] \| None` | `None` | Specific sheets to load |
| `visible_only` | `bool` | `True` | Load only visible sheets |
| `filter_value` | `str \| None` | `None` | Value to filter rows by |
| `filter_mode` | `str` | `"exact"` | Filter mode: "exact" or "contains" |

**Example:**

```python
from codemie_tools.file_analysis.xlsx.processor import XlsxProcessor

# Create processor with filtering
processor = XlsxProcessor(
    sheet_names=["Sheet1"],
    filter_value="Active",
    filter_mode="contains"
)
```

### load()

Load Excel file and return dictionary of DataFrames.

**Signature:**

```python
def load(
    self,
    file_content: bytes | BinaryIO,
    clean_data: bool = True
) -> Dict[str, pd.DataFrame]
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `file_content` | `bytes \| BinaryIO` | Required | Excel file content |
| `clean_data` | `bool` | `True` | Remove empty rows/columns |

**Returns:**

`Dict[str, pd.DataFrame]`: Dictionary mapping sheet names to DataFrames

**Example:**

```python
# Load file with cleaning
with open("data.xlsx", "rb") as f:
    sheets = processor.load(f.read(), clean_data=True)

# Access DataFrames
df = sheets["Sheet1"]
print(df.head())
```

### convert()

Convert DataFrames to markdown format.

**Signature:**

```python
def convert(
    self,
    sheets: Dict[str, pd.DataFrame],
    **kwargs: Any
) -> str
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `sheets` | `Dict[str, pd.DataFrame]` | Dictionary of DataFrames to convert |
| `**kwargs` | `Any` | Additional options for HTML converter |

**Returns:**

`str`: Markdown representation of the sheets

**Example:**

```python
# Load and convert
sheets = processor.load(file_content)
markdown = processor.convert(sheets)
print(markdown)
```

---

## Helper Functions

Utility functions for DataFrame processing.

### _normalize_column_names()

Normalize column names by renaming 'Unnamed: X' columns to 'ColX'.

**Signature:**

```python
def _normalize_column_names(df: pd.DataFrame) -> pd.DataFrame
```

**Example:**

```python
import pandas as pd
from codemie_tools.file_analysis.xlsx.processor import _normalize_column_names

df = pd.DataFrame({"A": [1, 2], "Unnamed: 1": [3, 4]})
df_normalized = _normalize_column_names(df)
# Columns: ["A", "Col1"]
```

---

### _clean_dataframe()

Remove empty rows and columns from DataFrame.

**Signature:**

```python
def _clean_dataframe(df: pd.DataFrame) -> pd.DataFrame
```

**Example:**

```python
from codemie_tools.file_analysis.xlsx.processor import _clean_dataframe

# DataFrame with empty rows/columns
df = pd.DataFrame({
    "A": [1, 2, None, None],
    "B": [3, 4, None, None],
    "Empty": [None, None, None, None]
})

df_clean = _clean_dataframe(df)
# Result: 2 rows, 2 columns (Empty column removed)
```

---

### _get_visible_sheets()

Get list of visible sheet names from an Excel file.

**Signature:**

```python
def _get_visible_sheets(binary_content: BinaryIO) -> Optional[List[str]]
```

**Example:**

```python
import io
from codemie_tools.file_analysis.xlsx.processor import _get_visible_sheets

with open("data.xlsx", "rb") as f:
    binary_content = io.BytesIO(f.read())
    visible_sheets = _get_visible_sheets(binary_content)
    print(f"Visible sheets: {visible_sheets}")
```

---

### _filter_dataframe()

Filter DataFrame rows by checking if any cell matches the filter value.

**Signature:**

```python
def _filter_dataframe(
    df: pd.DataFrame,
    filter_value: Optional[str] = None,
    filter_mode: str = "exact"
) -> pd.DataFrame
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `df` | `pd.DataFrame` | Required | DataFrame to filter |
| `filter_value` | `str \| None` | `None` | Value to search for |
| `filter_mode` | `str` | `"exact"` | "exact" or "contains" |

**Example:**

```python
import pandas as pd
from codemie_tools.file_analysis.xlsx.processor import _filter_dataframe

df = pd.DataFrame({
    "Status": ["Active", "Inactive", "Active"],
    "Value": [100, 200, 300]
})

# Exact match
filtered = _filter_dataframe(df, filter_value="Active", filter_mode="exact")
# Result: 2 rows with "Active" status

# Contains match
filtered = _filter_dataframe(df, filter_value="act", filter_mode="contains")
# Result: 3 rows (case-insensitive substring match)
```

---

### _replace_nan_with_empty()

Replace NaN values with empty strings in the DataFrame.

**Signature:**

```python
def _replace_nan_with_empty(df: pd.DataFrame) -> pd.DataFrame
```

---

## Complete Usage Example

Here's a comprehensive example showing how to use the XLSX tool:

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# Create file object
file_obj = FileObject.from_path("sales_data.xlsx")

# Initialize tool
tool = XlsxTool(files=[file_obj])

# Example 1: Get sheet names
sheet_names = tool.execute(get_sheet_names=True)
print(f"Available sheets: {sheet_names}")

# Example 2: Get file statistics
stats = tool.execute(get_stats=True)
print(f"File statistics: {stats}")

# Example 3: Process specific sheet
data = tool.execute(sheet_index=0, visible_only=True)
print(data)

# Example 4: Process with filtering
filtered_data = tool.execute(
    sheet_names=["Sales"],
    filter_value="Approved",
    filter_mode="exact"
)
print(filtered_data)

# Example 5: Process with contains filter
partial_match = tool.execute(
    sheet_names=["Sales"],
    filter_value="pend",
    filter_mode="contains"
)
# Will match "Pending", "pending", "Suspended", etc.
print(partial_match)
```

---

## LangChain Integration

Using XlsxTool with LangChain agents:

```python
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# Setup
llm = ChatOpenAI(model="gpt-4", temperature=0)
file_obj = FileObject.from_path("quarterly_report.xlsx")
xlsx_tool = XlsxTool(files=[file_obj])

# Create agent
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a data analyst assistant. Use the XLSX tool to analyze spreadsheets."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(llm=llm, tools=[xlsx_tool], prompt=prompt)
executor = AgentExecutor(agent=agent, tools=[xlsx_tool], verbose=True)

# Execute
result = executor.invoke({
    "input": "Analyze the Q4 sales data and show me all rows where status is 'Completed'"
})
print(result["output"])
```

---

## Advanced Usage with XlsxProcessor

For more control over the processing pipeline:

```python
from codemie_tools.file_analysis.xlsx.processor import XlsxProcessor
import pandas as pd

# Create processor with custom settings
processor = XlsxProcessor(
    sheet_names=["Sales", "Revenue"],
    visible_only=True,
    filter_value="Q1",
    filter_mode="contains"
)

# Load file
with open("financial_data.xlsx", "rb") as f:
    sheets = processor.load(f.read(), clean_data=True)

# Process each sheet
for sheet_name, df in sheets.items():
    print(f"\n=== {sheet_name} ===")
    print(f"Rows: {len(df)}, Columns: {len(df.columns)}")
    print(df.head())

    # Custom processing
    if "Amount" in df.columns:
        total = df["Amount"].sum()
        print(f"Total Amount: ${total:,.2f}")

# Convert to markdown
markdown = processor.convert(sheets)
print(markdown)
```

---

## Error Handling

All methods raise `ToolException` on errors:

```python
from langchain_core.tools import ToolException

try:
    result = tool.execute(sheet_index=0)
except ToolException as e:
    print(f"Tool error: {e}")
except ValueError as e:
    print(f"Value error: {e}")
```

**Common error scenarios:**

- **No files provided**: `ValueError` when XlsxTool has empty files list
- **Invalid sheet index**: Returns error message string
- **File not found**: Returns error message string
- **Corrupt Excel file**: Raises exception with details
- **Invalid filter mode**: Silently falls back to exact match

---

## Performance Considerations

### Memory Usage

- **Large files**: Consider processing sheets individually
- **Use `clean_data=True`**: Reduces memory footprint by removing empty rows/columns
- **Filter early**: Apply filters at load time to minimize DataFrame size
- **Specify sheets**: Load only needed sheets with `sheet_names` parameter

### Processing Speed

```python
# ✅ Fast: Load specific sheets with filtering
processor = XlsxProcessor(
    sheet_names=["Summary"],
    filter_value="2024",
    filter_mode="contains"
)

# ❌ Slower: Load all sheets without filtering
processor = XlsxProcessor()
```

### Optimization Tips

1. **Specify sheets**: Load only needed sheets
2. **Use filtering**: Filter at load time, not after
3. **Disable cleaning**: Set `clean_data=False` if data is already clean
4. **Visible sheets only**: Set `visible_only=True` to skip hidden sheets
5. **Stream large files**: Use `XlsxProcessor` directly for more control

---

## Type Definitions

### Filter Mode

```python
FilterMode = Literal["exact", "contains"]
```

- `"exact"`: Exact case-insensitive match
- `"contains"`: Substring case-insensitive match

### Sheet Data Structure

```python
SheetsDict = Dict[str, pd.DataFrame]
```

Dictionary mapping sheet names to pandas DataFrames.

---

## See Also

- [Usage Guide](usage-guide.md): Detailed usage patterns and examples
- [Filtering Guide](filtering.md): Advanced filtering techniques
- [Statistics Guide](statistics.md): Understanding statistics output
- [Examples](examples.md): Practical code examples
- [Overview](overview.md): High-level tool overview
