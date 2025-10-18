# CSV Tool - Examples

## Basic Examples

### Inspect Data

```python
from codemie_tools.file_analysis.csv_tool import CSVTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("sales.csv")
csv_tool = CSVTool(files=[file_obj])

# View first rows
head = csv_tool.execute(method_name="head", method_args={"n": 10})
print(head)

# Get shape
shape = csv_tool.execute(method_name="shape")
print(f"Rows: {shape[0]}, Columns: {shape[1]}")

# Get column info
columns = csv_tool.execute(method_name="columns")
print(f"Columns: {columns}")
```

### Statistical Analysis

```python
# Get summary statistics
stats = csv_tool.execute(method_name="describe")
print(stats)

# Calculate means
mean_price = csv_tool.execute(method_name="mean", column="price")
print(f"Average price: ${mean_price}")

# Get totals
total_revenue = csv_tool.execute(method_name="sum", column="revenue")
print(f"Total revenue: ${total_revenue}")
```

### Data Quality Check

```python
# Check for missing values
nulls = csv_tool.execute(method_name="isnull")

# Count unique values
unique_customers = csv_tool.execute(method_name="nunique", column="customer_id")
print(f"Unique customers: {unique_customers}")

# Value distribution
status_counts = csv_tool.execute(method_name="value_counts", column="status")
print(status_counts)
```

## Advanced Examples

### Filtering Data

```python
# Query with complex conditions
high_value = csv_tool.execute(
    method_name="query",
    method_args={"expr": "revenue > 1000 and status == 'completed'"}
)
```

### Aggregation

```python
# Group by category
grouped = csv_tool.execute(
    method_name="groupby",
    method_args={"by": "category"}
)
```

### Sorting

```python
# Sort by price (descending)
sorted_data = csv_tool.execute(
    method_name="sort_values",
    method_args={"by": "price", "ascending": False}
)
```

### Multi-File Analysis

```python
# Process quarterly reports
files = [
    FileObject.from_path("q1_sales.csv"),
    FileObject.from_path("q2_sales.csv"),
    FileObject.from_path("q3_sales.csv"),
    FileObject.from_path("q4_sales.csv")
]

csv_tool = CSVTool(files=files)

# Get statistics for each quarter
quarterly_stats = csv_tool.execute(method_name="describe")
print(quarterly_stats)
```

## LangChain Integration

### With OpenAI Agent

```python
from langchain.agents import create_openai_functions_agent, AgentExecutor
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4")
csv_tool = CSVTool(files=[file_obj])

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a data analyst. Use CSV operations to analyze data."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(llm=llm, tools=[csv_tool], prompt=prompt)
executor = AgentExecutor(agent=agent, tools=[csv_tool], verbose=True)

# Ask natural language questions
result = executor.invoke({
    "input": "What is the total revenue by category?"
})
print(result["output"])

result = executor.invoke({
    "input": "Show me the top 10 customers by purchase amount"
})
print(result["output"])
```

## Real-World Scenarios

### Sales Analysis

```python
file_obj = FileObject.from_path("annual_sales.csv")
csv_tool = CSVTool(files=[file_obj])

# Total sales
total = csv_tool.execute(method_name="sum", column="amount")
print(f"Total Sales: ${total:,.2f}")

# Average order value
avg = csv_tool.execute(method_name="mean", column="amount")
print(f"Average Order: ${avg:.2f}")

# Top products
top_products = csv_tool.execute(
    method_name="value_counts",
    column="product_name"
)
print("Top Products:")
print(top_products)
```

### Customer Analytics

```python
# Unique customers
unique = csv_tool.execute(method_name="nunique", column="customer_id")
print(f"Total Customers: {unique}")

# Customer segments
segments = csv_tool.execute(
    method_name="value_counts",
    column="segment"
)
print("Customer Segments:")
print(segments)
```

### Time Series Analysis

```python
# Sort by date
sorted_data = csv_tool.execute(
    method_name="sort_values",
    method_args={"by": "date"}
)

# Get date range
min_date = csv_tool.execute(method_name="min", column="date")
max_date = csv_tool.execute(method_name="max", column="date")
print(f"Data range: {min_date} to {max_date}")
```

## Tips and Tricks

### Efficient Column Operations

```python
# Instead of processing entire dataframe, focus on specific columns
result = csv_tool.execute(method_name="mean", column="price")
```

### Combining Operations

```python
# Use pandas query for complex filtering
result = csv_tool.execute(
    method_name="query",
    method_args={
        "expr": "price > 100 and quantity > 5 and category == 'Electronics'"
    }
)
```

### Error Handling

```python
try:
    result = csv_tool.execute(method_name="mean", column="price")
    print(f"Average price: ${result:.2f}")
except Exception as e:
    print(f"Error calculating mean: {e}")
```

## See Also

- [Overview](overview.md)
- [API Reference](api-reference.md)
- [Pandas Documentation](https://pandas.pydata.org/docs/)
