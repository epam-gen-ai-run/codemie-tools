# File Analysis Toolkit

Process and analyze various document formats including Excel, PDF, Word, and PowerPoint files.

## Overview

The File Analysis Toolkit provides comprehensive tools for working with common document formats. Each tool is optimized for its specific file type and provides rich functionality for data extraction, analysis, and conversion.

## Available Tools

### XLSX Tool

**Status**: ✅ Fully Documented

Process Microsoft Excel files (.xlsx, .xls) with advanced features:

- Load specific sheets or all sheets
- Filter data based on cell values
- Generate comprehensive statistics
- Convert to markdown format
- Handle complex layouts and pivot tables

**[View Documentation →](xlsx/overview.md)**

**Quick Example:**

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("data.xlsx")
tool = XlsxTool(files=[file_obj])

# Get statistics
stats = tool.execute(get_stats=True)
print(stats)

# Filter data
result = tool.execute(
    filter_value="Approved",
    filter_mode="exact"
)
```

### PDF Tool

**Status**: 📄 Available

Extract text and metadata from PDF files:

- Extract text from specific pages
- Get total page count
- Extract text with metadata
- OCR support for scanned documents

**[View Documentation →](pdf/overview.md)**

**Quick Example:**

```python
from codemie_tools.file_analysis.pdf_tool import PDFTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("document.pdf")
tool = PDFTool(files=[file_obj])

# Extract text from pages 1-3
text = tool.execute(pages=[1, 2, 3], query="Text")
print(text)
```

### DOCX Tool

**Status**: 📄 Available

Process Microsoft Word documents (.docx):

- Extract text content
- Preserve formatting
- Extract tables and images
- Convert to markdown

**[View Documentation →](docx/overview.md)**

**Quick Example:**

```python
from codemie_tools.file_analysis.docx_tool import DocxTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("report.docx")
tool = DocxTool(files=[file_obj])

# Extract content
content = tool.execute()
print(content)
```

### PPTX Tool

**Status**: 📄 Available

Process Microsoft PowerPoint presentations (.pptx):

- Extract slide content
- Get slide notes
- Extract images
- Convert to markdown

**[View Documentation →](pptx/overview.md)**

**Quick Example:**

```python
from codemie_tools.file_analysis.pptx_tool import PptxTool
from codemie_tools.base.file_object import FileObject

file_obj = FileObject.from_path("presentation.pptx")
tool = PptxTool(files=[file_obj])

# Extract all slides
slides = tool.execute()
print(slides)
```

## Common Use Cases

### Business Intelligence

Process Excel reports, extract key metrics, and generate insights:

```python
xlsx_tool = XlsxTool(files=[FileObject.from_path("sales_report.xlsx")])
stats = xlsx_tool.execute(get_stats=True)
q1_data = xlsx_tool.execute(filter_value="Q1", filter_mode="contains")
```

### Document Analysis

Extract and analyze content from various document types:

```python
# PDF analysis
pdf_tool = PDFTool(files=[FileObject.from_path("contract.pdf")])
text = pdf_tool.execute(pages=[1, 2, 3], query="Text")

# Word document analysis
docx_tool = DocxTool(files=[FileObject.from_path("proposal.docx")])
content = docx_tool.execute()
```

### Report Generation

Extract data from source documents and generate reports:

```python
# Extract from Excel
xlsx_tool = XlsxTool(files=[FileObject.from_path("data.xlsx")])
data = xlsx_tool.execute(sheet_names=["Summary"])

# Use AI agent to generate report
agent.invoke({"input": f"Analyze this data and create a report: {data}"})
```

### Data Migration

Convert documents to structured formats:

```python
# Excel to markdown
xlsx_tool = XlsxTool(files=[FileObject.from_path("data.xlsx")])
markdown = xlsx_tool.execute(sheet_names=["Data"])

# Save markdown
with open("data.md", "w") as f:
    f.write(markdown)
```

## LangChain Integration

All file analysis tools work seamlessly with LangChain:

```python
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

# Create tools
xlsx_tool = XlsxTool(files=[FileObject.from_path("sales.xlsx")])
pdf_tool = PDFTool(files=[FileObject.from_path("report.pdf")])

# Create agent
llm = ChatOpenAI(model="gpt-4", temperature=0)
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a document analysis assistant."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(
    llm=llm,
    tools=[xlsx_tool, pdf_tool],
    prompt=prompt
)

executor = AgentExecutor(agent=agent, tools=[xlsx_tool, pdf_tool])

# Analyze documents
result = executor.invoke({
    "input": "Compare the data in the Excel file with the PDF report."
})
```

## Common Patterns

### Pattern 1: Multi-File Processing

Process multiple files of the same type:

```python
files = [
    FileObject.from_path("report1.xlsx"),
    FileObject.from_path("report2.xlsx"),
    FileObject.from_path("report3.xlsx"),
]

tool = XlsxTool(files=files)
stats = tool.execute(get_stats=True)  # Statistics for all files
```

### Pattern 2: Cross-Format Analysis

Analyze different document formats together:

```python
# Extract from different formats
excel_data = xlsx_tool.execute(sheet_names=["Data"])
pdf_text = pdf_tool.execute(pages=[1, 2], query="Text")
word_content = docx_tool.execute()

# Combine in AI agent
agent.invoke({
    "input": f"""
    Compare these documents:
    Excel: {excel_data}
    PDF: {pdf_text}
    Word: {word_content}
    """
})
```

### Pattern 3: Exploratory Analysis

Explore unknown files before processing:

```python
# Step 1: Explore
sheets = xlsx_tool.execute(get_sheet_names=True)
stats = xlsx_tool.execute(get_stats=True)

# Step 2: Process based on exploration
target_sheet = identify_target_sheet(stats)
data = xlsx_tool.execute(sheet_names=[target_sheet])
```

## Best Practices

### 1. Use FileObject Consistently

```python
# Good: Use FileObject
file_obj = FileObject.from_path("data.xlsx")
tool = XlsxTool(files=[file_obj])

# Avoid: Direct file paths
# Tools expect FileObject, not paths
```

### 2. Explore Before Processing

```python
# Always explore unfamiliar files
stats = tool.execute(get_stats=True)
# Then process based on structure
```

### 3. Handle Large Files Appropriately

```python
# For large files, process in chunks
sheets = xlsx_tool.execute(get_sheet_names=True)
for idx in range(len(sheets)):
    result = xlsx_tool.execute(sheet_index=idx)
    process_chunk(result)
```

### 4. Combine with AI Agents

```python
# Let AI agents use tools naturally
# They can explore, analyze, and extract data automatically
executor.invoke({
    "input": "Analyze these files and find the key trends."
})
```

## File Format Support

| Format | Extension | Read | Write | Metadata | OCR |
|--------|-----------|------|-------|----------|-----|
| Excel | .xlsx, .xls | ✅ | ❌ | ✅ | N/A |
| PDF | .pdf | ✅ | ❌ | ✅ | ✅* |
| Word | .docx | ✅ | ❌ | ✅ | N/A |
| PowerPoint | .pptx | ✅ | ❌ | ✅ | N/A |

*OCR available with vision-capable LLM

## Next Steps

- **[XLSX Tool Documentation](xlsx/overview.md)**: Complete XLSX tool guide
- **[PDF Tool Documentation](pdf/overview.md)**: PDF processing guide
- **[DOCX Tool Documentation](docx/overview.md)**: Word document guide
- **[PPTX Tool Documentation](pptx/overview.md)**: PowerPoint guide
<!-- - **[Recipes](../../recipes/processing-excel-files.md)**: Practical examples (TODO: Create recipes documentation) -->
