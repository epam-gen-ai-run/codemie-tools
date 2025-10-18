# CSV Tool - Overview

The CSV Tool provides powerful capabilities for working with CSV (Comma-Separated Values) files using pandas DataFrame operations.

## Features

- **Pandas Integration**: Leverage full pandas DataFrame API
- **Automatic Delimiter Detection**: Smart CSV parsing with `clevercsv`
- **Column Operations**: Perform operations on specific columns
- **Data Analysis**: Statistical analysis, filtering, grouping
- **Multi-File Support**: Process multiple CSV files simultaneously
- **Flexible Method Calling**: Call any pandas DataFrame method

## Quick Start

```python
from codemie_tools.file_analysis.csv_tool import CSVTool
from codemie_tools.base.file_object import FileObject

# Create file object
file_obj = FileObject.from_path("data.csv")

# Initialize tool
csv_tool = CSVTool(files=[file_obj])

# Get basic info
info = csv_tool.execute(method_name="info")

# Get descriptive statistics
stats = csv_tool.execute(method_name="describe")

# Get column names
columns = csv_tool.execute(method_name="columns")
```

## Core Concepts

### Method-Based API

The CSV Tool uses a method-based API that mirrors pandas DataFrame methods:

```python
# Execute any pandas DataFrame method
result = csv_tool.execute(
    method_name="head",      # Method to call
    method_args={"n": 10}    # Arguments for the method
)
```

### Column Operations

Perform operations on specific columns:

```python
# Get mean of a column
mean = csv_tool.execute(
    method_name="mean",
    column="price"
)

# Get unique values in a column
unique = csv_tool.execute(
    method_name="unique",
    column="category"
)
```

## Common Operations

### Data Inspection

```python
# View first rows
head = csv_tool.execute(method_name="head", method_args={"n": 5})

# Get shape
shape = csv_tool.execute(method_name="shape")

# Get column types
dtypes = csv_tool.execute(method_name="dtypes")
```

### Statistical Analysis

```python
# Descriptive statistics
stats = csv_tool.execute(method_name="describe")

# Mean of specific column
mean = csv_tool.execute(method_name="mean", column="revenue")

# Count values
count = csv_tool.execute(method_name="value_counts", column="status")
```

### Data Filtering

```python
# Filter by condition (using query method)
filtered = csv_tool.execute(
    method_name="query",
    method_args={"expr": "price > 100"}
)
```

### Aggregation

```python
# Group by and aggregate
grouped = csv_tool.execute(
    method_name="groupby",
    method_args={"by": "category"}
)
```

## Use Cases

### Data Analysis
Analyze sales data, user metrics, or any tabular data.

```python
csv_tool = CSVTool(files=[FileObject.from_path("sales.csv")])

# Get total sales
total = csv_tool.execute(method_name="sum", column="amount")

# Get average by category
avg = csv_tool.execute(
    method_name="groupby",
    method_args={"by": "category"}
)
```

### Data Validation
Check data quality and consistency.

```python
# Check for missing values
nulls = csv_tool.execute(method_name="isnull")

# Get unique values in a column
unique = csv_tool.execute(method_name="nunique", column="product_id")
```

### Multi-File Processing
Process multiple CSV files at once.

```python
files = [
    FileObject.from_path("january.csv"),
    FileObject.from_path("february.csv"),
    FileObject.from_path("march.csv")
]

csv_tool = CSVTool(files=files)
results = csv_tool.execute(method_name="describe")
```

## LangChain Integration

```python
from langchain.agents import create_openai_functions_agent, AgentExecutor
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4")
csv_tool = CSVTool(files=[file_obj])

prompt = ChatPromptTemplate.from_messages([
    ("system", "You analyze CSV data using pandas operations."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(llm=llm, tools=[csv_tool], prompt=prompt)
executor = AgentExecutor(agent=agent, tools=[csv_tool])

result = executor.invoke({
    "input": "What is the average price by category?"
})
```

## Performance Tips

1. **Use efficient methods**: Prefer vectorized pandas operations
2. **Column-specific operations**: Operate on specific columns when possible
3. **Batch processing**: Process multiple files together
4. **Memory management**: Be aware of file sizes

## Error Handling

```python
try:
    result = csv_tool.execute(method_name="mean", column="nonexistent")
except Exception as e:
    print(f"Error: {e}")
```

## See Also

- [API Reference](api-reference.md)
- [Examples](examples.md)
- [Pandas Documentation](https://pandas.pydata.org/docs/)
