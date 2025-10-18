# CodeMie Tools

[![PyPI version](https://badge.fury.io/py/codemie-tools.svg)](https://pypi.org/project/codemie-tools/)
[![Python Version](https://img.shields.io/pypi/pyversions/codemie-tools.svg)](https://pypi.org/project/codemie-tools/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

**Comprehensive Python toolkit for AI agents and automation**

CodeMie Tools is a production-ready toolkit designed to simplify and streamline development tasks for AI agents and automation workflows. Built with LangChain integration at its core, it provides specialized toolkits for common enterprise operations.

## 🚀 Quick Start

### Installation

```bash
pip install codemie-tools
```

### Basic Usage

```python
from codemie_tools.file_analysis.xslx_tool import XlsxTool
from codemie_tools.base.file_object import FileObject

# Load and analyze an Excel file
file_obj = FileObject.from_path("data.xlsx")
tool = XlsxTool(files=[file_obj])

# Get file statistics
stats = tool.execute(get_stats=True)
print(stats)

# Filter data
result = tool.execute(
    filter_value="Approved",
    filter_mode="exact"
)
```

### LangChain Integration

```python
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

llm = ChatOpenAI(model="gpt-4", temperature=0)
file_obj = FileObject.from_path("sales_data.xlsx")
xlsx_tool = XlsxTool(files=[file_obj])

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a data analyst assistant."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_openai_functions_agent(llm=llm, tools=[xlsx_tool], prompt=prompt)
executor = AgentExecutor(agent=agent, tools=[xlsx_tool])

result = executor.invoke({"input": "Analyze the sales trends in this file."})
```

## 📦 Available Toolkits

### File Analysis
Process and analyze documents:
- **XLSX**: Excel file processing with filtering and statistics
- **PDF**: Text extraction and OCR support
- **DOCX**: Word document processing
- **PPTX**: PowerPoint presentation analysis

### Project Management
Integrate with project management platforms:
- **Jira**: Issue tracking and management
- **Confluence**: Documentation and knowledge base

### Data Management
Work with databases and storage:
- **Elasticsearch**: Search and analytics
- **SQL**: Relational database operations
- **File System**: File and directory operations
- **Code Executor**: Safe code execution

### Access Management
Handle authentication and authorization:
- **Keycloak**: Identity and access management
- **IAM**: AWS Identity and Access Management

### Notification
Send notifications via multiple channels:
- **Email**: SMTP email notifications
- **Telegram**: Telegram bot integration

### Code Quality
Integrate with quality tools:
- **SonarQube**: Code quality and security analysis

### Version Control
Work with VCS platforms:
- **GitLab**: GitLab API integration
- **GitHub**: GitHub API integration
- **Git**: Direct Git operations

### QA & Testing
Quality assurance tools:
- **Zephyr Scale**: Test management for Jira
- **Zephyr Squad**: Test case management
- **ReportPortal**: Test automation reporting

### Research
Information gathering tools:
- **Google Search**: Custom search API
- **Wikipedia**: Knowledge base access

### Cloud
Cloud service integrations:
- **AWS**: Amazon Web Services operations
- **Kubernetes**: Container orchestration

### Additional Toolkits
- **Azure DevOps**: Azure DevOps services integration
- **ITSM**: IT Service Management
- **Vision**: Image processing and OCR

## 🎯 Key Features

- **LangChain Native**: Seamless integration with LangChain and LangGraph
- **Modular Architecture**: Use only the toolkits you need
- **Type-Safe**: Pydantic-based configuration models
- **Production Ready**: Comprehensive error handling and logging
- **Extensible**: Easy to create custom tools and toolkits
- **Well Documented**: Extensive documentation with examples

## 📖 Documentation

Comprehensive documentation is available at: [https://epam-gen-ai-run.github.io/codemie-tools/](https://epam-gen-ai-run.github.io/codemie-tools/)

- [Installation Guide](https://epam-gen-ai-run.github.io/codemie-tools/getting-started/installation/)
- [Quick Start](https://epam-gen-ai-run.github.io/codemie-tools/getting-started/quick-start/)
- [Toolkits Overview](https://epam-gen-ai-run.github.io/codemie-tools/toolkits/overview/)
- [API Reference](https://epam-gen-ai-run.github.io/codemie-tools/toolkits/file-analysis/xlsx/api-reference/)

## 💡 Example Use Cases

### Business Intelligence
```python
# Analyze sales reports
xlsx_tool = XlsxTool(files=[FileObject.from_path("sales.xlsx")])
stats = xlsx_tool.execute(get_stats=True)
q1_data = xlsx_tool.execute(filter_value="Q1", filter_mode="contains")
```

### Automated Testing Workflows
```python
# Execute tests and create Jira tickets for failures
from codemie_tools.core.project_management.jira.tools import GenericJiraIssueTool
from codemie_tools.core.project_management.jira.models import JiraConfig

jira_tool = GenericJiraIssueTool(config=JiraConfig(url="...", token="..."))
result = jira_tool.execute(
    operation="create",
    params={"summary": "Test Failed", "description": "Details..."}
)
```

### Document Processing
```python
# Extract data from multiple document types
pdf_tool = PDFTool(files=[FileObject.from_path("contract.pdf")])
docx_tool = DocxTool(files=[FileObject.from_path("proposal.docx")])

pdf_text = pdf_tool.execute(pages=[1, 2], query="Text")
docx_content = docx_tool.execute()
```

## 🔧 Development

### Setup

```bash
# Clone repository
git clone https://github.com/epam-gen-ai-run/codemie-tools.git
cd codemie-tools

# Install dependencies
make install

# Run tests
make test

# Run linting
make ruff-fix
```

### Project Structure

```
codemie-tools/
├── src/codemie_tools/          # Main package
│   ├── base/                   # Base classes and utilities
│   ├── file_analysis/          # File processing tools
│   ├── core/                   # Core toolkits (PM, VCS)
│   ├── data_management/        # Data management tools
│   ├── notification/           # Notification tools
│   └── ...                     # Other toolkits
├── tests/                      # Test suite
├── docs/                       # Documentation source
└── .codemie/                   # CodeMie configuration
```

## 📋 Requirements

- **Python**: 3.12 or 3.13
- **Core Dependencies**: LangChain, Pydantic, httpx
- **Optional Dependencies**: Vary by toolkit

## 🤝 Contributing

Contributions are welcome! Please see our [Contributing Guide](https://epam-gen-ai-run.github.io/codemie-tools/developer-guide/contributing/) for details.

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write/update tests
5. Submit a pull request

## 📝 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **PyPI**: [https://pypi.org/project/codemie-tools/](https://pypi.org/project/codemie-tools/)
- **Documentation**: [https://epam-gen-ai-run.github.io/codemie-tools/](https://epam-gen-ai-run.github.io/codemie-tools/)
- **Source Code**: [https://github.com/epam-gen-ai-run/codemie-tools](https://github.com/epam-gen-ai-run/codemie-tools)
- **Issue Tracker**: [https://github.com/epam-gen-ai-run/codemie-tools/issues](https://github.com/epam-gen-ai-run/codemie-tools/issues)

## 🙋 Support

- **Documentation**: Visit our [documentation site](https://epam-gen-ai-run.github.io/codemie-tools/)
- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/epam-gen-ai-run/codemie-tools/issues)
- **Discussions**: Join conversations in [GitHub Discussions](https://github.com/epam-gen-ai-run/codemie-tools/discussions)

## 🎉 Acknowledgments

Built and maintained by the EPAM AI/Run CodeMie team.
