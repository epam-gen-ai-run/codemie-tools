# XLSX Tool - Overview

The XLSX tool provides comprehensive functionality for processing and analyzing Microsoft Excel files (.xlsx, .xls) in your AI agent workflows.

## Key Features

- **Sheet Operations**: Load specific sheets or all sheets from Excel files
- **Data Filtering**: Filter rows based on cell values with exact or substring matching
- **Statistics Generation**: Get comprehensive metadata about Excel structure
- **Visibility Control**: Process only visible sheets, excluding hidden sheets
- **Markdown Conversion**: Convert Excel data to markdown format
- **LangChain Integration**: Native support for LangChain agents

## Use Cases

### Business Intelligence
- Analyze sales reports and extract key metrics
- Process financial data and generate summaries
- Compare data across multiple sheets

### Data Extraction
- Extract specific rows matching criteria
- Convert Excel data to structured formats
- Process pivot tables and complex layouts

### AI Agent Integration
- Let AI agents analyze Excel files
- Enable natural language queries over spreadsheet data
- Automated report generation

## Architecture

The XLSX tool consists of two main components:

### XlsxTool
High-level tool implementing the `CodeMieTool` interface. This is what you use in LangChain agents.

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
```

### XlsxProcessor
Low-level processor for loading and transforming Excel data. Used internally by XlsxTool but can be used standalone.

```python
from codemie_tools.file_analysis.xlsx.processor import XlsxProcessor
```

## Quick Example

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# Create file object
file_obj = FileObject.from_path("sales_report.xlsx")

# Initialize tool
tool = XlsxTool(files=[file_obj])

# Get all sheet names
sheets = tool.execute(get_sheet_names=True)
print(sheets)

# Get file statistics
stats = tool.execute(get_stats=True)
print(stats)

# Process specific sheets with filtering
result = tool.execute(
    sheet_names=["Q1 Sales"],
    filter_value="Approved",
    filter_mode="exact"
)
print(result)
```

## Next Steps

- **[API Reference](api-reference.md)**: Complete API documentation
- **[Usage Guide](usage-guide.md)**: Detailed usage patterns
- **[Filtering](filtering.md)**: Advanced filtering techniques
- **[Statistics](statistics.md)**: Understanding statistics output
- **[Examples](examples.md)**: Practical code examples
