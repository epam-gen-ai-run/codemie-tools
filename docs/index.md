# CodeMie Tools

**Comprehensive Python toolkit for AI agents and automation**

[![PyPI version](https://badge.fury.io/py/codemie-tools.svg)](https://pypi.org/project/codemie-tools/)
[![Python Version](https://img.shields.io/pypi/pyversions/codemie-tools.svg)](https://pypi.org/project/codemie-tools/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

CodeMie Tools is a comprehensive Python toolkit designed to simplify and streamline various development tasks for AI agents and automation workflows. This package provides a rich set of tools organized into specialized toolkits.

### Featured: File Analysis Toolkit

Process and analyze various document formats with comprehensive tools:

- **[XLSX](toolkits/file-analysis/xlsx/overview.md)**: Excel file processing with filtering, statistics, and markdown conversion
- **[PDF](toolkits/file-analysis/pdf/overview.md)**: PDF text extraction with OCR support
- **[DOCX](toolkits/file-analysis/docx/overview.md)**: Word document processing and content extraction
- **[PPTX](toolkits/file-analysis/pptx/overview.md)**: PowerPoint presentation analysis
- **[CSV](toolkits/file-analysis/csv/overview.md)**: CSV data analysis with pandas integration

**[View Full Documentation →](toolkits/file-analysis/index.md)**

The toolkit also includes additional specialized toolkits for project management, data operations, notifications, code quality, version control, testing, research, cloud services, and more.

## Key Features

- **LangChain Integration**: Native support for LangChain and LangGraph workflows
- **Modular Architecture**: Use only the toolkits you need
- **Type-Safe Configuration**: Pydantic-based configuration models
- **Comprehensive Error Handling**: Consistent error handling across all tools
- **Extensible Design**: Easy to create custom tools and toolkits
- **Developer-Friendly**: Clear APIs with extensive documentation

## Quick Start

### Installation

```bash
pip install codemie-tools
```

or with Poetry:

```bash
poetry add codemie-tools
```

### Basic Usage

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# Create a file object from your Excel file
file_obj = FileObject.from_path("data.xlsx")

# Initialize the XLSX tool
tool = XlsxTool(files=[file_obj])

# Get sheet names
result = tool.execute(get_sheet_names=True)
print(result)

# Get statistics about the file
stats = tool.execute(get_stats=True)
print(stats)

# Process specific sheets
content = tool.execute(sheet_names=["Sheet1", "Summary"])
print(content)
```

### LangChain Integration

```python
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain_openai import ChatOpenAI
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# Set up LLM
llm = ChatOpenAI(model="gpt-4", temperature=0)

# Create tools
file_obj = FileObject.from_path("sales_data.xlsx")
xlsx_tool = XlsxTool(files=[file_obj])

# Create agent
agent = create_openai_functions_agent(
    llm=llm,
    tools=[xlsx_tool],
    prompt=your_prompt
)

# Execute
agent_executor = AgentExecutor(agent=agent, tools=[xlsx_tool])
result = agent_executor.invoke({
    "input": "Analyze the sales data and find the top performing products"
})
```

## Architecture

CodeMie Tools follows a modular toolkit-based architecture:

```
codemie-tools/
├── Base Classes
│   ├── CodeMieTool        # Base class for all tools
│   ├── BaseToolkit        # Base class for toolkits
│   └── DiscoverableToolkit # Auto-discoverable toolkits
│
└── Toolkits               # Specialized toolkits
    ├── File Analysis      # XLSX, PDF, DOCX, PPTX, CSV
    └── Additional toolkits for various integrations
```

Each toolkit contains:
- **Tools**: Individual tools implementing specific functionality
- **Configuration Models**: Type-safe configuration using Pydantic
- **Error Handling**: Consistent `ToolException` usage across all tools
- **Comprehensive Documentation**: Usage guides, API references, and examples

## Why CodeMie Tools?

### For AI Agent Developers

- **LangChain Native**: Works seamlessly with LangChain and LangGraph
- **Rich Tool Ecosystem**: 50+ tools covering common automation tasks
- **Consistent Interface**: All tools follow the same patterns
- **Type Safety**: Full Pydantic validation for configurations

### For Python Developers

- **Clean APIs**: Intuitive, Pythonic interfaces
- **Async Support**: Async operations where applicable
- **Comprehensive Testing**: High test coverage
- **Production Ready**: Used in enterprise environments

### For DevOps Engineers

- **Easy Integration**: Simple configuration and deployment
- **Modular Installation**: Install only what you need
- **Environment Configuration**: Support for environment variables
- **Logging & Monitoring**: Built-in logging support

## What's Next?

- **[Getting Started](getting-started/installation.md)**: Install and configure CodeMie Tools
- **[Quick Start Guide](getting-started/quick-start.md)**: Get up and running in 5 minutes
- **[Toolkits Overview](toolkits/overview.md)**: Explore available toolkits

## Community & Support

- **GitHub**: [Report issues and contribute](https://github.com/epam-gen-ai-run/codemie-tools)
- **PyPI**: [Package on PyPI](https://pypi.org/project/codemie-tools/)
- **Documentation**: You're reading it!

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](https://github.com/epam-gen-ai-run/codemie-tools/blob/main/LICENSE) file for details.
