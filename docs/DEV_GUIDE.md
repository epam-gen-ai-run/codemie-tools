# CodeMie Tools Development Guide

> **AI Agent Development Specification**
> This document provides comprehensive guidelines for AI agents developing features, tools, and toolkits for the CodeMie Tools project.

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture & Technology Stack](#architecture-technology-stack)
3. [Project Structure](#project-structure)
4. [Development Guidelines](#development-guidelines)
5. [Toolkit Development](#toolkit-development)
6. [Tool Development](#tool-development)
7. [Testing Strategy](#testing-strategy)
8. [Code Quality Standards](#code-quality-standards)
9. [Common Patterns & Utilities](#common-patterns-utilities)
10. [Quick Reference](#quick-reference)

---

## Project Overview

**CodeMie Tools** is a comprehensive Python toolkit designed to simplify and streamline various development tasks. This package provides a set of tools for access management, notification, code quality, data management, version control, project management, research, file processing, and more.

### Key Information
- **Package Name**: codemie-tools
- **Version**: 0.1.3.2
- **Python Version**: >=3.12, <3.14
- **Development Setup**: `make install`
- **Build**: `make build`
- **Test**: `make test` or `poetry run pytest tests/`
- **Linting**: `make ruff` or `make ruff-fix`
- **Coverage**: `make coverage`
- **Branching Model**: Trunk-based development (PRs to `main`)
- **Branch Pattern**: `EPMCDME-XXXX_short-description`
- **Commit Pattern**: `EPMCDME-XXXX: Description of a commit`

### Core Philosophy
CodeMie Tools follows the **KISS (Keep It Simple, Stupid)** and **DRY (Don't Repeat Yourself)** principles. All code should be:
- Clean, efficient, and well-documented
- Maintainable and readable with low complexity
- Following language-specific best practices and conventions
- Properly structured with appropriate error handling
- Considering edge cases and potential issues

---

## Architecture & Technology Stack

### Core Technologies
- **Language**: Python 3.12+
- **Package Manager**: Poetry 1.0.0+
- **Testing**: pytest 8.3.x, pytest-asyncio, pytest-cov
- **Code Quality**: Ruff 0.5.4+ (linting & formatting), Flake8 7.1.1+
- **Framework**: LangChain 0.3.25 ecosystem (langchain-core, langchain-community, langchain-openai, langchain-experimental)
- **Data Validation**: Pydantic 2.9.2+
- **HTTP Client**: httpx 0.28.1+
- **Database**: SQLAlchemy 2.0.35+, psycopg 3.2.9+, pymysql 1.1.1+, pymssql 2.2.11

### Key Dependencies
- **Cloud Integrations**: azure-devops 7.1.0b4, azure-identity 1.16.0+, boto3 1.34.147+
- **VCS**: python-gitlab 4.6.0+, PyGithub 2.2.0+, GitPython 3.1.32+
- **Project Management**: atlassian-python-api 4.0.6+ (Jira, Confluence)
- **Data Management**: elasticsearch 8.18.1, pandas 2.2.2+
- **File Processing**: pymupdf4llm 0.0.24+, python-docx 1.1.0+, python-pptx 1.0.2+, markitdown 0.1.2+
- **AI/ML**: langchain-openai 0.3.17, tiktoken 0.9.0+
- **QA**: zephyr-python-api 0.1.0+
- **Other**: kubernetes 30.1.0+, influxdb-client 1.48.0+

---

## Project Structure

```
codemie-tools/
├── .codemie/                          # CodeMie configuration
│   └── virtual_assistants/            # AI assistant definitions (.yaml)
│       ├── codemie_tools_developer.yaml  # Primary developer assistant
│       ├── python_developer.yaml      # Python specialist
│       ├── code_reviewer.yaml         # Code review assistant
│       └── ...                        # Other specialized assistants
├── src/
│   └── codemie_tools/                 # ⭐ PRIMARY: All toolkit code
│       ├── __init__.py
│       ├── base/                      # Base classes and utilities
│       │   ├── base_tool.py          # CodeMieTool base class
│       │   ├── base_toolkit.py       # BaseToolkit, DiscoverableToolkit
│       │   ├── models.py             # ToolKit, ToolSet, Tool models
│       │   └── utils.py              # Shared utility functions
│       ├── core/                      # Core toolkits
│       │   ├── project_management/    # Jira, Confluence
│       │   │   ├── __init__.py
│       │   │   ├── toolkit.py
│       │   │   ├── jira/              # Jira tool package
│       │   │   │   ├── models.py      # JiraConfig, JiraInput
│       │   │   │   ├── tools.py       # GenericJiraIssueTool
│       │   │   │   ├── tools_vars.py  # GENERIC_JIRA_TOOL metadata
│       │   │   │   └── jira_client.py # Jira API client
│       │   │   └── confluence/        # Confluence tool package
│       │   │       ├── models.py      # ConfluenceConfig, ConfluenceInput
│       │   │       ├── tools.py       # GenericConfluenceTool
│       │   │       ├── tools_vars.py  # GENERIC_CONFLUENCE_TOOL metadata
│       │   │       └── confluence_client.py  # Confluence API client
│       │   └── vcs/                   # Version Control System tools
│       │       ├── toolkit.py
│       │       ├── gitlab/            # GitLab tools
│       │       └── github/            # GitHub tools
│       ├── access_management/         # Keycloak, IAM tools
│       ├── azure_devops/              # Azure DevOps integration
│       ├── code/                      # Code quality tools
│       │   ├── sonar/                 # SonarQube integration
│       │   ├── linter/                # Linting tools
│       │   └── coder/                 # Code generation tools
│       ├── data_management/           # Data management tools
│       │   ├── elastic/               # Elasticsearch
│       │   ├── sql/                   # SQL database tools
│       │   └── file_system/           # File system operations
│       ├── file_analysis/             # File processing tools
│       │   ├── pdf/                   # PDF processing
│       │   ├── docx/                  # Word document processing
│       │   ├── pptx/                  # PowerPoint processing
│       │   └── xlsx/                  # Excel processing
│       ├── git/                       # Git operations
│       ├── itsm/                      # IT Service Management
│       ├── notification/              # Notification tools
│       │   ├── email/                 # Email notifications
│       │   └── telegram/              # Telegram notifications
│       ├── open_api/                  # OpenAPI tools
│       ├── qa/                        # QA and testing tools
│       │   ├── zephyr/                # Zephyr Scale integration
│       │   └── zephyr_squad/          # Zephyr Squad integration
│       ├── report_portal/             # ReportPortal integration
│       ├── research/                  # Research tools (Google Search, Wikipedia)
│       ├── utils/                     # Shared utilities
│       └── vision/                    # Image processing and OCR
├── tests/                             # Test files mirror src/ structure
│   └── codemie_tools/
│       ├── access_management/
│       ├── code/
│       └── ...
├── Makefile                           # Development commands
├── pyproject.toml                     # Poetry configuration & dependencies
├── pytest.ini                         # pytest configuration
├── README.md                          # Package documentation
└── claude.md                          # This file (AI developer guide)
```

---

## Development Guidelines

### File Naming Conventions

#### Python Modules
- **Packages**: snake_case (e.g., `project_management/`, `access_management/`)
- **Modules**: snake_case (e.g., `tools.py`, `toolkit.py`, `models.py`, `tools_vars.py`, `*_client.py`)
- **Classes**: PascalCase (e.g., `GenericJiraIssueTool`, `ProjectManagementToolkit`)
- **Functions/Methods**: snake_case (e.g., `get_toolkit()`, `execute()`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `GENERIC_JIRA_TOOL`)
- **Tests**: `test_*.py` (e.g., `test_jira_tool.py`)

### Code Style

#### Python Style Guide
- **Formatter**: Ruff (100 character line length)
- **Linter**: Ruff + Flake8
- **Quotes**: Double quotes preferred (Ruff default)
- **Indentation**: 4 spaces (Python standard)
- **Docstrings**: Required for all public classes and methods
- **Type Hints**: Use where appropriate for clarity
- **Imports**: Organized (standard library, third-party, local)

#### Key Ruff Configuration
```toml
[tool.ruff]
line-length = 100

[tool.ruff.lint]
ignore = ["F401"]  # Unused imports (sometimes needed for re-exports)

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

### Import Organization

```python
# Standard library imports
from typing import Type, List, Optional

# Third-party imports
from pydantic import Field, BaseModel
from langchain.tools import BaseTool

# Local imports
from codemie_tools.base.codemie_tool import CodeMieTool
from codemie_tools.base.models import ToolMetadata
from codemie_tools.base.utils import validate_url
```

---

## Toolkit Development

### Overview

A **Toolkit** is a collection of related tools that share a common purpose or integration. Each toolkit should:
1. Group logically related tools
2. Provide a unified configuration interface
3. Be discoverable through the UI (using `DiscoverableToolkit`)
4. Implement health checks when appropriate

### Toolkit Structure

Every toolkit package should contain:
- `__init__.py` - Package initializer
- `toolkit.py` - Toolkit registration and tool collection
- Tool packages (one per tool) with:
  - `models.py` - Configuration and input/output models
  - `tools.py` - Tool implementation
  - `tools_vars.py` - Tool metadata and descriptions
  - `*_client.py` - API/HTTP client (if integrating with external services)

### Creating a New Toolkit

#### Step 1: Create the Directory Structure

```bash
src/codemie_tools/
└── your_toolkit/
    ├── __init__.py
    ├── toolkit.py
    ├── tool_one/
    │   ├── __init__.py
    │   ├── models.py
    │   ├── tools.py
    │   ├── tools_vars.py
    │   └── target_client.py  # Optional: if integrating with external API
    └── tool_two/
        ├── __init__.py
        ├── models.py
        ├── tools.py
        └── tools_vars.py
```

#### Step 2: Define Tool Metadata (`tools_vars.py`)

```python
from codemie_tools.base.models import ToolMetadata
from .models import YourToolConfig

GENERIC_YOUR_TOOL = ToolMetadata(
    name="generic_your_tool",
    description="""
    Comprehensive description of what this tool does.
    Include:
    - Main capabilities
    - Use cases
    - API operations supported
    - Any important constraints or requirements
    """.strip(),
    label="Your Tool Label",
    user_description="""
    User-friendly description explaining:
    - What the tool provides
    - When to use it
    - Key features
    - Example use cases
    """.strip(),
    settings_config=True,  # Set to True if tool requires configuration
    config_class=YourToolConfig
)
```

#### Step 3: Define Configuration Models (`models.py`)

```python
from typing import Optional
from pydantic import Field
from codemie_tools.base.models import CodeMieToolConfig

class YourToolConfig(CodeMieToolConfig):
    """Configuration for Your Tool integration."""

    url: str = Field(
        description="URL to your service instance",
        json_schema_extra={"placeholder": "https://your-service.example.com/"}
    )

    api_token: str = Field(
        description="API token for authentication",
        json_schema_extra={
            "placeholder": "your_api_token",
            "sensitive": True,  # Marks as sensitive for UI
            "help": "https://docs.example.com/api-tokens"  # Help URL
        }
    )

    username: Optional[str] = Field(
        default=None,
        description="Username for authentication (optional)",
        json_schema_extra={"placeholder": "user@example.com"}
    )

    timeout: Optional[int] = Field(
        default=30,
        description="Request timeout in seconds"
    )

class YourToolInput(BaseModel):
    """Input schema for your tool."""

    operation: str = Field(
        ...,
        description="The operation to perform (e.g., 'get', 'create', 'update', 'delete')"
    )

    resource_id: Optional[str] = Field(
        default=None,
        description="Resource identifier for the operation"
    )

    params: Optional[dict] = Field(
        default=None,
        description="Additional parameters for the operation"
    )
```

#### Step 4: Implement the Tool (`tools.py`)

```python
from typing import Type

from langchain_core.tools import ToolException
from pydantic import BaseModel
from codemie_tools.base.codemie_tool import CodeMieTool
from .models import YourToolConfig, YourToolInput
from .tools_vars import GENERIC_YOUR_TOOL
from .target_client import YourServiceClient

class GenericYourTool(CodeMieTool):
    """Generic tool for interacting with Your Service."""

    config: YourToolConfig
    name: str = GENERIC_YOUR_TOOL.name
    description: str = GENERIC_YOUR_TOOL.description
    args_schema: Type[BaseModel] = YourToolInput

    def __init__(self, config: YourToolConfig):
        """Initialize the tool with configuration."""
        super().__init__(config=config)
        self.client = YourServiceClient(
            url=config.url,
            token=config.api_token,
            username=config.username,
            timeout=config.timeout
        )

    def execute(self, operation: str, resource_id: Optional[str] = None,
                params: Optional[dict] = None) -> dict:
        """
        Execute an operation on Your Service.

        Args:
            operation: The operation to perform
            resource_id: Optional resource identifier
            params: Optional additional parameters

        Returns:
            dict: Operation result

        Raises:
            ToolException: If operation fails
        """
        try:
            if operation == "get":
                return self._handle_get(resource_id, params)
            elif operation == "create":
                return self._handle_create(params)
            elif operation == "update":
                return self._handle_update(resource_id, params)
            elif operation == "delete":
                return self._handle_delete(resource_id)
            else:
                raise ToolException(f"Unsupported operation: {operation}")

        except Exception as e:
            raise ToolException(f"Failed to execute {operation}: {str(e)}")

    def _handle_get(self, resource_id: Optional[str], params: Optional[dict]) -> dict:
        """Handle GET operations."""
        if resource_id:
            return self.client.get_resource(resource_id)
        else:
            return self.client.list_resources(params or {})

    def _handle_create(self, params: dict) -> dict:
        """Handle CREATE operations."""
        if not params:
            raise ToolException("params required for create operation")
        return self.client.create_resource(params)

    def _handle_update(self, resource_id: str, params: dict) -> dict:
        """Handle UPDATE operations."""
        if not resource_id or not params:
            raise ToolException("resource_id and params required for update")
        return self.client.update_resource(resource_id, params)

    def _handle_delete(self, resource_id: str) -> dict:
        """Handle DELETE operations."""
        if not resource_id:
            raise ToolException("resource_id required for delete operation")
        return self.client.delete_resource(resource_id)

    def _healthcheck(self):
        """
        Check if the service is accessible.
        Only implement if tools don't share the same client.
        If tools share a client, implement healthcheck at toolkit level.
        Method should raise error
        """
        self.client.health_check()
```

#### Step 5: Implement API Client (`target_client.py`)

```python
import httpx
from typing import Dict, Any, Optional
from langchain_core.tools import ToolException

class YourServiceClient:
    """HTTP client for Your Service API."""

    def __init__(self, url: str, token: str, username: Optional[str] = None,
                 timeout: int = 30):
        """
        Initialize the client.

        Args:
            url: Base URL for the service
            token: API authentication token
            username: Optional username for authentication
            timeout: Request timeout in seconds
        """
        self.base_url = url.rstrip('/')
        self.token = token
        self.username = username
        self.timeout = timeout
        self.headers = {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }

    def _request(self, method: str, endpoint: str, **kwargs) -> Dict[str, Any]:
        """
        Make an HTTP request.

        Args:
            method: HTTP method (GET, POST, PUT, DELETE, etc.)
            endpoint: API endpoint (without base URL)
            **kwargs: Additional arguments for httpx.request

        Returns:
            dict: JSON response

        Raises:
            ToolException: If request fails
        """
        url = f"{self.base_url}/{endpoint.lstrip('/')}"

        try:
            with httpx.Client(timeout=self.timeout) as client:
                response = client.request(
                    method=method,
                    url=url,
                    headers=self.headers,
                    **kwargs
                )
                response.raise_for_status()
                return response.json() if response.content else {}

        except httpx.HTTPStatusError as e:
            raise ToolException(
                f"HTTP {e.response.status_code}: {e.response.text}"
            )
        except httpx.RequestError as e:
            raise ToolException(f"Request failed: {str(e)}")
        except Exception as e:
            raise ToolException(f"Unexpected error: {str(e)}")

    def get_resource(self, resource_id: str) -> Dict[str, Any]:
        """Get a specific resource by ID."""
        return self._request("GET", f"/api/resources/{resource_id}")

    def list_resources(self, params: Dict[str, Any]) -> Dict[str, Any]:
        """List resources with optional filters."""
        return self._request("GET", "/api/resources", params=params)

    def create_resource(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Create a new resource."""
        return self._request("POST", "/api/resources", json=data)

    def update_resource(self, resource_id: str, data: Dict[str, Any]) -> Dict[str, Any]:
        """Update an existing resource."""
        return self._request("PUT", f"/api/resources/{resource_id}", json=data)

    def delete_resource(self, resource_id: str) -> Dict[str, Any]:
        """Delete a resource."""
        return self._request("DELETE", f"/api/resources/{resource_id}")

    def health_check(self) -> bool:
        """Check if the service is healthy."""
        try:
            self._request("GET", "/api/health")
            return True
        except Exception:
            return False
```

#### Step 6: Create the Toolkit (`toolkit.py`)

```python
from typing import List
from codemie_tools.base.base_toolkit import DiscoverableToolkit
from codemie_tools.base.models import ToolKit, ToolSet, Tool
from .tool_one.tools import GenericToolOne
from .tool_one.tools_vars import GENERIC_TOOL_ONE
from .tool_two.tools import GenericToolTwo
from .tool_two.tools_vars import GENERIC_TOOL_TWO

class YourToolkitUI(ToolKit):
    """UI definition for Your Toolkit."""

    toolkit: ToolSet = ToolSet.YOUR_TOOLKIT  # Define in base/models.py
    tools: List[Tool] = [
        Tool.from_metadata(GENERIC_TOOL_ONE, tool_class=GenericToolOne),
        Tool.from_metadata(GENERIC_TOOL_TWO, tool_class=GenericToolTwo),
    ]
    label: str = "Your Toolkit"
    description: str = "Comprehensive toolkit for integrating with Your Service"

class YourToolkit(DiscoverableToolkit):
    """Toolkit for Your Service integration."""

    @classmethod
    def get_definition(cls):
        """Return toolkit definition for UI autodiscovery."""
        return YourToolkitUI()

    def healthcheck(self) -> bool:
        """
        Health check for the toolkit.
        Only implement here if tools share the same client.
        Otherwise, implement on tool level.
        """
        try:
            # Perform health check
            # Example: check if service is accessible
            return True
        except Exception:
            return False
```

### Best Practices for Toolkit Development

1. **Modular Design**: Each tool should be in its own package with clear separation of concerns
2. **Configuration**: Use Pydantic models with `json_schema_extra` for UI metadata
3. **Error Handling**: Use `ToolException` for all tool-related errors
4. **Client Separation**: Keep API clients separate from tool logic
5. **Reusability**: Utilize shared utilities from `src/codemie_tools/base/utils.py`
6. **Documentation**: Provide comprehensive docstrings for all public methods
7. **Health Checks**: Implement health checks at appropriate level (tool or toolkit)
8. **Testing**: Write tests for each tool (see Testing Strategy section)

---

## Tool Development

### Tool Base Class

All tools must inherit from `CodeMieTool` (which extends LangChain's `BaseTool`):

```python
from langchain_core.tools import ToolException
from codemie_tools.base.codemie_tool import CodeMieTool
```

### Required Tool Components

1. **Configuration Model** (`models.py`):
   - Inherits from `CodeMieToolConfig`
   - Defines all required and optional configuration fields
   - Uses `json_schema_extra` for UI metadata

2. **Input Schema** (`models.py`):
   - Inherits from `BaseModel`
   - Defines tool input parameters
   - Provides detailed descriptions for each field

3. **Tool Metadata** (`tools_vars.py`):
   - Creates a `ToolMetadata` instance
   - Provides comprehensive descriptions
   - Links to configuration model

4. **Tool Implementation** (`tools.py`):
   - Inherits from `CodeMieTool`
   - Implements `execute()` method
   - Handles errors with `ToolException`

### Tool Implementation Pattern

```python
from typing import Type
from langchain_core.tools import ToolException
from pydantic import BaseModel
from codemie_tools.base.codemie_tool import CodeMieTool

class YourTool(CodeMieTool):
    """Your tool description."""

    config: YourToolConfig
    name: str = TOOL_METADATA.name
    description: str = TOOL_METADATA.description
    args_schema: Type[BaseModel] = YourToolInput

    def execute(self, **kwargs):
        """
        Execute the tool operation.

        Args:
            **kwargs: Tool input parameters

        Returns:
            Result of the operation

        Raises:
            ToolException: If operation fails
        """
        try:
            # Implement tool logic
            result = self._perform_operation(**kwargs)
            return result
        except Exception as e:
            raise ToolException(f"Operation failed: {str(e)}")

    def _perform_operation(self, **kwargs):
        """Private method for operation logic."""
        # Implementation
        pass
```

### Error Handling Best Practices

```python
from langchain_core.tools import ToolException

def execute(self, **kwargs):
    """Execute with proper error handling."""

    # Validate inputs
    if not kwargs.get("required_field"):
        raise ToolException("required_field is mandatory")

    try:
        # Perform operation
        result = self._do_something(**kwargs)

        # Validate result
        if not result:
            raise ToolException("Operation returned empty result")

        return result

    except ToolException:
        # Re-raise ToolExceptions
        raise
    except ValueError as e:
        # Handle specific exceptions
        raise ToolException(f"Invalid value: {str(e)}")
    except Exception as e:
        # Catch-all for unexpected errors
        raise ToolException(f"Unexpected error: {str(e)}")
```

---

## Testing Strategy

### Test Framework: pytest

#### Test File Location
Tests should mirror the source structure:
```
tests/
└── codemie_tools/
    └── your_toolkit/
        └── tool_one/
            └── test_tools.py
```

#### Basic Test Pattern

```python
import pytest
from unittest.mock import Mock, patch
from langchain_core.tools import ToolException
from codemie_tools.your_toolkit.tool_one.tools import GenericToolOne
from codemie_tools.your_toolkit.tool_one.models import YourToolConfig

@pytest.fixture
def tool_config():
    """Create a test configuration."""
    return YourToolConfig(
        url="https://test.example.com",
        api_token="test_token"
    )

@pytest.fixture
def tool(tool_config):
    """Create a tool instance."""
    return GenericToolOne(config=tool_config)

def test_tool_initialization(tool):
    """Test tool initializes correctly."""
    assert tool.name == "generic_your_tool"
    assert tool.config.url == "https://test.example.com"

def test_execute_success(tool):
    """Test successful execution."""
    with patch.object(tool.client, 'get_resource') as mock_get:
        mock_get.return_value = {"id": "123", "name": "test"}

        result = tool.execute(operation="get", resource_id="123")

        assert result["id"] == "123"
        mock_get.assert_called_once_with("123")

def test_execute_failure(tool):
    """Test execution with error."""
    with patch.object(tool.client, 'get_resource') as mock_get:
        mock_get.side_effect = Exception("API Error")

        with pytest.raises(ToolException) as exc_info:
            tool.execute(operation="get", resource_id="123")

        assert "Failed to execute" in str(exc_info.value)

def test_execute_invalid_operation(tool):
    """Test with invalid operation."""
    with pytest.raises(ToolException) as exc_info:
        tool.execute(operation="invalid")

    assert "Unsupported operation" in str(exc_info.value)

@pytest.mark.asyncio
async def test_async_operation(tool):
    """Test async operations if applicable."""
    # Async test implementation
    pass
```

#### Running Tests

```bash
# Run all tests
make test

# Run specific test file
poetry run pytest tests/codemie_tools/your_toolkit/test_tools.py

# Run with coverage
make coverage

# Run with verbose output
poetry run pytest tests/ -v

# Run specific test
poetry run pytest tests/codemie_tools/your_toolkit/test_tools.py::test_execute_success
```

### Testing Best Practices

1. **Mock External Dependencies**: Always mock API clients and external services
2. **Test Edge Cases**: Include tests for error conditions, invalid inputs, edge cases
3. **Use Fixtures**: Create reusable fixtures for common test data
4. **Async Tests**: Use `pytest.mark.asyncio` for async operations
5. **Coverage**: Aim for high test coverage (use `make coverage`)
6. **Clear Test Names**: Use descriptive test function names
7. **Arrange-Act-Assert**: Follow AAA pattern in tests

---

## Code Quality Standards

### Linting and Formatting

The project uses **Ruff** for both linting and formatting:

```bash
# Check and auto-fix linting issues
make ruff-fix

# Format code
make ruff-format

# Run both
make ruff

# Verify code quality (lint + test)
make verify
```

### Code Quality Rules

1. **Line Length**: Maximum 100 characters
2. **Docstrings**: Required for all public classes and methods
3. **Type Hints**: Use where appropriate for clarity
4. **Comments**: Include helpful comments for complex logic
5. **Error Handling**: Always use try-except with specific exceptions
6. **KISS Principle**: Keep implementations simple and straightforward
7. **DRY Principle**: Don't repeat code; extract to utilities
8. **Low Complexity**: Avoid high cognitive complexity to prevent Sonar issues

### Import Organization

```python
# 1. Standard library imports
import os
from typing import List, Dict, Optional

# 2. Third-party imports
from pydantic import Field, BaseModel
from langchain.tools import BaseTool

# 3. Local imports
from codemie_tools.base.codemie_tool import CodeMieTool
from codemie_tools.base.models import ToolMetadata
```

### Git Commit Guidelines

```bash
# Branch naming
EPMCDME-8317_add-gitlab-toolkit
EPMCDME-8318_fix-confluence-auth

# Commit messages
EPMCDME-8317: Add GitLab toolkit with repository operations
EPMCDME-8318: Fix Confluence authentication for cloud instances
EPMCDME-8319: Update README with new toolkit documentation
```

### Pull Request Process

1. Create feature branch from `main`: `EPMCDME-XXXX_description`
2. Implement changes following this guide
3. Write tests for new functionality
4. Run linting: `make ruff-fix`
5. Run tests: `make test`
6. Verify coverage: `make coverage`
7. Create PR to `main` branch
8. Ensure CI passes
9. Request review
10. Merge after approval

---

## Common Patterns & Utilities

### Base Utilities (`src/codemie_tools/base/utils.py`)

The base utils module provides shared functionality. **Always check and utilize existing utilities before implementing new ones.**

Common utilities include:
- URL validation and normalization
- String manipulation and sanitization
- Date/time formatting
- File operations
- HTTP request helpers
- Error handling utilities

**Before implementing new utility functions**:
1. Check if similar functionality exists in `base/utils.py`
2. If implementing new utilities, suggest adding them to `base/utils.py` for reusability
3. Get user approval before adding new shared utilities

### Configuration Pattern

All tool configurations should extend `CodeMieToolConfig`:

```python
from codemie_tools.base.models import CodeMieToolConfig
from pydantic import Field
from typing import Optional

class YourConfig(CodeMieToolConfig):
    """Configuration for your tool."""

    # Required fields
    url: str = Field(
        description="Service URL",
        json_schema_extra={"placeholder": "https://example.com"}
    )

    # Sensitive fields (passwords, tokens, keys)
    api_token: str = Field(
        description="API authentication token",
        json_schema_extra={
            "placeholder": "your_token",
            "sensitive": True,  # Marks as sensitive in UI
            "help": "https://docs.example.com/api-keys"
        }
    )

    # Optional fields
    timeout: Optional[int] = Field(
        default=30,
        description="Request timeout in seconds"
    )
```

### JSON Schema Extras

Use `json_schema_extra` to provide UI metadata:

```python
Field(
    description="Field description",
    json_schema_extra={
        "placeholder": "Example value",  # Placeholder text in UI
        "sensitive": True,                # Mask value in UI (for passwords)
        "help": "https://docs.link",      # Help documentation link
        "default": "default_value"        # Default value
    }
)
```

### Exception Handling Pattern

```python
from langchain_core.tools import ToolException

def execute(self, **kwargs):
    """Execute with standardized error handling."""

    # Input validation
    if not kwargs.get("required_param"):
        raise ToolException("required_param is mandatory")

    try:
        # Operation logic
        result = self._perform_operation(**kwargs)

        # Result validation
        if not self._is_valid_result(result):
            raise ToolException("Invalid operation result")

        return result

    except ToolException:
        # Re-raise ToolExceptions (already formatted)
        raise

    except SpecificException as e:
        # Handle known exceptions
        raise ToolException(f"Specific error: {str(e)}")

    except Exception as e:
        # Catch unexpected errors
        raise ToolException(f"Unexpected error: {str(e)}")
```

### Client Request Pattern

```python
import httpx
from typing import Dict, Any
from langchain_core.tools import ToolException

class ServiceClient:
    """Base pattern for HTTP API clients."""

    def __init__(self, base_url: str, token: str, timeout: int = 30):
        self.base_url = base_url.rstrip('/')
        self.headers = {"Authorization": f"Bearer {token}"}
        self.timeout = timeout

    def _request(self, method: str, endpoint: str, **kwargs) -> Dict[str, Any]:
        """Make HTTP request with error handling."""
        url = f"{self.base_url}/{endpoint.lstrip('/')}"

        try:
            with httpx.Client(timeout=self.timeout) as client:
                response = client.request(
                    method=method,
                    url=url,
                    headers=self.headers,
                    **kwargs
                )
                response.raise_for_status()
                return response.json() if response.content else {}

        except httpx.HTTPStatusError as e:
            raise ToolException(
                f"HTTP {e.response.status_code}: {e.response.text}"
            )
        except httpx.RequestError as e:
            raise ToolException(f"Request failed: {str(e)}")
        except Exception as e:
            raise ToolException(f"Unexpected error: {str(e)}")
```

---

## Quick Reference

### Development Workflow

#### Starting a New Toolkit
1. ✅ Understand the integration requirements
2. ✅ Plan toolkit and tool structure
3. ✅ Create directory structure (toolkit → tools)
4. ✅ Implement models (Config, Input, Output)
5. ✅ Define tool metadata (tools_vars.py)
6. ✅ Implement API client (*_client.py)
7. ✅ Implement tool logic (tools.py)
8. ✅ Create toolkit (toolkit.py)
9. ✅ Write tests
10. ✅ Run linting: `make ruff-fix`
11. ✅ Run tests: `make test`
12. ✅ Update documentation
13. ✅ Create PR

#### Adding a New Tool to Existing Toolkit
1. ✅ Create tool package directory
2. ✅ Implement models.py (Config, Input)
3. ✅ Define metadata in tools_vars.py
4. ✅ Implement tool in tools.py
5. ✅ Add client if needed (*_client.py)
6. ✅ Register in toolkit.py
7. ✅ Write tests
8. ✅ Run `make ruff-fix && make test`
9. ✅ Create PR

### Common Commands

```bash
# Development
make install                # Install dependencies
make build                  # Build package

# Testing
make test                   # Run all tests
poetry run pytest tests/    # Run tests with Poetry
make coverage               # Run tests with coverage report

# Code Quality
make ruff                   # Lint and format
make ruff-fix               # Auto-fix linting issues
make ruff-format            # Format code only
make verify                 # Verify (ruff + test)

# Package Management
poetry add <package>        # Add dependency
poetry add -D <package>     # Add dev dependency
poetry update               # Update dependencies
poetry show                 # Show installed packages
```

### Project-Specific Guidelines

#### IMPORTANT: Development Constraints

1. **Tool Usage**: Only use available tools; plan actions accordingly
2. **Rationale**: Provide clear rationale before each action
3. **Comprehension**: Understand and address every aspect of requests
4. **Unit Tests**: Do NOT implement unless explicitly requested
5. **Documentation**: Do NOT generate unless explicitly requested
6. **Compilation Checks**: Do NOT run until explicitly requested
7. **Directory Operations**: NEVER use directory_tree on root; use list_directory instead

#### Efficient Workflow

1. **Get allowed directories first**
2. **Get project tree for specific directories** (not root)
3. **Choose relevant files** based on task
4. **Use `read_multiple_files`** instead of reading one-by-one

### File Templates

#### Minimal Tool Package

```
your_toolkit/
├── __init__.py
├── toolkit.py
└── your_tool/
    ├── __init__.py
    ├── models.py       # Config + Input schemas
    ├── tools.py        # Tool implementation
    ├── tools_vars.py   # Metadata
    └── client.py       # Optional: API client
```

#### Test Template

```python
import pytest
from unittest.mock import Mock, patch
from langchain_core.tools import ToolException
from codemie_tools.your_toolkit.your_tool.tools import YourTool
from codemie_tools.your_toolkit.your_tool.models import YourConfig

@pytest.fixture
def config():
    return YourConfig(url="https://test.com", api_token="test")

@pytest.fixture
def tool(config):
    return YourTool(config=config)

def test_success(tool):
    # Arrange
    expected = {"result": "success"}

    # Act
    result = tool.execute(param="value")

    # Assert
    assert result == expected

def test_failure(tool):
    with pytest.raises(ToolException):
        tool.execute(invalid="param")
```

---

## Additional Resources

### Key Files to Reference

- **Base Classes**: `src/codemie_tools/base/`
  - `base_tool.py` - Tool base class
  - `base_toolkit.py` - Toolkit base classes
  - `models.py` - Core models (ToolKit, Tool, ToolSet)
  - `utils.py` - Shared utilities
  - `exceptions.py` - Custom exceptions

- **Examples**:
  - `src/codemie_tools/core/project_management/` - Full toolkit example
  - `src/codemie_tools/itsm/` - ITSM toolkit reference
  - `src/codemie_tools/report_portal/` - Healthcheck example

- **Configuration**:
  - `pyproject.toml` - Dependencies and Poetry config
  - `pytest.ini` - Test configuration
  - `Makefile` - Development commands

### Documentation Standards

When documenting code, include:

```python
def method(self, param: str) -> dict:
    """
    Brief description of what the method does.

    Detailed explanation if needed, including:
    - Business logic
    - Important constraints
    - Usage examples

    Args:
        param: Description of parameter

    Returns:
        dict: Description of return value

    Raises:
        ToolException: When and why this is raised

    Example:
        >>> tool.method("example")
        {"result": "success"}
    """
```

---

## Troubleshooting

### Common Issues

**Issue**: Import errors when running tests
**Solution**: Ensure package is installed in editable mode: `poetry install`

**Issue**: Linting failures
**Solution**: Run `make ruff-fix` to auto-fix issues, then `make ruff` to verify

**Issue**: Tests fail with connection errors
**Solution**: Ensure external dependencies are properly mocked

**Issue**: Configuration not appearing in UI
**Solution**: Check `json_schema_extra` is properly defined and toolkit uses `DiscoverableToolkit`

**Issue**: Tool not discovered by toolkit
**Solution**: Verify tool is registered in `toolkit.py` and metadata is properly defined

---

## Version History

- **v0.1.3.2** - Current version
- Python 3.12+ support
- LangChain 0.3.25 ecosystem
- Comprehensive toolkit collection

---

## Support & Contact

For questions or issues:
- Review existing toolkit implementations in `src/codemie_tools/`
- Check test examples in `tests/codemie_tools/`
- Consult base utilities in `src/codemie_tools/base/utils.py`

---

**Remember**:
- Follow KISS and DRY principles
- Write clean, maintainable code with low complexity
- Use existing utilities before creating new ones
- Test thoroughly with proper mocking
- Document comprehensively
- Only implement tests/docs when explicitly requested
