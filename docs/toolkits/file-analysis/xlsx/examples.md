# XLSX Tool - Examples

Practical examples demonstrating common use cases and patterns.

## Table of Contents

- [Basic Operations](#basic-operations)
- [Data Analysis](#data-analysis)
- [LangChain Integration](#langchain-integration)
- [Advanced Use Cases](#advanced-use-cases)
- [Real-World Scenarios](#real-world-scenarios)

## Basic Operations

### Example 1: List All Sheets

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# Load file
file_obj = FileObject.from_path("quarterly_report.xlsx")
tool = XlsxTool(files=[file_obj])

# Get all sheet names
sheets = tool.execute(get_sheet_names=True)
print(sheets)
```

**Output:**
```markdown
## Sheets in quarterly_report.xlsx:
- Summary
- Q1 Sales
- Q2 Sales
- Q3 Sales
- Q4 Sales
- Yearly Trends
```

### Example 2: Get File Statistics

```python
# Get comprehensive file statistics
stats = tool.execute(get_stats=True)
print(stats)
```

**Output:**
```markdown
# Excel File Statistics: quarterly_report.xlsx
- **Total Sheets:** 6

## Sheet: Summary
### Columns:
| Column | Data Type | Sample Values |
| ------ | --------- | ------------- |
| Quarter | string | `Q1`, `Q2`, `Q3`, `Q4` |
| Revenue | float | `125000.50`, `145000.75`, `135000.00` |
| Units Sold | integer | `1200`, `1450`, `1350` |
...
```

### Example 3: Process Single Sheet

```python
# Process just the summary sheet
summary = tool.execute(sheet_names=["Summary"])
print(summary)
```

### Example 4: Process by Index

```python
# Process first sheet (index 0)
first_sheet = tool.execute(sheet_index=0)
print(first_sheet)

# Process last quarter (index 4, assuming it's Q4 Sales)
q4 = tool.execute(sheet_index=4)
print(q4)
```

## Data Analysis

### Example 5: Filter by Status

```python
file_obj = FileObject.from_path("orders.xlsx")
tool = XlsxTool(files=[file_obj])

# Get only completed orders
completed = tool.execute(
    filter_value="Completed",
    filter_mode="exact"
)

# Get orders that mention "Pending"
pending = tool.execute(
    filter_value="Pending",
    filter_mode="contains"
)

print("Completed Orders:", completed)
print("Pending Orders:", pending)
```

### Example 6: Extract Quarter Data

```python
file_obj = FileObject.from_path("annual_sales.xlsx")
tool = XlsxTool(files=[file_obj])

# Extract all Q1 data
q1_data = tool.execute(
    filter_value="Q1",
    filter_mode="contains"
)

# Extract specific month
january_data = tool.execute(
    filter_value="2024-01",
    filter_mode="contains"
)

print("Q1 Data:", q1_data)
print("January Data:", january_data)
```

### Example 7: Find Records by Person

```python
file_obj = FileObject.from_path("employee_records.xlsx")
tool = XlsxTool(files=[file_obj])

# Find all records mentioning Alice
alice_records = tool.execute(
    filter_value="Alice Johnson",
    filter_mode="contains"
)

# Find specific employee ID
emp_records = tool.execute(
    filter_value="EMP-12345",
    filter_mode="exact"
)

print("Alice's Records:", alice_records)
print("Employee Records:", emp_records)
```

### Example 8: Product Analysis

```python
file_obj = FileObject.from_path("inventory.xlsx")
tool = XlsxTool(files=[file_obj])

# Find all electronics
electronics = tool.execute(
    sheet_names=["Products"],
    filter_value="Electronics",
    filter_mode="contains"
)

# Find specific product
laptop = tool.execute(
    sheet_names=["Products"],
    filter_value="Laptop",
    filter_mode="contains"
)

print("Electronics:", electronics)
print("Laptops:", laptop)
```

## LangChain Integration

### Example 9: Basic Agent

```python
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# Set up LLM
llm = ChatOpenAI(model="gpt-4", temperature=0)

# Load Excel file
file_obj = FileObject.from_path("sales_data.xlsx")
xlsx_tool = XlsxTool(files=[file_obj])

# Create prompt
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a data analyst assistant. Analyze Excel files and provide insights."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

# Create agent
agent = create_openai_functions_agent(
    llm=llm,
    tools=[xlsx_tool],
    prompt=prompt
)

# Execute
agent_executor = AgentExecutor(
    agent=agent,
    tools=[xlsx_tool],
    verbose=True
)

result = agent_executor.invoke({
    "input": "What sheets are in this file? Then show me statistics for all sheets."
})

print(result["output"])
```

### Example 10: Multi-Step Analysis

```python
# Agent performs multi-step analysis
result = agent_executor.invoke({
    "input": """
    Please analyze this sales data:
    1. First, tell me what sheets are available
    2. Get statistics for the Sales sheet
    3. Find all records from Q1 2024
    4. Summarize the key metrics
    """
})

print(result["output"])
```

### Example 11: Comparative Analysis

```python
# Analyze multiple files
files = [
    FileObject.from_path("sales_2023.xlsx"),
    FileObject.from_path("sales_2024.xlsx"),
]

for file_obj in files:
    tool = XlsxTool(files=[file_obj])

    # Create agent for this file
    agent = create_openai_functions_agent(llm=llm, tools=[tool], prompt=prompt)
    executor = AgentExecutor(agent=agent, tools=[tool])

    result = executor.invoke({
        "input": "Summarize the total sales and top products from this file."
    })

    print(f"\n{file_obj.name}:")
    print(result["output"])
```

## Advanced Use Cases

### Example 12: Using XlsxProcessor Directly

```python
from codemie_tools.file_analysis.xlsx.processor import XlsxProcessor
import pandas as pd

# Create processor with filtering
processor = XlsxProcessor(
    sheet_names=["Sales"],
    filter_value="Premium",
    filter_mode="exact"
)

# Load and process
with open("data.xlsx", "rb") as f:
    sheets = processor.load(f.read(), clean_data=True)

# Work with pandas DataFrames
sales_df = sheets["Sales"]

# Perform pandas operations
print("Revenue Statistics:")
print(sales_df.describe())

print("\nTop 5 Products:")
# Assuming there's a 'Product' and 'Revenue' column
grouped = sales_df.groupby("Product")["Revenue"].sum().sort_values(ascending=False)
print(grouped.head())

# Convert to markdown
markdown = processor.convert(sheets)
print("\nMarkdown Output:")
print(markdown)
```

### Example 13: Batch Processing

```python
import os
from pathlib import Path

# Process all Excel files in a directory
excel_dir = Path("./reports")
excel_files = list(excel_dir.glob("*.xlsx"))

results = {}

for file_path in excel_files:
    file_obj = FileObject.from_path(str(file_path))
    tool = XlsxTool(files=[file_obj])

    # Extract approved records from each file
    approved = tool.execute(
        filter_value="Approved",
        filter_mode="exact"
    )

    results[file_path.name] = approved
    print(f"Processed {file_path.name}")

# Save results
for filename, content in results.items():
    output_path = f"./processed/{filename}.md"
    with open(output_path, "w") as f:
        f.write(content)
```

### Example 14: Data Validation Pipeline

```python
def validate_excel_structure(file_path: str, expected_sheets: list) -> bool:
    """Validate that an Excel file has expected structure"""
    file_obj = FileObject.from_path(file_path)
    tool = XlsxTool(files=[file_obj])

    # Get sheet names
    sheets_result = tool.execute(get_sheet_names=True)

    # Check if all expected sheets exist
    for expected_sheet in expected_sheets:
        if expected_sheet not in sheets_result:
            print(f"Missing sheet: {expected_sheet}")
            return False

    # Get statistics to validate columns
    stats = tool.execute(get_stats=True)

    # Validate each sheet has expected columns
    # (Add your validation logic here)

    return True

# Use validation
if validate_excel_structure("report.xlsx", ["Sales", "Inventory", "Summary"]):
    # Process the file
    file_obj = FileObject.from_path("report.xlsx")
    tool = XlsxTool(files=[file_obj])
    result = tool.execute(sheet_names=["Sales"])
    print(result)
else:
    print("File structure validation failed")
```

### Example 15: Sequential Filtering

```python
from codemie_tools.file_analysis.xlsx.processor import XlsxProcessor
import pandas as pd

processor = XlsxProcessor()

with open("transactions.xlsx", "rb") as f:
    sheets = processor.load(f.read())

df = sheets["Transactions"]

# Filter 1: 2024 data
df_2024 = df[df.apply(lambda row: "2024" in str(row.values), axis=1)]

# Filter 2: Q1 only
df_q1 = df_2024[df_2024.apply(lambda row: "Q1" in str(row.values), axis=1)]

# Filter 3: High value transactions (>1000)
df_high_value = df_q1[df_q1.apply(
    lambda row: any(isinstance(val, (int, float)) and val > 1000 for val in row.values),
    axis=1
)]

print(f"Total transactions: {len(df)}")
print(f"2024 transactions: {len(df_2024)}")
print(f"Q1 2024 transactions: {len(df_q1)}")
print(f"Q1 2024 high-value transactions: {len(df_high_value)}")

# Convert final result to markdown
final_sheets = {"High Value Q1 Transactions": df_high_value}
markdown = processor.convert(final_sheets)
print("\nFinal Results:")
print(markdown)
```

## Real-World Scenarios

### Example 16: Sales Report Analysis

```python
"""Analyze quarterly sales report and extract key insights"""

file_obj = FileObject.from_path("Q1_2024_Sales.xlsx")
tool = XlsxTool(files=[file_obj])

# Step 1: Understand the structure
print("=== File Structure ===")
sheets = tool.execute(get_sheet_names=True)
print(sheets)

stats = tool.execute(get_stats=True)
print(stats)

# Step 2: Extract regional data
print("\n=== Regional Sales ===")
regions = ["North", "South", "East", "West"]

for region in regions:
    regional_data = tool.execute(
        sheet_names=["Sales Data"],
        filter_value=region,
        filter_mode="exact"
    )
    print(f"\n{region} Region:")
    print(regional_data)

# Step 3: Extract top performers
print("\n=== Top Performers ===")
top_performers = tool.execute(
    sheet_names=["Employee Performance"],
    filter_value="Top Performer",
    filter_mode="exact"
)
print(top_performers)
```

### Example 17: Inventory Management

```python
"""Check inventory levels and identify low-stock items"""

file_obj = FileObject.from_path("inventory.xlsx")
tool = XlsxTool(files=[file_obj])

# Get inventory statistics
stats = tool.execute(get_stats=True)
print("Inventory Statistics:")
print(stats)

# Find low-stock items
low_stock = tool.execute(
    sheet_names=["Current Inventory"],
    filter_value="Low Stock",
    filter_mode="exact"
)
print("\nLow Stock Items:")
print(low_stock)

# Find out-of-stock items
out_of_stock = tool.execute(
    sheet_names=["Current Inventory"],
    filter_value="Out of Stock",
    filter_mode="exact"
)
print("\nOut of Stock Items:")
print(out_of_stock)
```

### Example 18: Customer Data Analysis

```python
"""Analyze customer data and segment customers"""

file_obj = FileObject.from_path("customers.xlsx")
tool = XlsxTool(files=[file_obj])

# Segment customers
segments = ["VIP", "Premium", "Standard"]

customer_segments = {}
for segment in segments:
    data = tool.execute(
        sheet_names=["Customer List"],
        filter_value=segment,
        filter_mode="exact"
    )
    customer_segments[segment] = data

# Save each segment
for segment, data in customer_segments.items():
    with open(f"{segment}_customers.md", "w") as f:
        f.write(data)
    print(f"Saved {segment} customers")
```

### Example 19: Financial Report Processing

```python
"""Process monthly financial reports"""

from datetime import datetime

def process_financial_report(file_path: str, month: str, year: str):
    """Process financial report for a specific month"""
    file_obj = FileObject.from_path(file_path)
    tool = XlsxTool(files=[file_obj])

    # Get structure
    sheets = tool.execute(get_sheet_names=True)
    print(f"Processing {month} {year} Financial Report")
    print(f"Available sheets: {sheets}")

    # Extract income data
    income = tool.execute(
        sheet_names=["Income Statement"],
        filter_value=month,
        filter_mode="contains"
    )

    # Extract expense data
    expenses = tool.execute(
        sheet_names=["Expenses"],
        filter_value=month,
        filter_mode="contains"
    )

    # Save results
    report_date = f"{year}_{month}"
    with open(f"income_{report_date}.md", "w") as f:
        f.write(income)
    with open(f"expenses_{report_date}.md", "w") as f:
        f.write(expenses)

    return income, expenses

# Process multiple months
months = ["January", "February", "March"]
for month in months:
    process_financial_report(
        f"reports/{month}_2024.xlsx",
        month,
        "2024"
    )
```

### Example 20: Data Quality Audit

```python
"""Audit Excel files for data quality issues"""

def audit_excel_file(file_path: str):
    """Perform data quality audit on Excel file"""
    file_obj = FileObject.from_path(file_path)
    tool = XlsxTool(files=[file_obj])

    print(f"Auditing: {file_path}")
    print("=" * 50)

    # Get statistics
    stats = tool.execute(get_stats=True)

    # Check for issues
    issues = []

    # Check 1: Look for error indicators
    for error_indicator in ["#N/A", "#VALUE!", "#REF!", "ERROR"]:
        result = tool.execute(filter_value=error_indicator, filter_mode="contains")
        if result and error_indicator in result:
            issues.append(f"Found {error_indicator} errors")

    # Check 2: Look for missing data indicators
    for missing_indicator in ["N/A", "NULL", "MISSING", "TBD"]:
        result = tool.execute(filter_value=missing_indicator, filter_mode="exact")
        if result and missing_indicator in result:
            issues.append(f"Found {missing_indicator} values")

    # Report
    if issues:
        print("\n⚠️  Issues Found:")
        for issue in issues:
            print(f"  - {issue}")
    else:
        print("\n✅ No data quality issues detected")

    print("\nFile Statistics:")
    print(stats)
    print("=" * 50)

    return len(issues) == 0

# Audit multiple files
files_to_audit = [
    "data/report1.xlsx",
    "data/report2.xlsx",
    "data/report3.xlsx",
]

for file in files_to_audit:
    audit_excel_file(file)
    print("\n")
```

## Tips and Tricks

### Tip 1: Reuse Tool Instances

```python
# Efficient: Reuse tool for multiple operations
file_obj = FileObject.from_path("data.xlsx")
tool = XlsxTool(files=[file_obj])

sheets = tool.execute(get_sheet_names=True)
stats = tool.execute(get_stats=True)
data = tool.execute(sheet_names=["Sheet1"])

# Less efficient: Recreate tool each time
# tool = XlsxTool(files=[file_obj])
# tool = XlsxTool(files=[file_obj])
# tool = XlsxTool(files=[file_obj])
```

### Tip 2: Combine Operations

```python
# Combine sheet selection and filtering
result = tool.execute(
    sheet_names=["Target Sheet"],
    filter_value="Target Value",
    filter_mode="exact"
)
```

### Tip 3: Use Statistics to Guide Processing

```python
# Always start with statistics for unfamiliar files
stats = tool.execute(get_stats=True)
# Review output to understand structure
# Then process accordingly
```

## Next Steps

- [API Reference](api-reference.md): Complete API documentation
- [Usage Guide](usage-guide.md): Detailed usage patterns
- [Filtering Guide](filtering.md): Advanced filtering techniques
- [Statistics Guide](statistics.md): Understanding statistics output
