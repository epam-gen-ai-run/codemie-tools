# XLSX Tool - Usage Guide

This guide covers common usage patterns and best practices for working with the XLSX tool.

## Basic Usage

### Loading an Excel File

The most common way to use the XLSX tool is with the `FileObject` class:

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# From file path
file_obj = FileObject.from_path("data.xlsx")

# From bytes
with open("data.xlsx", "rb") as f:
    file_obj = FileObject.from_bytes(f.read(), name="data.xlsx")

# Initialize tool
tool = XlsxTool(files=[file_obj])
```

### Processing Multiple Files

The tool can process multiple Excel files in one operation:

```python
files = [
    FileObject.from_path("q1_sales.xlsx"),
    FileObject.from_path("q2_sales.xlsx"),
    FileObject.from_path("q3_sales.xlsx"),
]

tool = XlsxTool(files=files)
result = tool.execute(get_stats=True)
```

## Sheet Operations

### Getting Sheet Names

Before processing, you may want to know what sheets are available:

```python
# Get all visible sheet names
sheets = tool.execute(get_sheet_names=True, visible_only=True)
print(sheets)

# Output:
# ## Sheets in data.xlsx:
# - Summary
# - Sales Data
# - Expenses
```

### Including Hidden Sheets

```python
# Get all sheets including hidden ones
all_sheets = tool.execute(get_sheet_names=True, visible_only=False)
```

### Processing Specific Sheets

```python
# Process single sheet
result = tool.execute(sheet_names=["Summary"])

# Process multiple sheets
result = tool.execute(sheet_names=["Summary", "Sales Data"])
```

### Processing by Sheet Index

When you know the sheet position:

```python
# Process first sheet (index 0)
result = tool.execute(sheet_index=0)

# Process second sheet (index 1)
result = tool.execute(sheet_index=1)
```

## Getting Statistics

The statistics feature provides comprehensive metadata about your Excel file:

```python
stats = tool.execute(get_stats=True)
print(stats)
```

**Output Format:**

```markdown
# Excel File Statistics: data.xlsx
- **Total Sheets:** 3

## Sheet: Summary
### Columns:
| Column | Data Type | Sample Values |
| ------ | --------- | ------------- |
| Product | string | `Laptop`, `Mouse`, `Keyboard` |
| Revenue | float | `12500.50`, `45.99`, `89.99` |
| Quantity | integer | `100`, `250`, `75` |

## Sheet: Sales Data
...
```

**Statistics Include:**

- Total number of sheets
- Column names for each sheet
- Data types (integer, float, string, boolean, datetime)
- Sample values from each column (up to 5 unique values)

## Data Filtering

### Exact Match Filtering

Filter rows where any cell exactly matches the specified value:

```python
# Find all rows with "Approved" status
result = tool.execute(
    filter_value="Approved",
    filter_mode="exact"
)
```

This works with any data type and checks all cells in each row.

### Substring Filtering

Filter rows where any cell contains the specified substring:

```python
# Find all rows mentioning "John"
result = tool.execute(
    filter_value="John",
    filter_mode="contains"
)
```

### Combining Filtering with Sheet Selection

```python
# Filter specific sheets
result = tool.execute(
    sheet_names=["Sales Data", "Q1 Report"],
    filter_value="Premium",
    filter_mode="contains"
)
```

### Filtering by Sheet Index

```python
# Filter data in first sheet
result = tool.execute(
    sheet_index=0,
    filter_value="Active",
    filter_mode="exact"
)
```

## Working with Complex Layouts

The XLSX tool handles complex Excel layouts including:

### Pivot Tables

```python
# Pivot tables work seamlessly
result = tool.execute(
    sheet_names=["Pivot Analysis"],
    filter_value="Q1",
    filter_mode="contains"
)
```

### Merged Cells

Merged cells are automatically handled by pandas. The value appears in the top-left cell.

### Multiple Header Rows

```python
# For files with multiple header rows, use statistics first
stats = tool.execute(get_stats=True)
# Then process knowing the structure
result = tool.execute(sheet_names=["Complex Sheet"])
```

## LangChain Integration

### Basic Agent Integration

```python
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4", temperature=0)

file_obj = FileObject.from_path("sales.xlsx")
xlsx_tool = XlsxTool(files=[file_obj])

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a data analyst. Analyze Excel files and provide insights."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(llm=llm, tools=[xlsx_tool], prompt=prompt)
agent_executor = AgentExecutor(agent=agent, tools=[xlsx_tool])

result = agent_executor.invoke({
    "input": "What are the top 5 products by revenue?"
})
```

### Multi-Step Analysis

```python
# The agent can use the tool multiple times
result = agent_executor.invoke({
    "input": """
    1. First, show me what sheets are available
    2. Then get statistics for all sheets
    3. Finally, analyze the Sales Data sheet and summarize key metrics
    """
})
```

### With Vision Model for Charts

```python
from langchain_openai import ChatOpenAI

# Use a vision model to analyze charts in Excel
vision_llm = ChatOpenAI(model="gpt-4-vision-preview", max_tokens=4096)

tool = XlsxTool(
    files=[file_obj],
    chat_model=vision_llm  # Enables chart/image analysis
)
```

## Using XlsxProcessor Directly

For more control, use `XlsxProcessor` directly:

```python
from codemie_tools.file_analysis.xlsx.processor import XlsxProcessor
import pandas as pd

# Create processor with configuration
processor = XlsxProcessor(
    sheet_names=["Sales"],
    visible_only=True,
    filter_value="Active",
    filter_mode="exact"
)

# Load file
with open("data.xlsx", "rb") as f:
    sheets = processor.load(f.read(), clean_data=True)

# Work with pandas DataFrames directly
sales_df = sheets["Sales"]
print(sales_df.describe())
print(sales_df.groupby("Category")["Revenue"].sum())

# Convert to markdown if needed
markdown = processor.convert(sheets)
```

## Performance Optimization

### Loading Large Files

```python
# Option 1: Load specific sheets only
tool = XlsxTool(files=[large_file])
result = tool.execute(sheet_names=["Summary"])  # Fast

# Option 2: Use processor with specific sheets
processor = XlsxProcessor(sheet_names=["Summary"])
sheets = processor.load(file_content)

# Option 3: Process sheets one at a time
for sheet_index in range(5):
    result = tool.execute(sheet_index=sheet_index)
    # Process each sheet individually
```

### Memory Management

```python
# For very large files, disable data cleaning if not needed
processor = XlsxProcessor()
sheets = processor.load(file_content, clean_data=False)

# Process and release memory
for sheet_name, df in sheets.items():
    process_sheet(df)
    del df  # Release memory
```

### Filtering Performance

```python
# Filter at load time (efficient)
processor = XlsxProcessor(filter_value="Active")
sheets = processor.load(file_content)  # Only loads matching rows

# vs. filtering after loading (less efficient)
processor = XlsxProcessor()
sheets = processor.load(file_content)
df = sheets["Data"]
filtered = df[df.apply(lambda row: "Active" in row.values, axis=1)]
```

## Error Handling

### Handling Missing Files

```python
from langchain_core.tools import ToolException

try:
    file_obj = FileObject.from_path("missing.xlsx")
except FileNotFoundError:
    print("File not found")
```

### Handling Invalid Sheets

```python
# Method 1: Check sheets first
sheets = tool.execute(get_sheet_names=True)
if "Sales" in sheets:
    result = tool.execute(sheet_names=["Sales"])

# Method 2: Try-catch
try:
    result = tool.execute(sheet_names=["NonExistent"])
except ToolException as e:
    print(f"Error: {e}")
```

### Handling Corrupt Files

```python
try:
    result = tool.execute(get_stats=True)
except Exception as e:
    print(f"Failed to process Excel file: {e}")
```

## Common Patterns

### Pattern 1: Explore Then Process

```python
# Step 1: Explore structure
sheets = tool.execute(get_sheet_names=True)
stats = tool.execute(get_stats=True)

# Step 2: Process based on structure
result = tool.execute(
    sheet_names=["Sales Data"],
    filter_value="Q1",
    filter_mode="contains"
)
```

### Pattern 2: Batch Processing

```python
# Process multiple files with same logic
files = [FileObject.from_path(f) for f in excel_files]

for file_obj in files:
    tool = XlsxTool(files=[file_obj])
    result = tool.execute(
        filter_value="Approved",
        filter_mode="exact"
    )
    save_results(result)
```

### Pattern 3: Incremental Analysis

```python
# Analyze one sheet at a time
sheet_count = 5
for i in range(sheet_count):
    result = tool.execute(sheet_index=i)
    analyze(result)
```

## Best Practices

### 1. Always Check Sheet Names First

```python
# Good
sheets = tool.execute(get_sheet_names=True)
if "target_sheet" in sheets:
    result = tool.execute(sheet_names=["target_sheet"])

# Avoid
result = tool.execute(sheet_names=["target_sheet"])  # May fail
```

### 2. Use Statistics for Data Understanding

```python
# Get statistics before processing
stats = tool.execute(get_stats=True)
# Now you know column names, types, and sample data
result = tool.execute(sheet_names=["Data"])
```

### 3. Filter Early

```python
# Efficient: Filter during load
result = tool.execute(filter_value="Active", filter_mode="exact")

# Less efficient: Load all then filter programmatically
result = tool.execute()
# Then parse and filter...
```

### 4. Handle Large Files Appropriately

```python
# For large files, process sheet by sheet
file_obj = FileObject.from_path("large_file.xlsx")
tool = XlsxTool(files=[file_obj])

# Get sheet count
sheets = tool.execute(get_sheet_names=True)
sheet_list = parse_sheets(sheets)

# Process one at a time
for idx in range(len(sheet_list)):
    result = tool.execute(sheet_index=idx)
    process(result)
```

### 5. Provide Context with query Parameter

```python
# Good: Provide context
result = tool.execute(
    query="Find all approved invoices from Q1 2024",
    filter_value="Approved",
    filter_mode="exact"
)

# The query helps with logging and debugging
```

## Next Steps

- [Filtering Guide](filtering.md): Deep dive into filtering capabilities
- [Statistics Guide](statistics.md): Understanding statistics output
- [Examples](examples.md): More practical examples
- [API Reference](api-reference.md): Complete API documentation
