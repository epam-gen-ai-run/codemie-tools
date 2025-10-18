# Quick Start

Get up and running with CodeMie Tools in 5 minutes.

## Installation

```bash
pip install codemie-tools
```

## Your First Tool

Let's use the XLSX tool to analyze an Excel file:

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# Load an Excel file
file_obj = FileObject.from_path("data.xlsx")

# Create the tool
tool = XlsxTool(files=[file_obj])

# Get sheet names
sheets = tool.execute(get_sheet_names=True)
print(sheets)

# Get file statistics
stats = tool.execute(get_stats=True)
print(stats)

# Process a specific sheet
result = tool.execute(sheet_names=["Sheet1"])
print(result)
```

That's it! You've just processed an Excel file with CodeMie Tools.

## Using with LangChain

CodeMie Tools integrates seamlessly with LangChain:

```python
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# Set up LLM
llm = ChatOpenAI(model="gpt-4", temperature=0)

# Create tool
file_obj = FileObject.from_path("sales_data.xlsx")
xlsx_tool = XlsxTool(files=[file_obj])

# Create prompt
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful data analyst."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

# Create and run agent
agent = create_openai_functions_agent(llm=llm, tools=[xlsx_tool], prompt=prompt)
executor = AgentExecutor(agent=agent, tools=[xlsx_tool], verbose=True)

result = executor.invoke({
    "input": "Analyze this Excel file and tell me about the sales trends."
})

print(result["output"])
```

## Key Concepts

### FileObject

FileObject is the standard way to provide files to tools:

```python
from codemie_tools.base.file_object import FileObject

# From file path
file_obj = FileObject.from_path("document.xlsx")

# From bytes
with open("document.xlsx", "rb") as f:
    file_obj = FileObject.from_bytes(f.read(), name="document.xlsx")

# From URL (if supported)
file_obj = FileObject.from_url("https://example.com/data.xlsx")
```

### Tools

All tools inherit from `CodeMieTool` and follow the same pattern:

```python
# 1. Import the tool
from codemie_tools.toolkit_name.tool_name import ToolClass

# 2. Create configuration if needed
config = ToolConfig(
    url="https://api.example.com",
    api_token="your_token"
)

# 3. Initialize the tool
tool = ToolClass(config=config)

# 4. Execute the tool
result = tool.execute(**parameters)
```

### Toolkits

Toolkits group related tools together:

```python
from codemie_tools.toolkit_name.toolkit import ToolkitClass

# Get the toolkit
toolkit = ToolkitClass.get_toolkit(config)

# Get all tools in the toolkit
tools = toolkit.get_tools()

# Use individual tools
for tool in tools:
    result = tool.execute(...)
```

## Common Use Cases

### Process PDF Files

```python
from codemie_tools.file_analysis.pdf_tool import PDFTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("document.pdf")
tool = PDFTool(files=[file_obj])

# Extract text
text = tool.execute(pages=[1, 2, 3], query="Text")
print(text)

# Get total pages
pages = tool.execute(pages=[], query="Total_Pages")
print(f"Total pages: {pages}")
```

### Work with Jira

```python
from codemie_tools.core.project_management.jira.tools import GenericJiraIssueTool
from codemie_tools.core.project_management.jira.models import JiraConfig

# Configure
config = JiraConfig(
    url="https://your-domain.atlassian.net",
    token="your_api_token"
)

# Create tool
tool = GenericJiraIssueTool(config=config)

# Get issue
result = tool.execute(
    operation="get",
    resource_id="PROJ-123"
)
print(result)
```

### Query Elasticsearch

```python
from codemie_tools.data_management.elastic.tools import ElasticTool
from codemie_tools.data_management.elastic.models import ElasticConfig

# Configure
config = ElasticConfig(
    hosts=["http://localhost:9200"],
    username="elastic",
    password="your_password"
)

# Create tool
tool = ElasticTool(config=config)

# Search
result = tool.execute(
    operation="search",
    params={
        "index": "my_index",
        "query": {"match_all": {}}
    }
)
print(result)
```

## Best Practices

### 1. Use Configuration Models

Always use Pydantic models for configuration:

```python
from codemie_tools.your_toolkit.models import YourConfig

# Good: Type-safe configuration
config = YourConfig(
    url="https://api.example.com",
    api_token="token"
)

tool = YourTool(config=config)
```

### 2. Handle Errors

Tools raise `ToolException` on errors:

```python
from langchain_core.tools import ToolException

try:
    result = tool.execute(...)
except ToolException as e:
    print(f"Tool error: {e}")
    # Handle the error
```

### 3. Reuse Tool Instances

Create tools once and reuse them:

```python
# Good: Reuse tool
tool = XlsxTool(files=[file_obj])
sheets = tool.execute(get_sheet_names=True)
stats = tool.execute(get_stats=True)
data = tool.execute(sheet_names=["Sheet1"])

# Avoid: Recreating tool
# tool = XlsxTool(files=[file_obj])
# tool = XlsxTool(files=[file_obj])
# tool = XlsxTool(files=[file_obj])
```

### 4. Explore Before Processing

For unfamiliar data sources, explore first:

```python
# 1. See what's available
sheets = tool.execute(get_sheet_names=True)

# 2. Get structure
stats = tool.execute(get_stats=True)

# 3. Then process
result = tool.execute(sheet_names=["Target Sheet"])
```

## Example: Complete Workflow

Here's a complete example combining multiple tools:

```python
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.core.project_management.jira.tools import GenericJiraIssueTool
from codemie_tools.core.project_management.jira.models import JiraConfig
from codemie_tools.base.file_object import FileObject

# Set up LLM
llm = ChatOpenAI(model="gpt-4", temperature=0)

# Set up tools
file_obj = FileObject.from_path("test_results.xlsx")
xlsx_tool = XlsxTool(files=[file_obj])

jira_config = JiraConfig(
    url="https://your-domain.atlassian.net",
    token="your_token"
)
jira_tool = GenericJiraIssueTool(config=jira_config)

# Create agent with multiple tools
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a QA automation assistant."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(
    llm=llm,
    tools=[xlsx_tool, jira_tool],
    prompt=prompt
)

executor = AgentExecutor(
    agent=agent,
    tools=[xlsx_tool, jira_tool],
    verbose=True
)

# Use the agent
result = executor.invoke({
    "input": """
    1. Analyze the test results Excel file
    2. Find any failed tests
    3. For each failed test, create a Jira ticket with details
    """
})

print(result["output"])
```

## What's Next?

Now that you've seen the basics:

- **[Explore Toolkits](../toolkits/overview.md)**: See all available toolkits
- **[Check Examples](../toolkits/file-analysis/xlsx/examples.md)**: See practical examples
- **[Read API Reference](../toolkits/file-analysis/xlsx/api-reference.md)**: Deep dive into APIs

## Getting Help

- **Documentation**: Browse the docs on the left
- **Examples**: Check the Examples section for each toolkit
- **Issues**: [GitHub Issues](https://github.com/epam-gen-ai-run/codemie-tools/issues)
