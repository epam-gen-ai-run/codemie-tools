# Toolkits Overview

CodeMie Tools organizes functionality into specialized toolkits, each containing related tools for specific domains.

## Available Toolkits

### File Analysis Toolkit

Process and analyze various document formats.

- **[XLSX](file-analysis/xlsx/overview.md)**: Excel file processing and analysis
- **[PDF](file-analysis/pdf/overview.md)**: PDF text extraction and processing
- **[DOCX](file-analysis/docx/overview.md)**: Word document processing
- **[PPTX](file-analysis/pptx/overview.md)**: PowerPoint presentation processing
- **[CSV](file-analysis/csv/overview.md)**: CSV data analysis with pandas integration

**Use Cases**: Document parsing, data extraction, content analysis, business intelligence, report generation

**[View Complete Documentation →](file-analysis/index.md)**

## Toolkit Structure

Each toolkit follows a consistent structure:

```
toolkit_name/
├── __init__.py
├── toolkit.py              # Toolkit definition
└── tool_name/
    ├── models.py           # Configuration and input models
    ├── tools.py            # Tool implementation
    ├── tools_vars.py       # Tool metadata
    └── client.py           # API client (if needed)
```

## Using Toolkits

### Method 1: Use Individual Tools

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# Create file object
file_obj = FileObject.from_path("data.xlsx")

# Create tool
tool = XlsxTool(files=[file_obj])

# Use tool
result = tool.execute(get_stats=True)
```

### Method 2: Use Multiple Tools Together

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.file_analysis.pdf_tool import PDFTool
from codemie_tools.base.file_object import FileObject

# Create tools
xlsx_tool = XlsxTool(files=[FileObject.from_path("data.xlsx")])
pdf_tool = PDFTool(files=[FileObject.from_path("report.pdf")])

# Use with LangChain agent
from langchain.agents import create_openai_functions_agent, AgentExecutor
from langchain_openai import ChatOpenAI

agent = create_openai_functions_agent(
    llm=ChatOpenAI(model="gpt-4"),
    tools=[xlsx_tool, pdf_tool],
    prompt=prompt
)

executor = AgentExecutor(agent=agent, tools=[xlsx_tool, pdf_tool])
```

## Common Patterns

### Pattern 1: Single Tool Usage

When you need just one specific tool:

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("data.xlsx")
tool = XlsxTool(files=[file_obj])
result = tool.execute(get_stats=True)
```

### Pattern 2: Multiple File Analysis Tools

Combining different file analysis tools:

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.file_analysis.pdf_tool import PDFTool
from codemie_tools.file_analysis.csv_tool import CSVTool
from codemie_tools.base.file_object import FileObject

# Create tools
xlsx_tool = XlsxTool(files=[FileObject.from_path("data.xlsx")])
pdf_tool = PDFTool(files=[FileObject.from_path("report.pdf")])
csv_tool = CSVTool(files=[FileObject.from_path("sales.csv")])

# Analyze different formats
excel_data = xlsx_tool.execute(sheet_names=["Summary"])
pdf_text = pdf_tool.execute(pages=[1, 2], query="Text")
csv_stats = csv_tool.execute(method_name="describe")
```

### Pattern 3: AI Agent Integration

Let AI agents automatically select and use the right tools:

```python
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

# Create all file analysis tools
xlsx_tool = XlsxTool(files=[FileObject.from_path("data.xlsx")])
pdf_tool = PDFTool(files=[FileObject.from_path("report.pdf")])
docx_tool = DocxTool(files=[FileObject.from_path("proposal.docx")])
csv_tool = CSVTool(files=[FileObject.from_path("sales.csv")])

# Create agent with all tools
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a document analysis assistant."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(
    llm=ChatOpenAI(model="gpt-4"),
    tools=[xlsx_tool, pdf_tool, docx_tool, csv_tool],
    prompt=prompt
)

executor = AgentExecutor(agent=agent, tools=[xlsx_tool, pdf_tool, docx_tool, csv_tool])

# Let the agent analyze all documents
result = executor.invoke({
    "input": "Analyze all the documents and create a comprehensive summary report."
})
```

## Toolkit Features

### File Object Pattern

All file analysis tools use the `FileObject` pattern for consistent file handling:

```python
from codemie_tools.base.file_object import FileObject

# From file path
file_obj = FileObject.from_path("document.pdf")

# From bytes
file_obj = FileObject.from_bytes(
    content=pdf_bytes,
    filename="document.pdf",
    mime_type="application/pdf"
)
```

### Error Handling

All tools raise `ToolException` on errors:

```python
from langchain_core.tools import ToolException

try:
    result = tool.execute(get_stats=True)
except ToolException as e:
    print(f"Error: {e}")
```

### Multi-File Support

Many tools support processing multiple files at once:

```python
files = [
    FileObject.from_path("report1.xlsx"),
    FileObject.from_path("report2.xlsx"),
    FileObject.from_path("report3.xlsx"),
]

tool = XlsxTool(files=files)
stats = tool.execute(get_stats=True)  # Statistics for all files
```

## Real-World Use Cases

### Business Intelligence

```python
# Analyze sales data from Excel
xlsx_tool = XlsxTool(files=[FileObject.from_path("sales_report.xlsx")])
stats = xlsx_tool.execute(get_stats=True)
q1_data = xlsx_tool.execute(filter_value="Q1", filter_mode="contains")
```

### Document Comparison

```python
# Compare data across different document formats
excel_data = xlsx_tool.execute(sheet_names=["Data"])
pdf_text = pdf_tool.execute(pages=[1, 2], query="Text")
word_content = docx_tool.execute()

# AI agent compares all three
result = agent.invoke({
    "input": f"""
    Compare these documents and identify discrepancies:
    Excel: {excel_data}
    PDF: {pdf_text}
    Word: {word_content}
    """
})
```

### Automated Report Generation

```python
# Extract data from multiple sources
xlsx_data = xlsx_tool.execute(sheet_names=["Summary"])
csv_stats = csv_tool.execute(method_name="describe")
pdf_metadata = pdf_tool.execute(query="TextWithMetadata")

# Generate comprehensive report
agent.invoke({
    "input": "Create a detailed report based on all the extracted data"
})
```

## Next Steps

- **[File Analysis Toolkit](file-analysis/index.md)**: Complete documentation for all file analysis tools
- **[XLSX Tool](file-analysis/xlsx/overview.md)**: Excel processing in detail
- **[PDF Tool](file-analysis/pdf/overview.md)**: PDF extraction guide
- **[CSV Tool](file-analysis/csv/overview.md)**: CSV data analysis
- **[Getting Started](../getting-started/quick-start.md)**: Quick start guide
